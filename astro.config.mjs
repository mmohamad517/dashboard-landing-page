import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// GitHub Pages serves project sites from a subpath (/<repo>/), while the
// custom domain serves from the root. Both are driven by env vars so the same
// codebase deploys correctly to either without edits.
const base = process.env.PUBLIC_BASE_PATH || '/';
const site = process.env.PUBLIC_SITE_URL || 'https://bestoutdoorwears.com';

/** Prefixes root-absolute links written in Markdown with the configured base. */
function rehypeBaseLinks() {
  const prefix = base.replace(/\/$/, '');
  if (!prefix) return () => {};
  const walk = (node) => {
    if (node.tagName === 'a' && typeof node.properties?.href === 'string') {
      const href = node.properties.href;
      if (href.startsWith('/') && !href.startsWith('//')) {
        node.properties.href = prefix + href;
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
  integrations: [sitemap()],
  compressHTML: true,
  markdown: {
    rehypePlugins: [rehypeBaseLinks],
  },
});
