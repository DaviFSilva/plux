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
local → git push main → Railway GitHub integration
                       → Dockerfile build (Railway Metal builder)
                       → nginx serves build/web/
                       → plux-production.up.railway.app
```

- Deploys are triggered manually via `railway up` today; GitHub App auto-deploy is the next planned change (see §5).
- Single environment: `production`. No staging, no PR previews (yet).
- Single service: `plux` (Flutter web).

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

**Decision (today)**: `main` → `production`. That's it.

**Why**: solo project, premature to maintain two deploy targets.

**When to add staging**:
- We have real users, OR
- We're about to add a destructive feature and want a safe preview, OR
- Another contributor joins.

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

---

## Open questions to revisit

- [ ] When does the FastAPI service deploy relative to the web app? Coordinated releases vs. independent?
- [ ] Do we need staging before adding the backend, or can backend land on prod with feature flags?
- [ ] When we add a database (Postgres?), how do we handle migrations in CI/CD?

---

## Change log

| Date | Change | Reason |
|---|---|---|
| 2026-09-05 | Initial pipeline: Railway-built Dockerfile + nginx static serving | First deploy validated |
| 2026-09-05 | Document created | Capture CI/CD decisions before tribal knowledge accumulates |