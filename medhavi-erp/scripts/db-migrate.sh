#!/bin/bash
set -e

echo "🗄️  Running database migrations..."
pnpm db:migrate
