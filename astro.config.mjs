import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://bestoutdoorwears.com',
  output: 'static',
  prefetch: false,
  integrations: [sitemap()],
  compressHTML: true,
});
