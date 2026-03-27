#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS=(
  "$ROOT_DIR/check.sh"
  "$ROOT_DIR/release.sh"
  "$ROOT_DIR/verify-live-nginx.sh"
  "$ROOT_DIR/deploy-awink-server.sh"
  "$ROOT_DIR/bump-consumers.sh"
)
MAKE_TARGETS=(verify deploy bump release check)
REQUIRED_PATTERNS=(
  "server_name awink.art www.awink.art;"
  "location = /blog"
  "location /blog/"
  "location /app/"
)

echo "==> Checking bash syntax"
for script in "${SCRIPTS[@]}"; do
  bash -n "$script"
done

if command -v shellcheck >/dev/null 2>&1; then
  echo "==> Running shellcheck"
  shellcheck "${SCRIPTS[@]}"
else
  echo "==> shellcheck not installed, skipping static lint"
fi

echo "==> Validating Make targets"
for target in "${MAKE_TARGETS[@]}"; do
  make -C "$ROOT_DIR" -n "$target" >/dev/null
done

echo "==> Validating versioned nginx contract"
for pattern in "${REQUIRED_PATTERNS[@]}"; do
  grep -F "$pattern" "$ROOT_DIR/nginx/awink.server.conf" >/dev/null
done

echo "All checks passed."
