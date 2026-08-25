# Best OutDoor Wears

An Astro 5 static site for **bestoutdoorwears.com** — an outdoor clothing layering guide, 20 SEO articles, and the **TrailReady** digital product (layering guide, 5 trip-type checklists, and a working spreadsheet).

Everything here is free to run: GitHub Pages hosting, GitHub Actions builds, self-hosted fonts, no database, no server.

## Local development

```bash
npm install
npm run dev       # http://localhost:4321
npm run build     # outputs to dist/
npm run preview   # preview the production build
```

## Deploying (free, GitHub Pages)

1. In the repo's **Settings → Pages**, set **Source** to **GitHub Actions**. That's the only manual click required — the workflow at `.github/workflows/deploy.yml` handles the rest on every push to `main`.
2. This branch is `claude/digital-product-complete-qrnw9f`. Merge it into `main` (or change the workflow's trigger branch) to actually deploy.
3. **Custom domain:** `public/CNAME` is intentionally absent right now, so the site is reachable at `https://mmohamad517.github.io/dashboard-landing-page/`. When you're ready to use `bestoutdoorwears.com`, create `public/CNAME` containing just `bestoutdoorwears.com` and push — but set the DNS records first, otherwise the site becomes unreachable until DNS resolves. Point your domain's DNS at GitHub Pages (an `A` record to GitHub's Pages IPs, or a `CNAME` record to `<your-github-username>.github.io`, per [GitHub's custom domain docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site)) and GitHub will issue a free HTTPS certificate automatically once DNS is verified.
4. Alternative free host: Cloudflare Pages works too (connect the repo, build command `npm run build`, output directory `dist`) if you'd rather not use GitHub Pages.

## Selling TrailReady (the product)

The product is **one download with two parts**, delivered as `TrailReady-Complete-Kit.zip`:

```
READ-ME-FIRST.txt
Part 1 - Before You Go/
  TrailReady-Layering-and-Packing-Guide.pdf
  TrailReady-Conditions-Helper.xlsx
Part 2 - When It Goes Wrong/
  SurvivalCards-Deck-89-cards.pdf
  SurvivalCards-Guide.pdf
```

The finished files were **not committed to this repo on purpose** — this is a public repo, and anything in it is downloadable by anyone for free, which would defeat the point of selling it. The zip was sent to you directly in chat.

To go live:
1. Create a free seller account on **[Payhip](https://payhip.com)** (~5% fee on the free plan) or **[Gumroad](https://gumroad.com)** (~10% + $0.50/sale, also free to list).
2. Upload `TrailReady-Complete-Kit.zip` as a single digital product, priced at $19 (or whatever you decide).
3. Copy the product's checkout URL and replace the placeholder in `src/pages/product.astro` — search for the `affiliate-note` block with the `#buy` anchor and swap in the real link as the `href` on the "Get the kit" button.

## Free lead magnet

`public/downloads/trailready-free-sample.pdf` is already live and linked from the homepage and the product page — no setup needed. It's 5 pages: the illustrated layering cheat sheet, then 8 of the 89 cards, both funnelling to the product page.

## Affiliate links (optional, adds passive income)

The site references REI, Columbia, YETI, and GSI Outdoors as commonly recommended outdoor brands. To turn these into affiliate links:
1. Join their affiliate/partner programs (all free to join).
2. Replace any `{{AFFILIATE_ID}}`-style placeholder you add to outbound links in the article/product content with your real affiliate tags.
3. Keep the `/affiliate-disclosure/` page accurate — it's already linked from the footer.

## Contact email

`src/pages/contact.astro` has a `{{CONTACT_EMAIL}}` placeholder — replace it with a real inbox (or a Formspree free-tier form endpoint) before going live.

## Content

- **Primary keyword:** `outdoor clothing layering guide`
- **20 supporting articles** in `src/content/articles/`, one per secondary keyword, all cross-linked to each other and to the pillar homepage and product page.
- **Legal pages:** About, Privacy Policy, Terms & Conditions, Contact, FAQ (with FAQPage schema), Affiliate Disclosure.

See `docs/PRODUCT-STRATEGY.md` for the full product/business strategy behind this build.
