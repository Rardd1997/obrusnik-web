// @ts-check
import { defineConfig } from "astro/config";
import mdx from "@astrojs/mdx";
import sitemap from "@astrojs/sitemap";

import cloudflare from "@astrojs/cloudflare";

// https://astro.build/config
export default defineConfig({
	site: "https://example.com",
	integrations: [mdx(), sitemap()],
	adapter: cloudflare({
		// Fully static site (output: "static", all routes prerendered). Hero
		// images are rendered as plain <img> using the imported asset's static
		// URL instead of Astro's <Image>, which always routes through the
		// runtime /_image endpoint — that endpoint 404s on a 100%-prerendered
		// site, and the adapter's "compile" build-time service is broken here
		// (reads dist/_astro but assets land in dist/client/_astro). Setting
		// passthrough so the image service is a no-op even if <Image> reappears.
		imageService: "passthrough",
	}),
});
