# Demo deployment (HTTPS + Neon)

Target: Android APK demo without a developer machine. Backend runs on a free
Node host (Render or equivalent). Database is Neon PostgreSQL. Secrets never
enter the Flutter APK.

## 1. Neon

1. Create a Neon project and copy the pooled `DATABASE_URL`.
2. Keep SSL params from Neon as provided.

## 2. Backend environment

Set these on the host (not in git, not in Flutter):

| Variable | Required | Notes |
|---|---|---|
| `DATABASE_URL` | yes | Neon connection string |
| `JWT_SECRET` | yes | >= 32 random chars |
| `TICKET_QR_SECRET` | yes | independent secret |
| `PORT` | host-managed | usually injected |
| `CORS_ORIGINS` | recommended | app origins or `*` for demo only |
| `GEMINI_API_KEY` | for AI demo | omit only if chat/vision disabled |
| `GEMINI_MODEL` | optional | default `gemini-3.5-flash-lite` |
| `GEMINI_VISION_MODEL` | optional | defaults to `GEMINI_MODEL` |
| `XENDIT_*` | optional | payment demo only |

## 3. Deploy Express

### Docker (preferred)

```powershell
docker build -t kai-access-api .
docker run --env-file .env -p 3000:3000 kai-access-api
```

Entrypoint runs:

1. `npx prisma migrate deploy`
2. `node dist/app.js`

Seed and timetable import are intentionally separate operations. They must not
run on every container restart.

### Render Blueprint

The repository root contains `render.yaml`. Create a Render Blueprint from the
`MJohan-Dev3` branch. The Blueprint:

- deploys only `timetable_backend` from this monorepo;
- runs migrations before startup;
- uses `/ready` as the database-aware health check;
- runs seed and the February 2026 import once through `initialDeployHook`;
- generates JWT and ticket QR secrets in Render;
- prompts for Neon, Gemini, and Xendit values without storing them in Git.

If the one-time hook must be repeated, run these commands from a trusted
machine with the production `DATABASE_URL`:

```powershell
$env:DATABASE_URL="postgresql://..."
npx prisma db seed
npm run timetable:import -- prisma/data/commuter-2026-02.json
```

## 4. Timetable dataset

Seed loads catalog, network, platform rules, and legacy schedule fixtures.
The February 2026 commuter snapshot import is separate and idempotent for the
dataset version. Both commands use the same Neon `DATABASE_URL`.

## 5. Smoke checks

```text
GET  https://<host>/health
GET  https://<host>/ready
GET  https://<host>/api/v1/stations?limit=5
POST https://<host>/api/v1/routes/plan
GET  https://<host>/api/v1/schedules?station=Manggarai&limit=5
POST https://<host>/api/v1/assistant/chat
```

Expected:

- `/health` returns `{ "success": true, "data": { "status": "ok" } }`
- `/ready` checks Neon and reports only boolean feature readiness
- disconnected routes return structured errors (no dummy path)
- missing platform rules return empty `platform` (UI shows **Peron belum tersedia**)
- without `GEMINI_API_KEY`, chat/vision return structured AI-not-configured errors

Run all public smoke checks with:

```powershell
npm run smoke:production -- https://<host>/api/v1
```

For the full demo, require configured AI and Xendit:

```powershell
$env:REQUIRE_AI="true"
$env:REQUIRE_PAYMENT="true"
npm run smoke:production -- https://<host>/api/v1
```

## 6. Cold start

Free hosts may sleep. First request can take 15–30s. Mobile clients use a 25s
request timeout and show **Server sedang aktif** + **Coba Lagi**. Do not treat
timeout as an empty station/schedule list.

## 7. Release APK

Release builds require a private upload keystore. Keep
`android/key.properties` and `android/app/upload-keystore.jks` local; both are
ignored by Git. `android/key.properties.example` documents the required keys.

From the Flutter project root:

```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://<host>/api/v1
```

Install the APK on a physical Android device with no USB debugging dependency.
Verify map, route preview, schedule/Peron copy, auth login/refresh, assistant
chat, and camera guide stop-on-background.
