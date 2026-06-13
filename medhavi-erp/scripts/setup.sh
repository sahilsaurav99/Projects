#!/bin/bash
set -e

echo "🚀 Setting up Medhavi ERP..."

# Check for prerequisites
if ! command -v pnpm &> /dev/null; then
  echo "❌ pnpm not found. Please install pnpm."
  exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
pnpm install

# Copy env file if not exists
if [ ! -f .env ]; then
  echo "📋 Creating .env from .env.example"
  cp .env.example .env
fi

# Start docker services
echo "🐳 Starting Docker services..."
pnpm docker:up

# Generate prisma client
echo "🔧 Generating Prisma client..."
pnpm db:generate

# Run migrations
echo "🗄️  Running database migrations..."
pnpm db:migrate

echo "✅ Setup complete! Run 'pnpm dev' to start development."
