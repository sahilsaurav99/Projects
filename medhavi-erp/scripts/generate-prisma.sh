#!/bin/bash
set -e

echo "🔧 Generating Prisma client..."
pnpm db:generate
