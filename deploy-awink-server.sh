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
REMOTE_TMP_PATH="${REMOTE_TMP_PATH:-/tmp/awink.server.conf}"
LOCAL_CONFIG_PATH="${LOCAL_CONFIG_PATH:-$ROOT_DIR/nginx/awink.server.conf}"
SKIP_VALIDATE="${SKIP_VALIDATE:-0}"

echo "=== AppWink Shared Server Config Deployment ==="
echo "Server: ${DEPLOY_USER}@${SERVER_IP}"
echo "Config: ${LOCAL_CONFIG_PATH} -> ${REMOTE_CONFIG_PATH}"
echo

scp "$LOCAL_CONFIG_PATH" "${DEPLOY_USER}@${SERVER_IP}:${REMOTE_TMP_PATH}"

ssh "${DEPLOY_USER}@${SERVER_IP}" "
BACKUP_PATH='${REMOTE_CONFIG_PATH}.backup-'$(date +%Y%m%d-%H%M%S) &&
sudo cp '${REMOTE_CONFIG_PATH}' \"\$BACKUP_PATH\" &&
sudo mv '${REMOTE_TMP_PATH}' '${REMOTE_CONFIG_PATH}' &&
sudo nginx -t &&
sudo systemctl reload nginx &&
echo \"Backup written to: \$BACKUP_PATH\"
"

if [[ "$SKIP_VALIDATE" != "1" ]]; then
  curl -fsSI "${APPWINK_APP_URL}" >/dev/null
  curl -fsSI "${APPWINK_BLOG_URL}" >/dev/null
fi

echo
echo "Deployment complete."
