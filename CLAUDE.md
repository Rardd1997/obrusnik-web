# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal website/blog built with **Astro 5** and deployed to **Cloudflare Workers** (not Pages) as a server-rendered Worker that also serves static assets. Originated from Cloudflare's `astro-blog-starter-template`. Requires Node >= 22.

## Commands

```bash
npm run dev          # Astro dev server at localhost:4321
npm run build        # Build to ./dist/ (produces ./dist/_worker.js/index.js)
npm run preview      # Build, then serve via wrangler dev (closest to production)
npm run check        # Full validation: astro build && tsc && wrangler deploy --dry-run
npm run deploy       # wrangler deploy (build first)
npm run cf-typegen   # Regenerate worker-configuration.d.ts from wrangler.json bindings
npx wrangler tail    # Live production Worker logs
```

There is no test runner or linter configured. `npm run check` is the closest thing to CI — run it before deploying. After changing Cloudflare bindings in `wrangler.json`, run `cf-typegen` to refresh types.

## Architecture

- **Rendering / deploy target:** The `@astrojs/cloudflare` adapter (configured in [astro.config.mjs](astro.config.mjs)) builds a Worker entrypoint at `dist/_worker.js/index.js`. [wrangler.json](wrangler.json) wires that as `main`, binds the `dist` directory as the `ASSETS` binding, and enables observability + source map upload. `platformProxy` is enabled so Cloudflare bindings are available during local `astro dev`.
- **Content collections:** Blog posts are Markdown/MDX files in `src/content/blog/`, loaded via the glob loader and validated against a Zod schema in [src/content.config.ts](src/content.config.ts). The schema requires `title`, `description`, `pubDate`, and optionally `updatedDate` and `heroImage`. Adding/changing frontmatter fields means updating this schema.
- **Routing:** Pages live in `src/pages/`. Blog posts are rendered by the dynamic route [src/pages/blog/[...slug].astro](src/pages/blog/[...slug].astro), which generates static paths from the collection (the post `id` is the slug). [src/pages/rss.xml.js](src/pages/rss.xml.js) builds the RSS feed from the same collection.
- **Shared chrome:** `src/layouts/BlogPost.astro` is the post layout; `src/components/` holds `BaseHead` (SEO/OpenGraph), `Header`, `Footer`, `FormattedDate`, etc. Global site metadata lives in [src/consts.ts](src/consts.ts).

## Notes

- The `site` URL in [astro.config.mjs](astro.config.mjs) is still the placeholder `https://example.com`, and `SITE_TITLE`/`SITE_DESCRIPTION` in `src/consts.ts` are starter defaults — these affect canonical URLs, sitemap, and RSS output and likely need real values.
- `worker-configuration.d.ts` is generated (from `cf-typegen`) — do not hand-edit.
