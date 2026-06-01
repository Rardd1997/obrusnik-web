<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:atom="http://www.w3.org/2005/Atom">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" />
	<xsl:template match="/">
		<html lang="en">
			<head>
				<meta charset="utf-8" />
				<meta name="viewport" content="width=device-width, initial-scale=1" />
				<title><xsl:value-of select="/rss/channel/title" /> &#8226; RSS Feed</title>
				<style>
					:root { color-scheme: light dark; }
					body {
						font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
							Helvetica, Arial, sans-serif;
						max-width: 720px;
						margin: 0 auto;
						padding: 2rem 1rem 4rem;
						line-height: 1.6;
						color: #1f2328;
						background: #fff;
					}
					@media (prefers-color-scheme: dark) {
						body { color: #e6edf3; background: #0d1117; }
						a { color: #7aa2f7; }
						.meta { color: #8b949e; }
						article { border-color: #30363d; }
					}
					a { color: #2563eb; }
					.banner {
						background: #fff3e6;
						border: 1px solid #ffd9a8;
						border-radius: 8px;
						padding: 1rem 1.25rem;
						margin-bottom: 2rem;
						color: #663c00;
					}
					@media (prefers-color-scheme: dark) {
						.banner { background: #2a1d0a; border-color: #5a3d12; color: #f0c987; }
					}
					h1 { font-size: 1.8rem; margin: 0 0 0.25rem; }
					.desc { margin-top: 0; }
					.meta { color: #57606a; font-size: 0.9rem; }
					article {
						border-top: 1px solid #d0d7de;
						padding: 1.25rem 0;
					}
					article h2 { font-size: 1.2rem; margin: 0 0 0.25rem; }
					article h2 a { text-decoration: none; }
					article h2 a:hover { text-decoration: underline; }
				</style>
			</head>
			<body>
				<div class="banner">
					<strong>This is an RSS feed.</strong> Subscribe by copying the URL from
					the address bar into your feed reader. Visit
					<a href="https://aboutfeeds.com/" target="_blank">About Feeds</a> to
					learn more.
				</div>
				<h1><xsl:value-of select="/rss/channel/title" /></h1>
				<p class="desc"><xsl:value-of select="/rss/channel/description" /></p>
				<p>
					<a target="_blank">
						<xsl:attribute name="href">
							<xsl:value-of select="/rss/channel/link" />
						</xsl:attribute>
						Visit website &#8594;
					</a>
				</p>
				<h2>Recent posts</h2>
				<xsl:for-each select="/rss/channel/item">
					<article>
						<h2>
							<a target="_blank">
								<xsl:attribute name="href">
									<xsl:value-of select="link" />
								</xsl:attribute>
								<xsl:value-of select="title" />
							</a>
						</h2>
						<p class="meta">
							Published: <xsl:value-of select="pubDate" />
						</p>
						<p><xsl:value-of select="description" /></p>
					</article>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
