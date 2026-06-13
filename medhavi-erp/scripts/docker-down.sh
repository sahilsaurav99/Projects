#!/bin/bash
set -e

echo "🛑 Stopping Docker services..."
pnpm docker:down
