# Plux — CI/CD Structure

> Conceptual blueprint for how the CI/CD pipeline is organized and why.
> Read this once to understand the shape; refer back when adding a new stage.
> For *what we decided for Plux specifically*, see [ci-cd.md](./ci-cd.md).

---

## Table of contents

1. [The pipeline at a glance](#the-pipeline-at-a-glance)
2. [Layers of the pipeline](#layers-of-the-pipeline)
3. [Build vs. artifact vs. cache](#build-vs-artifact-vs-cache)
4. [Environments and promotion](#environments-and-promotion)
5. [Rollback strategy](#rollback-strategy)
6. [Quality gates and test placement](#quality-gates-and-test-placement)
7. [Idempotency](#idempotency)
8. [Approval gates](#approval-gates)
9. [Database migrations](#database-migrations)
10. [Trunk-based development](#trunk-based-development)
11. [Measuring the pipeline](#measuring-the-pipeline)
12. [Local development](#local-development)
13. [The dev/staging/prod environment split](#the-devstagingprod-environment-split)
14. [Branch lifecycle: feature → main → prod](#branch-lifecycle-feature--main--prod)
15. [What "good" looks like for Plux](#what-good-looks-like-for-plux)

---

## The pipeline at a glance

A modern CI/CD pipeline is a series of stages, each doing one thing well, each producing a signal the next stage consumes. The whole point is to fail fast: catch cheap problems early (lint, unit tests), expensive problems late (integration, deploy).

```
┌──────────┐   ┌────────┐   ┌─────────────┐   ┌────────┐   ┌──────────┐
│  Commit  │──▶│  Lint  │──▶│   Build     │──▶│  Test  │──▶│  Deploy  │
└──────────┘   └────────┘   └─────────────┘   └────────┘   └──────────┘
                                                          │
                       ┌──────────────┐                   ▼
                       │  Smoke test  │◀──── production traffic ────▶
                       └──────────────┘
                                          (continuous, not a stage)
```

**Key insight**: the stages aren't all about code. "Test" can include security scans, accessibility checks, bundle-size budgets. "Deploy" can include asset uploads, cache purges, DNS updates. Add stages as you find new things that need a gate.

---

## Layers of the pipeline

Think of it as **four layers**, not eight stages. Each layer answers a different question:

| Layer | Question it answers | Speed | Where it runs |
|---|---|---|---|
| **Local feedback** | "Did I break anything obvious?" | <10s | IDE, pre-commit hook, `flutter analyze` |
| **Continuous Integration** | "Does my change integrate with everyone else's?" | <5min | GitHub Actions / Railway build |
| **Continuous Delivery** | "Is this release-ready?" | minutes | Same — but with deploy gates |
| **Continuous Deployment** | "Is this ready to ship?" | automatic | Production on green pipeline |

Most teams conflate CI and CD. The distinction matters: **CI is a question, CD is a deployment policy.** A pipeline can have great CI and zero CD (manual deploy button), or auto-CD (deploys on every green build). They're independent.

For Plux today: **CI yes, CD manual** (we run `railway up` ourselves).

---

## Build vs. artifact vs. cache

These three terms get conflated constantly. They're different:

| Term | What it is | Lifetime | Example |
|---|---|---|---|
| **Build** | The act of compiling/packaging | One-time per pipeline run | `flutter build web` |
| **Artifact** | The output of a build — the thing you ship | Stored, versioned, deployable | `build/web/` tarball, Docker image `sha256:abc...` |
| **Cache** | Reusable intermediate state to skip work next time | Hours-days, expires | `/root/.pub-cache`, Docker layer cache |

**The single most important rule**: the artifact you ship to production must be **exactly** the artifact that passed CI. Bit-for-bit. Same hash.

This is why we tag Docker images with the git SHA — `plux-web:9201da2` — and never rebuild between CI and prod. The moment you rebuild, you've lost reproducibility.

Railway's Metal builder does this implicitly: the image SHA from build IS what runs in prod. If we move to GitHub Actions, we need to either push to a registry (Docker Hub, GHCR) or use Railway's deploy-from-artifact API.

---

## Environments and promotion

An **environment** is a deployment target with its own config, data, and traffic. The pattern:

```
PR branch ──▶ Preview env (auto-created, ephemeral)
       │
       └──▶ main ──▶ Staging ──▶ Production
                          │
                          └─── optional: canary 5% ──▶ full
```

Each environment should be:
- **Cheap to create** (otherwise you won't make preview envs)
- **Isolated data** (a test in staging must not touch prod data)
- **Identical shape** (same Dockerfile, same env var schema, same start command — only data differs)

**Promotion** means deploying the same artifact to the next environment, not rebuilding. If staging was built from commit `9201da2`, prod must also be commit `9201da2` — never "the latest main".

When do we add environments to Plux?
- Preview per PR: when there's an external reviewer who needs to click around
- Staging: when there's a destructive change worth previewing with real-ish data
- Canary: when traffic justifies the complexity (5%+ of millions of requests)

---

## Rollback strategy

When prod breaks, you have roughly these options, in order of how fast they are:

| Strategy | Time to recover | When to use | Trade-off |
|---|---|---|---|
| **Re-deploy previous artifact** | ~2 min | Default. Always works. | None for stateless services |
| **Feature flag kill** | seconds | When the bug is in a new feature | Requires flags wired up |
| **Hotfix forward** | minutes | When rollback would break something else | Risk of introducing new bug |
| **Database rollback** | hours-to-impossible | When DB migration caused it | Often impossible — see §9 |

The "always works" rule for stateless web apps: **never try to be clever.** Hit the redeploy button. If that doesn't work, then escalate.

For Plux: Railway has `railway redeploy` that pulls the previous successful artifact. Practice this once on a non-critical change before you need it under pressure.

---

## Quality gates and test placement

Not all tests run in the same place. Different tests catch different bugs at different costs:

```
Cheap & fast ────────────────────────────────────▶ Expensive & slow

Unit tests    Integration   Contract    Smoke       E2E       Load
(unit/)       (integration/) (pact/)    (post-deploy) (browser/) (k6/)
   │              │             │            │           │          │
   ▼              ▼             ▼            ▼           ▼          ▼
Every PR       Every PR     PR + merge   After deploy  Nightly    Weekly
<10s           <60s         <2min        seconds       5-30min    hours
```

**Rule of thumb**: if a test is slow, it should run less often. If it's flaky, fix it before it earns a place in the pipeline.

For Plux today, almost all tests are unit/widget tests — fast, run on every PR (when we have PRs). Smoke tests = curl the URL after deploy and check the body contains "Plux". E2E we add when there's a screen worth testing.

---

## Idempotency

A deploy is idempotent if running it twice produces the same end state. Example:

- ✅ Copy `build/web/` to nginx → idempotent (file ends up the same)
- ❌ `INSERT INTO users (id, name) VALUES (1, 'davi')` → not idempotent (second run fails or duplicates)

Why this matters:
- **Retry safety**: deploys fail for transient reasons (network blip, registry hiccup). Idempotent deploys can be retried.
- **Concurrent safety**: two deploys racing each other shouldn't corrupt state.
- **Audit clarity**: re-running an old deploy should produce the same world.

Database migrations are the classic trap. See §9.

---

## Approval gates

Who (or what) can push to production?

| Pattern | Who approves | Speed | Use when |
|---|---|---|---|
| **Auto** | Nobody (CI green = deploy) | seconds | High trust in tests, low blast radius |
| **Manual button** | A human clicks deploy | minutes | Default. Adds review time. |
| **Required reviewers** | N humans must approve | hours | Regulated, high-blast-radius |
| **Window-based** | Only during business hours | varies | Stability > speed |

For Plux today: **manual button**. `railway up` is the gate.

When we add CI with auto-deploy on green, the "approval" moves from "the human runs up" to "the human merges the PR". Different gate, same idea.

---

## Database migrations

Hardest part of CI/CD. The trap: schema changes are stateful.

**Two patterns that work**:

**1. Expand-contract (recommended)** — every change is two deploys:
```
Deploy 1: add new column (nullable, no code uses it yet)
Deploy 2: code writes to new column
Deploy 3: code reads from new column (defaults to old column)
Deploy 4: drop old column
```
Each step is reversible. Each step is idempotent. The trick: every deploy leaves the system in a working state, even if you stop mid-migration.

**2. Forward-only with strong rollback discipline** — write migrations that always work going forward, never need to roll back. New column always with default value. No renames (add new, copy, switch, drop old).

**What never works**: a migration that's "supposed to work" but only if you don't roll back. This is how you get production data loss.

When to add this to Plux? When we add the Postgres database. Before that, there's no DB to migrate.

---

## Trunk-based development

Short-lived branches (< 1 day, ideally hours), merge to main often, use feature flags to hide incomplete work.

The intuition:
- Long-lived branches diverge. Merge conflicts get huge. Integration risk goes up the longer you wait.
- If main is always deployable, your deploy story is trivial. If main is sometimes broken, your deploy story involves picking the right commit.

**Practical rules for solo dev**:
- One branch: `main`. Commit directly. Done.
- If a feature takes more than a day, use a feature flag to hide it, merge to main, ship the flag-off version.

When to introduce feature branches: when there's another contributor or when a feature needs review before merge.

---

## Measuring the pipeline

Four numbers, called **DORA metrics**, predict engineering performance better than anything else:

| Metric | What it measures | Elite |
|---|---|---|
| **Deployment Frequency** | How often you ship | on-demand (multiple per day) |
| **Lead Time for Changes** | Commit → production | < 1 hour |
| **Change Failure Rate** | % of deploys that cause a rollback | 0-15% |
| **Mean Time to Recovery** | Failed deploy → restored | < 1 hour |

You don't need to track these from day one. But knowing what "good" looks like gives you a yardstick. The four metrics are correlated — improving one tends to improve the others.

For Plux: not measuring yet. When we have prod users and a real failure, start tracking time-to-detect + time-to-recover. That's the foundation.

---

## Local development

Production CI/CD is the part that wakes you up at 2am. Local development is the part you touch every day — and "just open the IDE" silently accumulates friction. Env vars, ports, database state, seed data, hot reload paths. The friction kills velocity long before production does.

The goal: **a fresh clone should produce a working app with sample data in under 10 minutes.**

### The three modes

You'll be doing one of these at any given moment, often switching between them in the same day:

| Mode | What you're working on | What runs |
|---|---|---|
| **Web only** | Flutter UI, screens, widgets | Local Flutter web (Chrome) |
| **API only** | FastAPI endpoint, business logic | Local uvicorn + local Postgres |
| **Integration** | Both together, end-to-end | All three running, web talking to API |

Each mode needs its own quick start. Don't try to make one command do all three.

### Recommended setup: docker-compose for services, host for tools

```
┌─────────────────────────────────────────────────────┐
│  Host machine                                       │
│                                                     │
│  ┌─────────────┐   ┌──────────────┐                 │
│  │ Flutter web │──▶│ FastAPI      │                 │
│  │ (hot reload)│   │ (uvicorn)    │                 │
│  └─────────────┘   └──────┬───────┘                 │
│                           │                         │
│                  ┌────────▼─────────┐               │
│                  │ Postgres         │               │
│                  │ (docker-compose) │               │
│                  └──────────────────┘               │
└─────────────────────────────────────────────────────┘
```

Why this split:
- **Flutter web on host**: hot reload is fastest, no container overhead, debug tooling (DevTools) works natively.
- **Postgres in container**: one command to start/stop/reset, matches Railway's managed Postgres closely enough that dev-prod drift is small.
- **FastAPI on host** (early) → in container (later): when API is trivial, host is faster. When it has a Dockerfile, container matches prod better.

### `.env.example` discipline

Every env var the app reads must be in `.env.example` in the repo, with a comment explaining what it's for. No values — only names and documentation.

```
# .env.example
DATABASE_URL=           # postgres://user:pass@host:5432/dbname
API_PORT=                  # what port FastAPI binds to
WEB_API_BASE_URL=          # where Flutter web fetches the API from
LOG_LEVEL=                 # info | debug | warning
```

The rule: **if it's in the code, it's in `.env.example`.** New env var PRs without `.env.example` updates get rejected.

### Seed data

A fresh dev environment should not be empty. Empty DBs hide bugs (you write code that assumes the DB is never empty). Seed script that creates:
- One user (you)
- Two flashcard decks with 5 cards each
- One journal entry

Located at `apps/api/scripts/seed.py` (or equivalent). Run with `make seed` or `python -m scripts.seed`. Idempotent: running twice = same end state.

### "Fresh clone to first run" checklist

When a new person (or future-you in 6 months) clones the repo:

1. `cp .env.example .env` and fill in values
2. `docker compose up -d postgres`
3. `make seed` (or equivalent)
4. `flutter run -d chrome` (web-only mode)
5. `uvicorn app.main:app --reload` (API-only mode)
6. Open `http://localhost:3000` → see Plux with sample data

The checklist should be in `README.md`. If it can't be done in 10 minutes on a fresh machine, the setup has drifted and needs fixing before adding the next feature.

### What's intentionally NOT in local dev

- Kubernetes manifests. If we use k8s someday, dev runs against minikube — but we're on Railway, no k8s.
- Service mesh. Way overkill.
- Production secrets. Dev uses throwaway credentials.

---

## The dev/staging/prod environment split

Three environments, each with a purpose. The mistake is treating them as "the same thing with different env vars" — they're different *systems* with different rules.

| Environment | Data | Stability | Cost | Audience |
|---|---|---|---|---|
| **Dev** (Railway) | Synthetic, reset nightly | Acceptable to break | Low (sleeps) | Just you |
| **Staging** | Synthetic, persistent | Should mirror prod | Medium | You + occasional reviewers |
| **Production** | Real | Must not break | Whatever it takes | Real users |

### Dev environment

A real Railway environment that mirrors prod's shape (same Dockerfile, same env var schema) but with synthetic data and looser rules:
- Auto-deploys on every push to `develop` branch
- Sleeps when idle (Railway's scale-to-zero) so it costs almost nothing
- Reset nightly — any data you cared about, you should have saved
- CORS wide open, debug logs on

Purpose: **test things on the real platform without affecting prod.** "Does this actually deploy to Railway?" is a question that only Railway can answer. Local `flutter run` doesn't.

### Staging environment

Production's twin, used to validate changes *before* they hit prod:
- Same Dockerfile, same env vars, same start command
- Deploys via PR-merge-to-main (or manual promote)
- Persistent data (synthetic, but realistic in shape and volume)
- Sentry on, but errors tagged `env=staging`

Purpose: **catch integration bugs before users do.** The thing staging catches that local dev doesn't: timing issues under real network conditions, env-var typos that only manifest after a fresh build, CORS rules that production needs but local doesn't.

### Production environment

What users hit. Auto-deploys on main after CI green + manual approval. Everything else is rehearsal.

### The promotion rule

The same artifact (same Docker image SHA, same git SHA) must move dev → staging → prod. Never rebuild between environments.

```
git SHA 9201da2 ──▶ built once ──▶ deployed to dev (sleeps)
                                ──▶ deployed to staging (after CI green)
                                ──▶ promoted to prod (manual approve)
```

If staging finds a bug, you commit a fix → new SHA → the chain starts over. Never "patch staging directly".

### Cost reality

Three Railway environments costs more than one. Mitigations:
- Dev sleeps when idle (scale-to-zero) → ~$0/month idle
- Staging uses the smallest Railway plan → ~$5/month
- Prod scales with traffic

For a solo project with no users yet, dev + prod is enough. Add staging when you have external reviewers or want to test migrations safely.

---

## Branch lifecycle: feature → main → prod

The flow that ties local dev → environments → prod together.

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ feature/foo  │───▶│ develop      │───▶│ main         │───▶ prod
└──────────────┘    └──────────────┘    └──────────────┘
       │                  │                   │
   dev env            dev env            staging env
  (per-PR or          (auto)             (auto on merge)
   manual push)            │
                       auto-deploy
```

### Branches

- **`main`** — production-ready code. Always deployable. Auto-deploys to **prod** (later: after CI gate).
- **`develop`** — integration branch. Features land here first. Auto-deploys to **dev** environment.
- **`feature/<name>`** — short-lived branches for individual features. Live < 3 days. PRs target `develop`.

### The rule: main is sacred

`main` only changes via PR. PRs to `main` require:
- CI green (analyze + test + build check)
- Reviewer approval (later — for now: just your own approval)
- Squash merge (linear history, easy to revert)

`develop` is more permissive: direct pushes OK, fast-forward merges preferred, lighter review. Its purpose is "integration happens here, prod doesn't see it until main".

### Why this matters

The moment you have two environments, the question "what's running in prod?" becomes answerable: it's whatever's on `main`. The moment `develop` exists, the question "what's the next release?" becomes answerable: it's whatever's at the tip of `develop` that hasn't merged to `main` yet.

Without this discipline, prod is "whatever I last deployed, I think" — and you find out it's wrong when something breaks.

### When to introduce this

- `develop` + dev env: as soon as you start using Railway as a real test surface. That's now.
- `feature/*` branches: when a feature takes more than a day, OR when you want CI to run before merging. Solo + small features = skip the branch, commit to develop directly.

The full feature-branch → develop → main flow is what we'll converge to. The minimum viable version (commit directly to develop, no feature branches) is what we start with.

---

## What "good" looks like for Plux

Concretely, what we're building toward (not all at once):

**Today (prototype — now extended)**:
- `develop` branch auto-deploys to Railway **dev** environment (sleeps when idle, ~$0)
- `main` branch auto-deploys to Railway **production** environment
- Two Railway environments: dev + prod
- Local dev: Flutter web on host (`flutter run -d chrome`), Postgres in docker-compose, API on host when added
- `.env.example` defines every env var; `.env` is local-only and gitignored
- `flutter analyze && flutter test` before commit
- Manual promotion: PR from `develop` → `main` triggers production deploy
- Rollback = `railway redeploy` to previous SHA
- Same artifact promoted across environments (no rebuild between dev and prod)

**When we add the FastAPI backend**:
- `docker-compose.yml` adds the API service with hot reload
- API has `/health` endpoint, web still uses `/`
- Coordinated release: web and API deploy from same commit SHA
- Local "integration mode" runs all three together

**When we have users**:
- GitHub Actions quality gate (analyze + test + build check) before PR merge to main
- Auto-deploy to prod on main merge (after CI green)
- Smoke test after deploy (`curl /health`)
- Add staging environment as a third Railway env
- Basic Sentry integration, errors tagged by env

**When we have a database**:
- Migrations live in `apps/api/migrations/`, run as a separate Railway service
- All migrations are expand-contract (forward-only, never break prod on rollback)
- Backups run nightly, tested monthly
- Dev DB resets nightly via cron

**When we have >1 contributor**:
- Feature branches required for changes > 1 day
- Required CI green + reviewer before merge to develop
- Preview envs per PR (Railway PR integration)
- Branch protection rules on main

---

## Open questions

- [ ] When we add Postgres, do we run migrations as a separate Railway service or a startup hook? (Startup hook is simpler but blocks the app from booting on a broken migration; separate service decouples them but adds complexity.)
- [ ] For Flutter web, what's the bundle-size budget? Anything over 5MB should warn. Anything over 10MB should fail.
- [ ] When the FastAPI backend lands, do we deploy both services from the same commit, or allow independent deploys?

---

## How this doc evolves

This file is a **blueprint** — the *shape* of the pipeline. It changes slowly. For *current Plux-specific decisions*, see `ci-cd.md`. When you disagree with something here, update it — but mark the change in the change log so we can see the conceptual evolution.