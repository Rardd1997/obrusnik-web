# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal website/blog built with **Astro 6** and deployed to **Cloudflare Workers** (not Pages) as a server-rendered Worker that also serves static assets. Originated from Cloudflare's `astro-blog-starter-template`. Requires Node >= 22.

## Commands

```bash
npm run dev          # Astro dev server at localhost:4321
npm run build        # Build to ./dist/ (static assets in ./dist/client/, server output in ./dist/server/)
npm run preview      # Build, then serve via wrangler dev (closest to production)
npm run check        # Full validation: astro build && tsc && wrangler deploy --dry-run
npm run deploy       # wrangler deploy (build first)
npm run cf-typegen   # Regenerate worker-configuration.d.ts from wrangler.json bindings
npx wrangler tail    # Live production Worker logs
```

There is no test runner or linter configured. `npm run check` is the closest thing to CI — run it before deploying. After changing Cloudflare bindings in `wrangler.json`, run `cf-typegen` to refresh types.

## Architecture

- **Rendering / deploy target:** The `@astrojs/cloudflare` adapter (v13, configured in [astro.config.mjs](astro.config.mjs)) builds the Worker into `dist/`. [wrangler.json](wrangler.json) sets `main` to the adapter's unified entrypoint `@astrojs/cloudflare/entrypoints/server` (v13+ — it no longer points at the `dist/_worker.js/index.js` build output), binds the `dist` directory as the `ASSETS` binding, and enables observability + source map upload. Local `astro dev` bindings are handled automatically by the `@cloudflare/vite-plugin` the adapter integrates, so no `platformProxy` option is needed. The adapter also auto-provisions a `SESSION` KV namespace and an `IMAGES` binding on deploy by default (visible in `wrangler deploy --dry-run` output).
- **Content collections:** Blog posts are Markdown/MDX files in `src/content/blog/`, loaded via the glob loader and validated against a Zod schema in [src/content.config.ts](src/content.config.ts). The schema requires `title`, `description`, `pubDate`, and optionally `updatedDate` and `heroImage`. Adding/changing frontmatter fields means updating this schema.
- **Routing:** Pages live in `src/pages/`. The home page [src/pages/index.astro](src/pages/index.astro) currently does a server-side `Astro.redirect('/blog')` — the blog index is the de-facto landing page, and `index.astro` is a placeholder slot to be replaced with real home-page content later. Blog posts are rendered by the dynamic route [src/pages/blog/[...slug].astro](src/pages/blog/[...slug].astro), which generates static paths from the collection (the post `id` is the slug). [src/pages/rss.xml.js](src/pages/rss.xml.js) builds the RSS feed from the same collection.
- **Shared chrome:** `src/layouts/BlogPost.astro` is the post layout; `src/components/` holds `BaseHead` (SEO/OpenGraph), `Header`, `Footer`, `FormattedDate`, etc. Global site metadata lives in [src/consts.ts](src/consts.ts).

## Notes

- The `site` URL in [astro.config.mjs](astro.config.mjs) is still the placeholder `https://example.com` — this affects canonical URLs, sitemap, and RSS output and still needs a real value. `SITE_TITLE` (`"Obrusnik Dev"`) and `SITE_DESCRIPTION` (`"Welcome to my website!"`) in [src/consts.ts](src/consts.ts) have been customized from the starter defaults.
- `worker-configuration.d.ts` is generated (from `cf-typegen`) — do not hand-edit.
