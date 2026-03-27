# AppWink Hosting

Shared hosting contract for the AppWink web properties.

This repository is the single source of truth for:

- shared deploy facts such as host, user, and mount paths
- the current shared `awink.art` main nginx server block

The application website and blog should consume this repository as a git
submodule instead of copying these files into each repo.

## Scripts

```bash
./release.sh
./verify-live-nginx.sh
./deploy-awink-server.sh
./bump-consumers.sh
```

- `release.sh`: run verify -> deploy -> bump in one command
- `verify-live-nginx.sh`: compare the versioned `awink.server.conf` with the live host config
- `deploy-awink-server.sh`: back up the live config, install the shared server block, run `nginx -t`, reload, and validate `/app/` plus `/blog/`
- `bump-consumers.sh`: update the `shared/appwink-hosting` submodule in local sibling repos (`appwink-blog`, `appwink-website`) to the latest shared commit

## Recommended Flow

```bash
./release.sh
```

Useful overrides:

```bash
SKIP_VERIFY=1 ./release.sh
SKIP_DEPLOY=1 ./release.sh
SKIP_BUMP=1 ./release.sh
```

After the release flow finishes, commit and push the resulting submodule pointer updates in each consumer repository if they changed.
