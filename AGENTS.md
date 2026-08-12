# AGENTS.md — SAIM

## Architecture
- **3-tier monorepo:** FastAPI backend (`saim-backend/`), Flutter web frontend (`saim-frontend/`), self-hosted Supabase (`saim-supabase/`).
- **Backend entrypoint:** `saim-backend/app/main.py` — FastAPI on port 8001, all routes under `/api/v1`.
- **Frontend entrypoint:** `saim-frontend/lib/main.dart` — Riverpod + GoRouter + Supabase Auth on port 8080.
- **Database:** Supabase PostgreSQL. Backend service key is in `docker-compose.yml` (not `.env`). Frontend env lives in `lib/core/constants/env.dart`.

## Developer Commands

### Backend
```bash
cd saim-backend
uvicorn app.main:app --host 0.0.0.0 --port 8001 --reload
```

### Frontend
```bash
cd saim-frontend
flutter pub get          # install deps
flutter analyze          # lint / static analysis (only check available)
flutter test             # runs widget_test.dart placeholder only
flutter build web --release
```

### Full stack (Docker)
Supabase must be running first (starts an external network `supabase_default`):
```bash
cd saim-supabase && docker compose up -d     # first
docker compose up -d --build                 # from repo root (backend + frontend)
```

## UI Theme Rule (critical)
**Never hardcode colors** like `AppColors.navy`, `Colors.white`, etc. Always use theme-aware methods from `BuildContextThemeExt` (in `lib/core/theme/app_theme.dart`):
- `context.surfaceColor` / `context.textColor` / `context.backgroundColor` etc.
This is the only way to support light/dark mode.

## Key Conventions
- **State management:** Riverpod (`flutter_riverpod`). All providers go under `lib/core/providers/` or feature folders.
- **Routing:** GoRouter in `lib/core/router/app_router.dart`. Role-based redirect: `Tecnico` auto-routes to `/orden-campo`.
- **Auth:** Supabase Auth via `supabase_flutter`. Roles: `Administrador`, `Tecnico`.
- **Backend pattern:** Router (`app/api/router.py`) aggregates per-domain endpoint modules. Endpoints → `app/api/endpoints/`, Schemas → `app/schemas/`, Services → `app/services/`.

## Utility Scripts
- `generate_sql.py` — converts `datos.txt` (TSV) into `update_inventories.sql` inventory UPDATE statements.

## Testing & CI
- **No CI pipelines, no pre-commit hooks, no Python linter/type checker.**
- Only automated check: `flutter analyze`. No backend tests exist.
