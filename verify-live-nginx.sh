#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTING_ENV="$ROOT_DIR/hosting.env"

set -a
# shellcheck disable=SC1090
source "$HOSTING_ENV"
set +a

SERVER_IP="${SERVER_IP:-$APPWINK_SERVER_IP}"
DEPLOY_USER="${DEPLOY_USER:-$APPWINK_DEPLOY_USER}"
REMOTE_CONFIG_PATH="${REMOTE_CONFIG_PATH:-/etc/nginx/sites-available/project1.conf}"
LOCAL_CONFIG_PATH="${LOCAL_CONFIG_PATH:-$ROOT_DIR/nginx/awink.server.conf}"

diff -uw "$LOCAL_CONFIG_PATH" <(
  # shellcheck disable=SC2029
  ssh "${DEPLOY_USER}@${SERVER_IP}" "sed -n '1,220p' '${REMOTE_CONFIG_PATH}'"
)
