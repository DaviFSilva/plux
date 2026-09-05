# Plux — CI/CD Guide

> Source of truth for how we build, test, and deploy Plux.
> Update this file when a decision changes — don't accumulate tribal knowledge.

## Project context

- **App type**: Flutter web (current), FastAPI backend (planned)
- **Hosting**: Railway (`plux` project in personal workspace)
- **Repo**: `github.com/DaviFSilva/plux` (public)
- **Solo developer today** — designed to scale to a small team without rewrite
- **Deployment target**: `https://plux-production.up.railway.app`

---

## Current pipeline (as of initial deploy)

```
local → git push develop → Railway GitHub integration (planned)
                          → Dockerfile build (Railway Metal builder)
                          → nginx serves build/web/
                          → plux-dev.up.railway.app (sleeps when idle)

local → git push main → Railway GitHub integration (planned)
                       → Dockerfile build (Railway Metal builder)
                       → nginx serves build/web/
                       → plux-production.up.railway.app
```

- Two environments: `development` (sleeps) and `production`.
- Two branches: `develop` (integration) and `main` (production-ready).
- `main` only changes via PR from `develop`.
- Manual deploys today (`railway up`); GitHub App auto-deploy is the next planned change.

---

## Decisions

### 1. Where builds run — Railway, not GitHub Actions (for now)

**Decision**: Railway builds the Docker image from the Dockerfile in the repo.

**Why**:
- Already wired and working — `railway up` + Dockerfile deploys are validated.
- Solo developer doesn't need a separate quality gate before deploy yet.
- No risk of Railway build minutes vs. GitHub Actions minutes decision today.

**When to revisit**: as soon as we have >1 active branch or another collaborator, OR when we add a second service (FastAPI) and want shared CI logic. Move to GitHub Actions for the **quality gate** (analyze + test), keep Railway for the **deploy**.

### 2. Docker layer caching — use BuildKit cache mounts

**Decision**: Dockerfile uses BuildKit cache mounts for `/root/.pub-cache`.

**Why**:
- Cuts ~30s off every rebuild.
- No infra to maintain — Railway's Metal builders have BuildKit enabled.

**Implementation** (when we get to it):
```dockerfile
RUN --mount=type=cache,target=/root/.pub-cache \
    --mount=type=cache,target=/root/.dart_tool \
    flutter pub get
```

### 3. Branch → environment mapping

**Decision (today)**: two branches, two environments.

| Branch | Environment | Auto-deploy | URL |
|---|---|---|---|
| `develop` | `development` | yes (when GH App installed) | `plux-dev.up.railway.app` |
| `main` | `production` | yes (when GH App installed) | `plux-production.up.railway.app` |

**Flow**: feature work → PR to `develop` → CI green → auto-deploy to dev env → verify → PR `develop` → `main` → CI green → auto-deploy to prod.

**Why two environments**: "does this deploy on Railway?" is a question only Railway can answer. Local `flutter run` doesn't catch Dockerfile issues, env-var drift, or platform-specific bugs. The dev environment is a cheap (sleeps) rehearsal space.

**Why no staging yet**: dev + prod is enough while the project is solo and pre-users. Add staging as a third env when we need a place to validate destructive changes (DB migrations, breaking API changes) before they hit prod.

**When to add PR preview environments**:
- Multiple contributors, OR
- We want external feedback before merge (designers, beta users).

### 4. Quality gate before deploy

**Decision (today)**: none on CI. Local discipline is: run `flutter analyze && flutter test` before commit.

**When to add GitHub Actions quality gate**:
- We start using feature branches, OR
- Another collaborator joins, OR
- We add the FastAPI service and want shared test/lint commands.

The GHA workflow when added will run on PR open + push to main:
- `flutter analyze`
- `flutter test`
- `flutter build web --release` (catches build errors before Railway does)

### 5. GitHub App integration (auto-deploy on push)

**Decision (planned)**: install Railway GitHub App on `DaviFSilva/plux`.

**Why**: removes the manual `railway up` step. Push-to-deploy is the standard.

**Status**: not yet installed. Do this before adding the FastAPI service so both services deploy the same way from day one.

### 6. Railway config: migrate from `railway.toml` to IaC

**Decision (must do before 2026-12-01)**: migrate `railway.toml` to `.railway/railway.ts`.

**Why**:
- Railway deprecated TOML/JSON config-as-code; IaC is TypeScript-based.
- Lets us version-control service config, env vars, and infrastructure in git.
- Removes the build-warning we see on every deploy.

**How**: `railway config migrate`. Mechanical.

### 7. Secrets & env vars

**Decision**:
- Secrets → Railway env vars (UI or IaC), never in code.
- Repo: `.env.example` lists every var name with comments (no values).
- Backend (when added) reads from `os.environ` / `pydantic-settings`.

**When to add Vault/SOPS/etc**: only if we have >5 secrets or compliance requirements.

### 8. Healthchecks

**Decision (planned)**: add `/health` endpoint returning 200 with `{"status":"ok"}`.

**Why**: current healthcheck is `/` which always returns index.html even if nginx itself is broken. A dedicated endpoint lets Railway distinguish "container alive" from "app actually serving".

**Implementation**: tiny static file `web/health.json` + nginx route — OR for the backend, a real endpoint in FastAPI.

### 9. Build vs. start separation — keep it strict

**Decision**: each Railway service has its own Dockerfile with build-time-only toolchain.

- `plux-web` (Flutter): image has Flutter SDK at build, only nginx + static files at runtime.
- `plux-api` (FastAPI, planned): image has Python at build, slim runtime.

**Why**: don't ship the Flutter SDK (~1.5GB) in the runtime image. Keep images <200MB.

### 10. Observability

**Decision (today)**: Railway built-in logs + metrics. No external tools.

**When to add Sentry/Datadog/etc**: when users report bugs we can't reproduce. Not before.

---

## Explicitly NOT doing (yet)

- E2E tests (Flutter integration tests, Playwright). No screens with state yet.
- Multi-region deploys. Railway handles this when we need it.
- Blue-green or canary releases. Railway's zero-downtime deploys are sufficient at our scale.
- Security scanning (Trivy, Snyk). Base images are official (`nginx:1.27-alpine`, official Python). Revisit if we add custom base images.
- Kubernetes. We're on Railway on purpose.
- Staging environment. Dev + prod is enough while pre-users. Add when destructive changes need a safe landing.
- Feature branches for everything. Solo + small features = commit to `develop` directly. Add `feature/*` branches when changes take > 1 day or have a reviewer.
- Auto-promote from `develop` to `main`. Promotion is a deliberate act (PR), not automatic.

---

## Open questions to revisit

- [ ] When does the FastAPI service deploy relative to the web app? Coordinated releases vs. independent?
- [ ] Do we need staging before adding the backend, or can backend land on prod with feature flags?
- [ ] When we add a database (Postgres?), how do we handle migrations in CI/CD?
- [ ] **Solo-PR limitation**: how do we handle main-branch changes that aren't PR-able (hotfixes, CI/CD config)? Options: (a) accept that the only collaborator is yourself and use `gh api -X DELETE` on branch protection, push, restore protection; (b) install a self-approval GitHub App (e.g., `pull-assistant`); (c) move to GitHub organization. None great — pick when it bites.

---

## Change log

| Date | Change | Reason |
|---|---|---|
| 2026-09-05 | Initial pipeline: Railway-built Dockerfile + nginx static serving | First deploy validated |
| 2026-09-05 | Document created | Capture CI/CD decisions before tribal knowledge accumulates |
| 2026-09-05 | Added two-branch / two-environment model (`develop` → dev env, `main` → prod) | Want a Railway-hosted dev surface for testing; main protected via PR |
| 2026-09-05 | Added local-dev discipline (docker-compose, .env.example, seed data, fresh-clone checklist) | Production CI/CD alone wasn't enough — daily friction accumulates silently |
| 2026-09-05 | Wired Railway GitHub integration; prod auto-deploys on push to `main`, dev on `develop` | Removes manual `railway up` step |
| 2026-09-05 | Discovered solo-project PR limitation: GitHub rejects self-approval on personal repos even with bypass allowance | Working around with a documented workaround (temporary protection disable + direct push for solo-maintenance changes), or accepting trivial test commits |
| 2026-09-05 | Added GitHub Actions quality gate (`.github/workflows/ci.yml`) | Two jobs: analyze+test (fast), build-release (catches Dockerfile issues). Both branches require both checks on PRs. ~3min total runtime. Verified by deliberately-failing PR that GitHub blocked merge. |
| 2026-09-05 | Added `/health` endpoint (nginx route + Railway healthcheckPath) | Verified live: GET /health → 200 `{"status":"ok"}`. Railway now distinguishes "container alive and nginx serving" from generic index.html serve. |
| 2026-09-05 | Migrated `railway.toml` → `.railway/railway.ts` (IaC) | Migration produced canonical IaC file. `railway config apply` blocked by a Railway tooling gap (npm SDK doesn't ship the IaC submodule that newer CLIs gate on). File is correct and will activate when tooling matures. Deprecation warning may persist until then. |