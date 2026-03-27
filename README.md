# AppWink Hosting

Shared hosting contract for the AppWink web properties.

This repository is the single source of truth for:

- shared deploy facts such as host, user, and mount paths
- the current shared `awink.art` main nginx server block

The application website and blog should consume this repository as a git
submodule instead of copying these files into each repo.

## Scripts

```bash
./verify-live-nginx.sh
./deploy-awink-server.sh
./bump-consumers.sh
```

- `verify-live-nginx.sh`: compare the versioned `awink.server.conf` with the live host config
- `deploy-awink-server.sh`: back up the live config, install the shared server block, run `nginx -t`, reload, and validate `/app/` plus `/blog/`
- `bump-consumers.sh`: update the `shared/appwink-hosting` submodule in local sibling repos (`appwink-blog`, `appwink-website`) to the latest shared commit

## Recommended Flow

```bash
./verify-live-nginx.sh
./deploy-awink-server.sh
./bump-consumers.sh
```

Then commit and push the resulting submodule pointer updates in each consumer repository.
