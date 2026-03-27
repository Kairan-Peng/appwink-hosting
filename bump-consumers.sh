#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSUMERS=(
  "${ROOT_DIR}/../appwink-blog"
  "${ROOT_DIR}/../appwink-website"
)
SUBMODULE_PATH="shared/appwink-hosting"

for repo in "${CONSUMERS[@]}"; do
  if [[ ! -d "$repo/.git" ]]; then
    echo "Skip missing consumer repo: $repo"
    continue
  fi

  echo "Updating consumer submodule in: $repo"
  git -C "$repo" submodule update --init --remote "$SUBMODULE_PATH"
  git -C "$repo" submodule status "$SUBMODULE_PATH"
done
