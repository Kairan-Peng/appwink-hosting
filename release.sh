#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_VERIFY="${SKIP_VERIFY:-0}"
SKIP_DEPLOY="${SKIP_DEPLOY:-0}"
SKIP_BUMP="${SKIP_BUMP:-0}"

echo "=== AppWink Hosting Release ==="
echo

if [[ "$SKIP_VERIFY" != "1" ]]; then
  echo "[1/3] Verifying local config against live host..."
  "$ROOT_DIR/verify-live-nginx.sh"
else
  echo "[1/3] Verification skipped."
fi

if [[ "$SKIP_DEPLOY" != "1" ]]; then
  echo "[2/3] Deploying shared server config..."
  "$ROOT_DIR/deploy-awink-server.sh"
else
  echo "[2/3] Deploy skipped."
fi

if [[ "$SKIP_BUMP" != "1" ]]; then
  echo "[3/3] Updating consumer submodules..."
  "$ROOT_DIR/bump-consumers.sh"
else
  echo "[3/3] Consumer bump skipped."
fi

echo
echo "Release flow complete."
echo "Next: commit and push submodule pointer updates in appwink-blog and appwink-website if they changed."
