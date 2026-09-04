import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// GitHub Pages serves project sites from a subpath (/<repo>/), while the
// custom domain serves from the root. Both are driven by env vars so the same
// codebase deploys correctly to either without edits.
const base = process.env.PUBLIC_BASE_PATH || '/';
const site = process.env.PUBLIC_SITE_URL || 'https://bestoutdoorwears.com';

/** Prefixes root-absolute links and image sources written in Markdown with the configured base. */
function rehypeBaseLinks() {
  const prefix = base.replace(/\/$/, '');
  if (!prefix) return () => {};
  const attrByTag = { a: 'href', img: 'src' };
  const walk = (node) => {
    const attr = attrByTag[node.tagName];
    if (attr && typeof node.properties?.[attr] === 'string') {
      const value = node.properties[attr];
      if (value.startsWith('/') && !value.startsWith('//')) {
        node.properties[attr] = prefix + value;
      }
    }
    (node.children || []).forEach(walk);
  };
  return (tree) => walk(tree);
}

export default defineConfig({
  site,
  base,
  output: 'static',
  prefetch: false,
  integrations: [sitemap({ lastmod: new Date() })],
  compressHTML: true,
  markdown: {
    rehypePlugins: [rehypeBaseLinks],
  },
});
