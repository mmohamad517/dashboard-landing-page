/**
 * Joins a root-relative path onto the configured Astro `base`, so the same
 * links work whether the site is served from a domain root or a /<repo>/
 * subpath on GitHub Pages.
 */
const prefix = import.meta.env.BASE_URL.replace(/\/$/, '');

export function url(path: string): string {
  if (!path.startsWith('/')) return path;
  return `${prefix}${path}`;
}
