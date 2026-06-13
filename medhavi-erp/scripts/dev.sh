#!/bin/bash
set -e

echo "🚀 Starting development environment..."
pnpm docker:up
pnpm dev
