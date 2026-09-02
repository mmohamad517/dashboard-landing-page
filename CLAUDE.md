# Working rules for bestoutdoorwears.com

Read this before doing anything in this repo. It exists because the owner
has one site, no budget, and no way to absorb a mistake that takes Google
weeks to forgive.

**Reply to the owner in Arabic.** They read Arabic, not English. The site,
the code and this file stay in English.

---

## 1. State the risk before you act — every time

Open every proposal with one of these three lines. Never start work without
it, and never bury it at the end of a long message.

🟢 **Green — go ahead.** Adds something without touching what exists.
Examples: a new page or article, deepening existing copy, editing the
product PDFs, any file that never reaches the built site.
*Why it's safe: no existing URL, title or indexed page changes.*

🟡 **Yellow — explain the trade-off and wait for a yes.**
Examples: changing the title of an indexed page, adding a third-party
script, editing structured data, a significant design change.
*Why: reversible, but rankings can wobble for a week or two.*

🔴 **Red — say plainly that it causes harm and propose an alternative.**
Examples: changing or removing any URL, deleting or merging pages,
mass-generated pages, any invented review, rating or statistic, any change
to site structure.
*Why: this is what actually sinks sites, and recovery is months.*

When unsure which colour applies, pick the more cautious one and say so.

---

## 2. Check before and after — mechanically, not by feel

```bash
./scripts/site-check.sh before   # before touching anything
# ...make the change...
./scripts/site-check.sh after    # diffs against "before"
```

`after` fails loudly if any URL disappeared, if an internal link or a
referenced download breaks, or if an internal file leaked into `dist/`.
**A failing check is a stop, not a warning.** Never deploy past one.

The snapshot also records titles, article word counts and the structured-data
types present, so unintended changes to any of those show up in the diff.

---

## 3. Never fabricate

The owner sells a survival product. A wrong number here is not a marketing
problem, it is a safety problem — and a fake review is a Google manual
action plus an FTC issue.

- **No invented figures.** No temperatures, distances, timings, survival
  durations, prices, or percentages that are not verifiably true. If a real
  number cannot be verified, describe the principle instead. Ranges and
  "it depends" are acceptable answers; confident invented precision is not.
- **No fake reviews, ratings or `aggregateRating`.** Not in copy, not in
  schema, not "as a placeholder".
- **No schema describing things that do not exist** — no `shippingDetails`
  on a product that ships nothing.
- **No claims of having tested gear.** Recommendations are framed as
  commonly recommended, never as personally tested.
- **Never say something was verified when it was not.** Much of the live web
  is unreachable from this container, including the site's own domain. When
  something could not be checked, say "I could not verify this".

## 4. Safety rules in the content that never bend

- **No foraging instruction, and no field edibility test.** Not for plants,
  not for fungi, not as a game for children. The existing articles say this
  explicitly and must keep saying it.
- **Medical and first-aid content stays conservative**, names the signs that
  mean call for help, and points to real training rather than positioning an
  article as a substitute for it.

---

## 5. Deploy

```bash
npm run build                                    # must be clean
./scripts/site-check.sh after                    # must say "safe"
git checkout claude/digital-product-complete-qrnw9f
git add ... && git commit
git push -u origin claude/digital-product-complete-qrnw9f
git checkout main && git merge --ff-only claude/... && git push origin main
```

git checkout claude/digital-product-complete-qrnw9f  # ALWAYS end here

Pushing `main` triggers `.github/workflows/deploy.yml` → GitHub Pages.
Develop on `claude/digital-product-complete-qrnw9f`; `main` is the deploy
branch and stays a fast-forward of it.

**Switch back to the development branch as the last step of every deploy.**
This has been got wrong three times: the deploy sequence ends on `main`, the
next change is then committed straight to `main`, and the branches diverge.
Nothing is lost when that happens — `git merge main` from the development
branch repairs it, never a reset — but check `git branch --show-current`
before committing rather than relying on remembering.

Commit messages explain *why*, name what was verified, and state anything
that could not be verified. Never put a model name in a commit, a PR, or
anything else pushed to the repo.

---

## 6. What this project is

- **Astro 5, static, TypeScript strict.** Free hosting on GitHub Pages, free
  Actions minutes, self-hosted fonts. Running cost is $0 and must stay $0.
- **`public/CNAME`** holds `bestoutdoorwears.com`. DNS is at Namecheap,
  pointing at GitHub Pages.
- **The product** is one combined kit (layering/packing guide + Survival
  Cards), sold on Whop, delivered automatically. Zero manual work per sale
  is a hard requirement of the owner's, not a preference.
- **`src/lib/paths.ts` `url()`** builds every internal link. Use it; do not
  hard-code paths.
- **Verification tags live in `BaseLayout.astro`** — Google Search Console
  and FlexOffers. Do not remove them.

## 7. Where to look

| File | What it holds |
|---|---|
| `docs/INCOME-ROADMAP.md` | What we do next and why, in order |
| `docs/PRODUCT-STRATEGY.md` | ICP, positioning, pricing rationale |
| `docs/SEMRUSH-BRIEF.md` | Real keyword data from the owner's export |
| `docs/SEMRUSH-BUYER-INTENT.md` | Buyer-intent keyword research |
| `docs/STORE-LISTING.md` | The Whop listing copy |

Nothing in `docs/`, `scripts/` or this file is published to the site. The
check script asserts that on every run.

---

## 8. Things already decided — do not reopen without being asked

- **No physical dropshipping** (Temu/Shein). It breaks the owner's passive
  requirement, and power banks are a regulated lithium-battery category.
- **No paid advertising.** No budget.
- **No customer reviews widget** until there are real customers with real
  reviews.
- **Affiliate programs are deferred** until there is real traffic. FlexOffers
  declined a two-day-old site, which is normal; reapply after roughly two
  months of traffic. Try Payoneer first — it has never been tried. Avoid
  Amazon Associates for now: its three-sales-in-180-days rule closes the
  account and burns the chance.
- **The site keeps its current structure.** The owner has explicitly chosen
  to stay still and build content until real Search Console data arrives.
