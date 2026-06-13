# Medhavi ERP — Enterprise Resource Planning System

Foundation scaffold for Medhavi Skills University. See `/docs` for architecture specifications.

## Quick Start

```bash
pnpm install
cp .env.example .env
pnpm docker:up
pnpm db:generate
pnpm db:migrate
pnpm dev
```

API: http://localhost:4000 | Web: http://localhost:3000

## Project Structure

- `backend/api` — NestJS REST API
- `backend/worker` — BullMQ async processors
- `frontend/web` — Next.js 14 frontend
- `packages/*` — Shared libraries (types, utils, validation, RBAC, config)
- `infrastructure/` — Docker, K8s, Terraform configs
- `docs/` — Architecture and reference documentation
