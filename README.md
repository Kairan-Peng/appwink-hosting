# AppWink Hosting

Shared hosting contract for the AppWink web properties.

This repository is the single source of truth for:

- shared deploy facts such as host, user, and mount paths
- the current shared `awink.art` main nginx server block

The application website and blog should consume this repository as a git
submodule instead of copying these files into each repo.

GitHub Actions runs `make check` on pushes to `main`, pull requests, daily at `03:17 UTC`, and manual dispatch.
On failure, the workflow opens or updates a GitHub issue and mentions `vars.ALERT_GITHUB_LOGIN`, which GitHub can deliver to that account's email inbox via notification email.

## Scripts

```bash
make check
make release
./release.sh
./verify-live-nginx.sh
./deploy-awink-server.sh
./bump-consumers.sh
```

- `make release`: preferred local command for verify -> deploy -> bump
- `make check`: preferred local validation command and CI entrypoint
- `release.sh`: run verify -> deploy -> bump in one command
- `verify-live-nginx.sh`: compare the versioned `awink.server.conf` with the live host config
- `deploy-awink-server.sh`: back up the live config, install the shared server block, run `nginx -t`, reload, and validate `/app/` plus `/blog/`
- `bump-consumers.sh`: update the `shared/appwink-hosting` submodule in local sibling repos (`appwink-blog`, `appwink-website`) to the latest shared commit

## Recommended Flow

```bash
make release
```

For validation only:

```bash
make check
```

Useful overrides:

```bash
SKIP_VERIFY=1 ./release.sh
SKIP_DEPLOY=1 ./release.sh
SKIP_BUMP=1 ./release.sh
```

Or with `make`:

```bash
SKIP_VERIFY=1 make release
```

After the release flow finishes, commit and push the resulting submodule pointer updates in each consumer repository if they changed.
