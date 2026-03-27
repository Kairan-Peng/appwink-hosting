# Nginx Notes

This repository keeps the shared `awink.art` main server block in
[`awink.server.conf`](./awink.server.conf).

Per-project snippets or fallback-only vhosts should live in their owning
repositories:

- `appwink-website` owns the `/app/` site content and any legacy fallback-only
  vhost template
- `appwink-blog` owns the `/blog/` content and any blog-specific snippet
