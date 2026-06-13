#!/bin/bash
set -e

echo "🐳 Starting Docker services..."
pnpm docker:up
