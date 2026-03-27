# AppWink Hosting

Shared hosting contract for the AppWink web properties.

This repository is the single source of truth for:

- shared deploy facts such as host, user, and mount paths
- the current shared `awink.art` main nginx server block

The application website and blog should consume this repository as a git
submodule instead of copying these files into each repo.
