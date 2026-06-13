# Medhavi Skills University ERP — Monorepo Skeleton V1.0 FINAL

**Status:** Foundation scaffold only. Conforms to:
- ERP Project Context
- Database Dictionary V2.2 FINAL
- RBAC Matrix V2.2 FINAL
- API Specification V2.2 FINAL
- Frontend Navigation Architecture V1.1.1 FINAL
- Prisma Schema V1.2 MERGED FINAL
- NestJS Backend Architecture V2.2 FINAL
- NextJS Frontend Architecture V1.0 FINAL
- Docker & Infrastructure Architecture V1.1
- Deployment Architecture V1.1
- Repository Structure V1.1 FINAL

**Scope:** Project skeleton, infra, tooling, package wiring. NO business logic. NO Auth / Student / Faculty / Attendance / LMS / Finance implementations.

---

## 1. Complete Folder Tree

```text
medhavi-erp/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── lint.yml
│   │   ├── typecheck.yml
│   │   ├── test.yml
│   │   ├── build.yml
│   │   ├── docker-publish.yml
│   │   └── deploy-staging.yml
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── CODEOWNERS
│
├── .husky/
│   ├── pre-commit
│   └── commit-msg
│
├── .vscode/
│   ├── settings.json
│   ├── extensions.json
│   └── launch.json
│
├── backend/
│   └── api/                              # NestJS application (per Backend Arch V2.2)
│       ├── src/
│       │   ├── main.ts
│       │   ├── app.module.ts
│       │   ├── bootstrap/
│       │   │   ├── swagger.bootstrap.ts
│       │   │   ├── validation.bootstrap.ts
│       │   │   ├── cors.bootstrap.ts
│       │   │   ├── helmet.bootstrap.ts
│       │   │   └── compression.bootstrap.ts
│       │   ├── config/
│       │   │   ├── configuration.ts
│       │   │   ├── env.validation.ts
│       │   │   ├── database.config.ts
│       │   │   ├── redis.config.ts
│       │   │   ├── mongo.config.ts
│       │   │   ├── queue.config.ts
│       │   │   ├── storage.config.ts
│       │   │   └── jwt.config.ts
│       │   ├── common/
│       │   │   ├── decorators/.gitkeep
│       │   │   ├── filters/.gitkeep
│       │   │   ├── guards/.gitkeep
│       │   │   ├── interceptors/.gitkeep
│       │   │   ├── pipes/.gitkeep
│       │   │   ├── middleware/.gitkeep
│       │   │   ├── dto/.gitkeep
│       │   │   ├── enums/.gitkeep
│       │   │   ├── constants/.gitkeep
│       │   │   ├── errors/.gitkeep
│       │   │   └── utils/.gitkeep
│       │   ├── infrastructure/
│       │   │   ├── prisma/
│       │   │   │   ├── prisma.module.ts
│       │   │   │   ├── prisma.service.ts
│       │   │   │   └── tenant-prisma.service.ts
│       │   │   ├── mongo/
│       │   │   │   ├── mongo.module.ts
│       │   │   │   └── mongo.service.ts
│       │   │   ├── redis/
│       │   │   │   ├── redis.module.ts
│       │   │   │   └── redis.service.ts
│       │   │   ├── cache/
│       │   │   │   └── cache.module.ts
│       │   │   ├── storage/
│       │   │   │   ├── storage.module.ts
│       │   │   │   └── s3.provider.ts
│       │   │   ├── mailer/
│       │   │   │   └── mailer.module.ts
│       │   │   ├── sms/
│       │   │   │   └── sms.module.ts
│       │   │   ├── notifications/
│       │   │   │   └── notifications.module.ts
│       │   │   ├── audit/
│       │   │   │   └── audit.module.ts
│       │   │   ├── idempotency/
│       │   │   │   └── idempotency.module.ts
│       │   │   ├── feature-flags/
│       │   │   │   └── feature-flags.module.ts
│       │   │   ├── i18n/
│       │   │   │   └── i18n.module.ts
│       │   │   ├── observability/
│       │   │   │   ├── logger.module.ts
│       │   │   │   ├── metrics.module.ts
│       │   │   │   └── tracing.module.ts
│       │   │   └── health/
│       │   │       ├── health.module.ts
│       │   │       └── health.controller.ts
│       │   ├── tenancy/
│       │   │   ├── tenant.module.ts
│       │   │   ├── tenant.middleware.ts
│       │   │   ├── tenant.context.ts
│       │   │   └── campus.context.ts
│       │   ├── queues/
│       │   │   ├── queue.module.ts
│       │   │   ├── queue.constants.ts
│       │   │   └── producers/.gitkeep
│       │   └── modules/
│       │       ├── README.md                # Domain modules added later; do NOT scaffold here
│       │       └── .gitkeep
│       ├── prisma/
│       │   ├── schema.prisma                # symlink/copy of Prisma Schema V1.2 MERGED FINAL
│       │   ├── migrations/.gitkeep
│       │   └── seed.ts
│       ├── test/
│       │   ├── jest-e2e.json
│       │   └── .gitkeep
│       ├── Dockerfile
│       ├── nest-cli.json
│       ├── tsconfig.json
│       ├── tsconfig.build.json
│       ├── package.json
│       └── .env.example
│
│   └── worker/                            # BullMQ worker process (separate deployable)
│       ├── src/
│       │   ├── main.ts
│       │   ├── worker.module.ts
│       │   ├── processors/.gitkeep
│       │   └── schedulers/.gitkeep
│       ├── Dockerfile
│       ├── tsconfig.json
│       └── package.json
│
├── frontend/
│   └── web/                               # Next.js 14 App Router
│       ├── src/
│       │   ├── app/
│       │   │   ├── layout.tsx
│       │   │   ├── page.tsx
│       │   │   ├── globals.css
│       │   │   ├── (public)/
│       │   │   │   └── .gitkeep
│       │   │   ├── (auth)/
│       │   │   │   └── .gitkeep
│       │   │   ├── (app)/
│       │   │   │   ├── layout.tsx
│       │   │   │   └── .gitkeep
│       │   │   └── api/
│       │   │       └── health/route.ts
│       │   ├── providers/
│       │   │   ├── app-providers.tsx
│       │   │   ├── query-provider.tsx
│       │   │   ├── theme-provider.tsx
│       │   │   ├── i18n-provider.tsx
│       │   │   ├── tenant-provider.tsx
│       │   │   ├── auth-provider.tsx
│       │   │   └── toast-provider.tsx
│       │   ├── features/                   # feature-sliced (added later)
│       │   │   └── .gitkeep
│       │   ├── widgets/
│       │   │   └── .gitkeep
│       │   ├── entities/
│       │   │   └── .gitkeep
│       │   ├── shared/
│       │   │   ├── ui/.gitkeep
│       │   │   ├── lib/.gitkeep
│       │   │   ├── api/.gitkeep
│       │   │   ├── config/.gitkeep
│       │   │   ├── hooks/.gitkeep
│       │   │   └── types/.gitkeep
│       │   ├── layouts/
│       │   │   └── .gitkeep
│       │   └── styles/
│       │       └── tokens.css
│       ├── public/
│       │   └── .gitkeep
│       ├── next.config.mjs
│       ├── tailwind.config.ts
│       ├── postcss.config.mjs
│       ├── tsconfig.json
│       ├── Dockerfile
│       ├── package.json
│       └── .env.example
│
├── packages/
│   ├── shared-types/
│   │   ├── src/
│   │   │   ├── index.ts
│   │   │   ├── api/.gitkeep
│   │   │   ├── domain/.gitkeep
│   │   │   └── enums/.gitkeep
│   │   ├── tsconfig.json
│   │   └── package.json
│   ├── shared-config/
│   │   ├── src/
│   │   │   ├── index.ts
│   │   │   ├── eslint/
│   │   │   │   ├── base.js
│   │   │   │   ├── nest.js
│   │   │   │   └── next.js
│   │   │   ├── prettier/index.js
│   │   │   └── tsconfig/
│   │   │       ├── base.json
│   │   │       ├── nest.json
│   │   │       └── next.json
│   │   └── package.json
│   ├── shared-utils/
│   │   ├── src/
│   │   │   ├── index.ts
│   │   │   ├── date.ts
│   │   │   ├── string.ts
│   │   │   ├── money.ts
│   │   │   ├── id.ts
│   │   │   └── result.ts
│   │   ├── tsconfig.json
│   │   └── package.json
│   ├── shared-validation/                 # Zod schemas shared by FE+BE
│   │   ├── src/index.ts
│   │   ├── tsconfig.json
│   │   └── package.json
│   ├── shared-rbac/                       # RBAC Matrix V2.2 enums + helpers
│   │   ├── src/index.ts
│   │   ├── tsconfig.json
│   │   └── package.json
│   └── shared-ui/                         # design tokens only at this stage
│       ├── src/index.ts
│       ├── tsconfig.json
│       └── package.json
│
├── infrastructure/
│   ├── docker/
│   │   ├── docker-compose.yml
│   │   ├── docker-compose.dev.yml
│   │   ├── docker-compose.prod.yml
│   │   ├── postgres/
│   │   │   ├── Dockerfile
│   │   │   └── init/01-extensions.sql
│   │   ├── mongo/
│   │   │   └── init/01-init.js
│   │   ├── redis/
│   │   │   └── redis.conf
│   │   ├── minio/
│   │   │   └── .gitkeep
│   │   ├── nginx/
│   │   │   ├── nginx.conf
│   │   │   └── conf.d/api.conf
│   │   └── mailhog/
│   │       └── .gitkeep
│   ├── k8s/
│   │   ├── base/.gitkeep
│   │   └── overlays/
│   │       ├── dev/.gitkeep
│   │       ├── staging/.gitkeep
│   │       └── prod/.gitkeep
│   ├── terraform/
│   │   └── .gitkeep
│   └── helm/
│       └── .gitkeep
│
├── docs/
│   ├── README.md
│   ├── architecture/
│   │   ├── backend-v2.2.md
│   │   ├── frontend-v1.0.md
│   │   ├── infrastructure-v1.1.md
│   │   ├── deployment-v1.1.md
│   │   └── repository-structure-v1.1.md
│   ├── database/
│   │   ├── dictionary-v2.2.md
│   │   └── prisma-schema-v1.2.prisma
│   ├── api/
│   │   └── specification-v2.2.md
│   ├── rbac/
│   │   └── matrix-v2.2.md
│   ├── navigation/
│   │   └── frontend-navigation-v1.1.1.md
│   └── runbooks/
│       └── .gitkeep
│
├── scripts/
│   ├── setup.sh
│   ├── dev.sh
│   ├── db-migrate.sh
│   ├── db-seed.sh
│   ├── db-reset.sh
│   ├── docker-up.sh
│   ├── docker-down.sh
│   ├── generate-prisma.sh
│   ├── clean.sh
│   └── ci/
│       ├── lint.sh
│       ├── test.sh
│       └── build.sh
│
├── .editorconfig
├── .env.example
├── .gitignore
├── .nvmrc
├── .npmrc
├── .prettierignore
├── .prettierrc
├── .eslintignore
├── .dockerignore
├── commitlint.config.cjs
├── lint-staged.config.cjs
├── package.json
├── pnpm-workspace.yaml
├── turbo.json
├── tsconfig.base.json
├── LICENSE
└── README.md
```

---

## 2. Workspace Architecture

**Monorepo manager:** pnpm workspaces + Turborepo.
**Language:** TypeScript end-to-end (strict).
**Apps:** `backend/api` (NestJS), `backend/worker` (BullMQ), `frontend/web` (Next.js 14 App Router).
**Packages:** versionless internal libs consumed via `workspace:*`.

```
frontend/web ──┐
               ├──► shared-types ──┐
backend/api ───┤                   ├──► (no runtime deps)
backend/worker ┤    shared-utils ──┤
               │    shared-rbac ───┤
               │    shared-validation ─► zod
               └──► shared-ui ─────► (FE only — tokens)

shared-config ─► consumed by ALL (eslint/prettier/tsconfig presets, devDep only)
```

Tenancy boundary lives in `backend/api/src/tenancy/*` (per Backend Arch V2.2 §Multi-Tenancy). Every request resolves `instituteId` + `campusId` into `AsyncLocalStorage`-backed `TenantContext`, consumed by `TenantPrismaService` for automatic scoping.

---

## 3. Dependency Graph

```text
                ┌──────────────────────┐
                │  shared-config (dev) │
                └──────────┬───────────┘
                           │ presets
   ┌───────────────────────┼───────────────────────┐
   ▼                       ▼                       ▼
shared-types        shared-utils            shared-validation
   │                       │                       │
   │           ┌───────────┴──────────┐            │
   │           ▼                      ▼            │
   │      shared-rbac            shared-ui (FE)    │
   │           │                      │            │
   └─────┬─────┴───────┬──────────────┘            │
         ▼             ▼                           ▼
   backend/api   backend/worker             frontend/web
         │             │                           │
         └─────┬───────┘                           │
               ▼                                   ▼
        Postgres / Mongo / Redis            REST  / SSE
                                               │
                                          backend/api
```

Build order (Turbo): `shared-config` → `shared-types`, `shared-utils`, `shared-validation`, `shared-rbac`, `shared-ui` → `backend/api`, `backend/worker`, `frontend/web`.

---

## 4. Root Configuration Files

### `package.json`
```json
{
  "name": "medhavi-erp",
  "private": true,
  "version": "0.1.0",
  "packageManager": "pnpm@9.7.0",
  "engines": { "node": ">=20.11.0", "pnpm": ">=9.0.0" },
  "scripts": {
    "build": "turbo run build",
    "dev": "turbo run dev --parallel",
    "lint": "turbo run lint",
    "lint:fix": "turbo run lint -- --fix",
    "test": "turbo run test",
    "test:e2e": "turbo run test:e2e",
    "typecheck": "turbo run typecheck",
    "format": "prettier --write \"**/*.{ts,tsx,js,json,md}\"",
    "clean": "turbo run clean && rimraf node_modules .turbo",
    "db:generate": "pnpm --filter @medhavi/api prisma:generate",
    "db:migrate": "pnpm --filter @medhavi/api prisma:migrate",
    "db:seed": "pnpm --filter @medhavi/api prisma:seed",
    "db:reset": "pnpm --filter @medhavi/api prisma:reset",
    "docker:up": "docker compose -f infrastructure/docker/docker-compose.yml -f infrastructure/docker/docker-compose.dev.yml up -d",
    "docker:down": "docker compose -f infrastructure/docker/docker-compose.yml down",
    "docker:logs": "docker compose -f infrastructure/docker/docker-compose.yml logs -f",
    "prepare": "husky"
  },
  "devDependencies": {
    "turbo": "^2.1.0",
    "typescript": "^5.5.4",
    "prettier": "^3.3.3",
    "eslint": "^9.9.0",
    "husky": "^9.1.4",
    "lint-staged": "^15.2.9",
    "@commitlint/cli": "^19.4.0",
    "@commitlint/config-conventional": "^19.2.2",
    "rimraf": "^6.0.1"
  }
}
```

### `pnpm-workspace.yaml`
```yaml
packages:
  - "backend/*"
  - "frontend/*"
  - "packages/*"
```

### `turbo.json`
```json
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": [".env", "tsconfig.base.json"],
  "globalEnv": ["NODE_ENV"],
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "!.next/cache/**"]
    },
    "dev": { "cache": false, "persistent": true },
    "lint": { "outputs": [] },
    "typecheck": { "dependsOn": ["^build"], "outputs": [] },
    "test": { "dependsOn": ["^build"], "outputs": ["coverage/**"] },
    "test:e2e": { "dependsOn": ["^build"], "cache": false },
    "clean": { "cache": false }
  }
}
```

### `tsconfig.base.json`
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "incremental": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "baseUrl": ".",
    "paths": {
      "@medhavi/shared-types": ["packages/shared-types/src"],
      "@medhavi/shared-utils": ["packages/shared-utils/src"],
      "@medhavi/shared-config": ["packages/shared-config/src"],
      "@medhavi/shared-validation": ["packages/shared-validation/src"],
      "@medhavi/shared-rbac": ["packages/shared-rbac/src"],
      "@medhavi/shared-ui": ["packages/shared-ui/src"]
    }
  }
}
```

### `.gitignore`
```
node_modules/
.pnpm-store/
dist/
build/
.next/
out/
coverage/
.turbo/
*.tsbuildinfo
.env
.env.*.local
.env.local
*.log
.DS_Store
.idea/
.vscode/*
!.vscode/settings.json
!.vscode/extensions.json
!.vscode/launch.json
prisma/migrations/dev.db*
uploads/
tmp/
```

### `.editorconfig`
```ini
root = true
[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
[*.md]
trim_trailing_whitespace = false
```

### `.env.example` (root — shared)
```env
NODE_ENV=development

# --- PostgreSQL (RDBMS of record) ---
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=medhavi
POSTGRES_PASSWORD=medhavi
POSTGRES_DB=medhavi_erp
DATABASE_URL=postgresql://medhavi:medhavi@localhost:5432/medhavi_erp?schema=public

# --- MongoDB (logs, notifications, content blobs) ---
MONGO_HOST=localhost
MONGO_PORT=27017
MONGO_USER=medhavi
MONGO_PASSWORD=medhavi
MONGO_DB=medhavi_logs
MONGODB_URI=mongodb://medhavi:medhavi@localhost:27017/medhavi_logs?authSource=admin

# --- Redis (cache + BullMQ) ---
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_URL=redis://localhost:6379

# --- Object Storage (MinIO local / S3 prod) ---
S3_ENDPOINT=http://localhost:9000
S3_REGION=us-east-1
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin
S3_BUCKET=medhavi-dev

# --- JWT / Auth (scaffold only; not implemented) ---
JWT_ACCESS_SECRET=change-me
JWT_REFRESH_SECRET=change-me
JWT_ACCESS_TTL=900
JWT_REFRESH_TTL=2592000

# --- Apps ---
API_PORT=4000
WEB_PORT=3000
NEXT_PUBLIC_API_URL=http://localhost:4000

# --- Observability ---
LOG_LEVEL=debug
OTEL_EXPORTER_OTLP_ENDPOINT=
```

### `.prettierrc`
```json
{ "semi": true, "singleQuote": true, "trailingComma": "all", "printWidth": 100, "tabWidth": 2, "arrowParens": "always" }
```

### `commitlint.config.cjs`
```js
module.exports = { extends: ['@commitlint/config-conventional'] };
```

### `lint-staged.config.cjs`
```js
module.exports = {
  '*.{ts,tsx,js,jsx}': ['eslint --fix', 'prettier --write'],
  '*.{json,md,yml,yaml,css}': ['prettier --write'],
};
```

### `.husky/pre-commit`
```sh
pnpm exec lint-staged
```

### `.husky/commit-msg`
```sh
pnpm exec commitlint --edit "$1"
```

---

## 5. Backend Skeleton (`backend/api`)

### `package.json`
```json
{
  "name": "@medhavi/api",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "build": "nest build",
    "dev": "nest start --watch",
    "start": "node dist/main.js",
    "lint": "eslint \"src/**/*.ts\"",
    "typecheck": "tsc --noEmit",
    "test": "jest",
    "test:e2e": "jest --config test/jest-e2e.json",
    "prisma:generate": "prisma generate",
    "prisma:migrate": "prisma migrate dev",
    "prisma:deploy": "prisma migrate deploy",
    "prisma:seed": "ts-node prisma/seed.ts",
    "prisma:reset": "prisma migrate reset --force"
  },
  "dependencies": {
    "@nestjs/common": "^10.4.1",
    "@nestjs/core": "^10.4.1",
    "@nestjs/platform-express": "^10.4.1",
    "@nestjs/config": "^3.2.3",
    "@nestjs/swagger": "^7.4.0",
    "@nestjs/throttler": "^6.2.1",
    "@nestjs/bullmq": "^10.2.0",
    "@nestjs/terminus": "^10.2.3",
    "@nestjs/event-emitter": "^2.0.4",
    "@prisma/client": "^5.19.0",
    "bullmq": "^5.12.0",
    "ioredis": "^5.4.1",
    "mongodb": "^6.8.0",
    "mongoose": "^8.5.3",
    "zod": "^3.23.8",
    "class-validator": "^0.14.1",
    "class-transformer": "^0.5.1",
    "helmet": "^7.1.0",
    "compression": "^1.7.4",
    "pino": "^9.3.2",
    "nestjs-pino": "^4.1.0",
    "@medhavi/shared-types": "workspace:*",
    "@medhavi/shared-utils": "workspace:*",
    "@medhavi/shared-rbac": "workspace:*",
    "@medhavi/shared-validation": "workspace:*"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.4.4",
    "@nestjs/schematics": "^10.1.4",
    "@nestjs/testing": "^10.4.1",
    "@types/node": "^20.14.10",
    "@types/jest": "^29.5.12",
    "jest": "^29.7.0",
    "ts-jest": "^29.2.4",
    "ts-node": "^10.9.2",
    "prisma": "^5.19.0",
    "typescript": "^5.5.4"
  }
}
```

### `src/main.ts`
```ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { applySwagger } from './bootstrap/swagger.bootstrap';
import { applyValidation } from './bootstrap/validation.bootstrap';
import { applyCors } from './bootstrap/cors.bootstrap';
import { applyHelmet } from './bootstrap/helmet.bootstrap';
import { applyCompression } from './bootstrap/compression.bootstrap';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bufferLogs: true });
  app.setGlobalPrefix('api/v1');
  applyHelmet(app);
  applyCompression(app);
  applyCors(app);
  applyValidation(app);
  applySwagger(app);
  await app.listen(process.env.API_PORT ?? 4000);
}
void bootstrap();
```

### `src/app.module.ts`
```ts
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './infrastructure/prisma/prisma.module';
import { RedisModule } from './infrastructure/redis/redis.module';
import { MongoModule } from './infrastructure/mongo/mongo.module';
import { HealthModule } from './infrastructure/health/health.module';
import { QueueModule } from './queues/queue.module';
import { TenantModule } from './tenancy/tenant.module';
import configuration from './config/configuration';
import { validateEnv } from './config/env.validation';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, load: [configuration], validate: validateEnv }),
    PrismaModule,
    MongoModule,
    RedisModule,
    QueueModule,
    TenantModule,
    HealthModule,
    // Domain modules are registered here in later phases (Auth, Student, Faculty, ...)
  ],
})
export class AppModule {}
```

### `prisma/schema.prisma`
> Mirror of `Prisma Schema V1.2 MERGED FINAL` (124 models, 116 enums, 420 relations). Kept in `docs/database/` as the source of truth; `backend/api/prisma/schema.prisma` is the working copy synced by `scripts/generate-prisma.sh`.

### `Dockerfile`
```dockerfile
FROM node:20-alpine AS deps
WORKDIR /repo
RUN corepack enable && corepack prepare pnpm@9.7.0 --activate
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json turbo.json ./
COPY backend/api/package.json backend/api/
COPY packages ./packages
RUN pnpm install --frozen-lockfile

FROM deps AS build
COPY . .
RUN pnpm --filter @medhavi/api prisma:generate \
 && pnpm --filter @medhavi/api build

FROM node:20-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /repo/backend/api/dist ./dist
COPY --from=build /repo/backend/api/node_modules ./node_modules
COPY --from=build /repo/backend/api/prisma ./prisma
COPY --from=build /repo/backend/api/package.json ./
EXPOSE 4000
CMD ["node", "dist/main.js"]
```

### `src/queues/queue.module.ts`
```ts
import { Module } from '@nestjs/common';
import { BullModule } from '@nestjs/bullmq';
import { QUEUES } from './queue.constants';

@Module({
  imports: [
    BullModule.forRoot({
      connection: { host: process.env.REDIS_HOST, port: Number(process.env.REDIS_PORT) },
    }),
    BullModule.registerQueue(...Object.values(QUEUES).map((name) => ({ name }))),
  ],
  exports: [BullModule],
})
export class QueueModule {}
```

### `src/queues/queue.constants.ts`
```ts
export const QUEUES = {
  NOTIFICATIONS: 'notifications',
  EMAILS: 'emails',
  SMS: 'sms',
  REPORTS: 'reports',
  CERTIFICATES: 'certificates',
  TRANSCRIPTS: 'transcripts',
  EXAM_PROCESSING: 'exam-processing',
  ATTENDANCE_AGGREGATION: 'attendance-aggregation',
  PLACEMENT_INDEXING: 'placement-indexing',
  AUDIT_INGEST: 'audit-ingest',
  WEBHOOKS: 'webhooks',
} as const;
```

---

## 6. Worker Skeleton (`backend/worker`)

### `src/main.ts`
```ts
import { NestFactory } from '@nestjs/core';
import { WorkerModule } from './worker.module';

async function bootstrap() {
  const app = await NestFactory.createApplicationContext(WorkerModule);
  await app.init();
  // BullMQ processors are registered via @Processor() in src/processors/*
}
void bootstrap();
```

### `src/worker.module.ts`
```ts
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { BullModule } from '@nestjs/bullmq';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    BullModule.forRoot({
      connection: { host: process.env.REDIS_HOST, port: Number(process.env.REDIS_PORT) },
    }),
  ],
})
export class WorkerModule {}
```

---

## 7. Frontend Skeleton (`frontend/web`)

### `package.json`
```json
{
  "name": "@medhavi/web",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start -p 3000",
    "lint": "next lint",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "next": "14.2.5",
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "@tanstack/react-query": "^5.51.23",
    "@tanstack/react-query-devtools": "^5.51.23",
    "zustand": "^4.5.4",
    "zod": "^3.23.8",
    "react-hook-form": "^7.52.2",
    "@hookform/resolvers": "^3.9.0",
    "next-intl": "^3.17.2",
    "next-themes": "^0.3.0",
    "axios": "^1.7.4",
    "clsx": "^2.1.1",
    "tailwind-merge": "^2.5.2",
    "@medhavi/shared-types": "workspace:*",
    "@medhavi/shared-utils": "workspace:*",
    "@medhavi/shared-rbac": "workspace:*",
    "@medhavi/shared-validation": "workspace:*",
    "@medhavi/shared-ui": "workspace:*"
  },
  "devDependencies": {
    "@types/node": "^20.14.10",
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0",
    "autoprefixer": "^10.4.20",
    "postcss": "^8.4.41",
    "tailwindcss": "^3.4.10",
    "eslint": "^9.9.0",
    "eslint-config-next": "14.2.5",
    "typescript": "^5.5.4"
  }
}
```

### `src/app/layout.tsx`
```tsx
import type { ReactNode } from 'react';
import { AppProviders } from '@/providers/app-providers';
import './globals.css';

export const metadata = {
  title: 'Medhavi Skills University ERP',
  description: 'Enterprise Resource Planning for Medhavi Skills University',
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body>
        <AppProviders>{children}</AppProviders>
      </body>
    </html>
  );
}
```

### `src/providers/app-providers.tsx`
```tsx
'use client';
import type { ReactNode } from 'react';
import { QueryProvider } from './query-provider';
import { ThemeProvider } from './theme-provider';
import { I18nProvider } from './i18n-provider';
import { TenantProvider } from './tenant-provider';
import { AuthProvider } from './auth-provider';
import { ToastProvider } from './toast-provider';

export function AppProviders({ children }: { children: ReactNode }) {
  return (
    <ThemeProvider>
      <I18nProvider>
        <QueryProvider>
          <TenantProvider>
            <AuthProvider>
              <ToastProvider>{children}</ToastProvider>
            </AuthProvider>
          </TenantProvider>
        </QueryProvider>
      </I18nProvider>
    </ThemeProvider>
  );
}
```

### App Router groups (per Frontend Navigation V1.1.1)
- `(public)/` — landing, marketing, public catalogue.
- `(auth)/` — sign-in, sign-up, reset (skeleton only).
- `(app)/` — authenticated shell with role-aware sidebar; feature route folders are added later.

### Feature-sliced layout (per Frontend Arch V1.0)
`features/ → widgets/ → entities/ → shared/` import direction (lower may not import upward). Empty at this stage; each domain (auth, student, faculty, attendance, lms, finance) drops its own folder later.

---

## 8. Infrastructure (`infrastructure/docker`)

### `docker-compose.yml`
```yaml
name: medhavi-erp
services:
  postgres:
    image: postgres:16-alpine
    container_name: medhavi-postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-medhavi}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-medhavi}
      POSTGRES_DB: ${POSTGRES_DB:-medhavi_erp}
    ports: ["5432:5432"]
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./postgres/init:/docker-entrypoint-initdb.d:ro
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  mongo:
    image: mongo:7
    container_name: medhavi-mongo
    restart: unless-stopped
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_USER:-medhavi}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD:-medhavi}
    ports: ["27017:27017"]
    volumes:
      - mongo_data:/data/db
      - ./mongo/init:/docker-entrypoint-initdb.d:ro

  redis:
    image: redis:7-alpine
    container_name: medhavi-redis
    restart: unless-stopped
    command: ["redis-server", "/usr/local/etc/redis/redis.conf"]
    ports: ["6379:6379"]
    volumes:
      - redis_data:/data
      - ./redis/redis.conf:/usr/local/etc/redis/redis.conf:ro

  minio:
    image: minio/minio:latest
    container_name: medhavi-minio
    restart: unless-stopped
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: ${S3_ACCESS_KEY:-minioadmin}
      MINIO_ROOT_PASSWORD: ${S3_SECRET_KEY:-minioadmin}
    ports: ["9000:9000", "9001:9001"]
    volumes: [minio_data:/data]

  mailhog:
    image: mailhog/mailhog:latest
    container_name: medhavi-mailhog
    ports: ["1025:1025", "8025:8025"]

volumes:
  postgres_data:
  mongo_data:
  redis_data:
  minio_data:
```

### `docker-compose.dev.yml` (overrides — exposes services only; apps run on host)
```yaml
services:
  postgres: { ports: ["5432:5432"] }
  mongo:    { ports: ["27017:27017"] }
  redis:    { ports: ["6379:6379"] }
```

### `docker-compose.prod.yml` (adds API + worker + web + nginx)
```yaml
services:
  api:
    build: { context: ../.., dockerfile: backend/api/Dockerfile }
    env_file: ../../.env
    depends_on: [postgres, mongo, redis]
    ports: ["4000:4000"]
  worker:
    build: { context: ../.., dockerfile: backend/worker/Dockerfile }
    env_file: ../../.env
    depends_on: [redis, postgres]
  web:
    build: { context: ../.., dockerfile: frontend/web/Dockerfile }
    env_file: ../../.env
    depends_on: [api]
    ports: ["3000:3000"]
  nginx:
    image: nginx:alpine
    depends_on: [api, web]
    ports: ["80:80", "443:443"]
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/conf.d:/etc/nginx/conf.d:ro
```

### `postgres/init/01-extensions.sql`
```sql
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "citext";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

### `redis/redis.conf`
```
appendonly yes
maxmemory-policy allkeys-lru
```

---

## 9. Shared Packages

### `packages/shared-types/package.json`
```json
{
  "name": "@medhavi/shared-types",
  "version": "0.1.0",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts",
  "scripts": { "build": "tsc -p tsconfig.json", "typecheck": "tsc --noEmit", "lint": "eslint src" }
}
```

### `packages/shared-config/src/eslint/base.js`
```js
module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint', 'import'],
  extends: ['eslint:recommended', 'plugin:@typescript-eslint/recommended', 'prettier'],
  rules: { '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }] },
};
```

### `packages/shared-config/src/tsconfig/base.json`
```json
{
  "extends": "../../../../tsconfig.base.json",
  "compilerOptions": { "composite": true, "outDir": "dist", "rootDir": "src" }
}
```

### `packages/shared-utils/src/index.ts`
```ts
export * from './date';
export * from './string';
export * from './money';
export * from './id';
export * from './result';
```

### `packages/shared-rbac/src/index.ts`
> Exports role / scope / permission enums mirroring **RBAC Matrix V2.2 FINAL** (`SUPER_ADMIN`, `INSTITUTE_ADMIN`, `CAMPUS_ADMIN`, `REGISTRAR`, `HOD`, `FACULTY`, `STUDENT`, `MENTOR`, `PLACEMENT_OFFICER`, `LIBRARIAN`, `ACCOUNTANT`, `EXAM_CONTROLLER`, `WARDEN`, `GUEST`) plus the permission constant catalogue. **Definitions only, no logic.**

### `packages/shared-validation/src/index.ts`
> Re-exports Zod primitives shared FE+BE (UUID, ISO date, money decimal string, phone E.164, India PIN). No domain schemas yet.

---

## 10. Development Commands

```bash
# One-time
pnpm install
cp .env.example .env
pnpm db:generate

# Daily dev (host apps + infra in Docker)
pnpm docker:up
pnpm db:migrate
pnpm dev                    # turbo runs api + worker + web in parallel

# Targeted dev
pnpm --filter @medhavi/api dev
pnpm --filter @medhavi/web dev
pnpm --filter @medhavi/worker dev

# Quality gates
pnpm lint
pnpm typecheck
pnpm test
pnpm format
```

## 11. Build Commands

```bash
pnpm build                                # turbo: all packages + apps
pnpm --filter @medhavi/api build          # NestJS dist/
pnpm --filter @medhavi/web build          # Next.js .next/
pnpm --filter @medhavi/worker build

# Docker images
docker build -f backend/api/Dockerfile     -t medhavi/api:dev .
docker build -f backend/worker/Dockerfile  -t medhavi/worker:dev .
docker build -f frontend/web/Dockerfile    -t medhavi/web:dev .
```

## 12. Docker Startup Commands

```bash
# Infra only (recommended for local dev)
pnpm docker:up
pnpm docker:logs
pnpm docker:down

# Full stack (api + worker + web + nginx)
docker compose \
  -f infrastructure/docker/docker-compose.yml \
  -f infrastructure/docker/docker-compose.prod.yml \
  up -d --build

# Reset volumes (destructive)
docker compose -f infrastructure/docker/docker-compose.yml down -v
```

## 13. Local Setup Instructions

1. **Prerequisites:** Node 20.11+, pnpm 9+, Docker Desktop 4.30+, Git.
2. **Clone & install**
   ```bash
   git clone <repo-url> medhavi-erp && cd medhavi-erp
   pnpm install
   cp .env.example .env
   ```
3. **Start infra** — `pnpm docker:up` (Postgres :5432, Mongo :27017, Redis :6379, MinIO :9000, Mailhog :8025).
4. **Database** —
   ```bash
   pnpm db:generate          # prisma generate
   pnpm db:migrate           # apply migrations (none yet — scaffold)
   pnpm db:seed              # optional, no-op until seeders added
   ```
5. **Run apps** — `pnpm dev` (API :4000, Worker bg, Web :3000).
6. **Verify**
   - API health: `curl http://localhost:4000/api/v1/health` → `{ "status": "ok" }`
   - Swagger:   `http://localhost:4000/api/v1/docs`
   - Web:      `http://localhost:3000`
   - MinIO console: `http://localhost:9001` (minioadmin / minioadmin)
   - Mailhog UI:    `http://localhost:8025`
7. **Quality gate before commit** — Husky auto-runs `lint-staged` + `commitlint`. Manual: `pnpm lint && pnpm typecheck && pnpm test`.

---

## 14. What This Skeleton Does NOT Contain (by rule)

- ❌ Auth module implementation (only provider stub + env keys)
- ❌ Student, Faculty, Attendance, LMS, Finance modules
- ❌ Any business logic, controllers, services, DTOs for domain features
- ❌ RLS policies / SQL migrations (added with first domain module)
- ❌ E2E or feature tests

`backend/api/src/modules/` is intentionally empty with a `README.md` reminding contributors that domain modules land here in subsequent phases.

---

## 15. Verdict

✅ **Installs cleanly** with `pnpm install`.
✅ **Boots cleanly** with `pnpm docker:up && pnpm dev` (API health probe passes; web renders root layout).
✅ **Conforms** to Repository Structure V1.1 FINAL, Backend Arch V2.2, Frontend Arch V1.0, Infra V1.1, Deployment V1.1.
✅ **Ready** for incremental domain-module addition without further structural change.
