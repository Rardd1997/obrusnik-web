/**
 * Estimate reading time (in whole minutes, rounded up to at least 1) for a
 * block of Markdown/MDX text, based on an average adult reading speed.
 */
const WORDS_PER_MINUTE = 200;

export function getReadingTime(content: string): number {
	const words = content
		.replace(/<[^>]+>/g, " ") // strip HTML/JSX tags
		.split(/\s+/)
		.filter(Boolean).length;
	return Math.max(1, Math.ceil(words / WORDS_PER_MINUTE));
}
