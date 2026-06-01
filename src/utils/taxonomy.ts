import { getCollection, type CollectionEntry } from 'astro:content';

type BlogPost = CollectionEntry<'blog'>;

/** Turn a display label like "Data Management" or "X++" into a URL-safe slug. */
export function slugify(value: string): string {
	return value
		.toLowerCase()
		.trim()
		// Preserve "++" languages: x++ -> xpp, c++ -> cpp
		.replace(/\+/g, 'p')
		.replace(/[^a-z0-9]+/g, '-')
		.replace(/^-+|-+$/g, '');
}

/** Fetch published posts, newest first. */
export async function getSortedPosts(): Promise<BlogPost[]> {
	const posts = await getCollection('blog');
	return posts.sort((a, b) => b.data.pubDate.valueOf() - a.data.pubDate.valueOf());
}

/** Unique categories with their slug and post count, sorted by name. */
export async function getCategories() {
	const posts = await getCollection('blog');
	const counts = new Map<string, number>();
	for (const post of posts) {
		counts.set(post.data.category, (counts.get(post.data.category) ?? 0) + 1);
	}
	return [...counts.entries()]
		.map(([name, count]) => ({ name, slug: slugify(name), count }))
		.sort((a, b) => a.name.localeCompare(b.name));
}

/** Unique tags with their slug and post count, sorted by name. */
export async function getTags() {
	const posts = await getCollection('blog');
	const counts = new Map<string, number>();
	for (const post of posts) {
		for (const tag of post.data.tags) {
			counts.set(tag, (counts.get(tag) ?? 0) + 1);
		}
	}
	return [...counts.entries()]
		.map(([name, count]) => ({ name, slug: slugify(name), count }))
		.sort((a, b) => a.name.localeCompare(b.name));
}
