# Build the first version of profxj.github.io with Claude

## Goals

Use Claude to build the **first public version** of J. Xavier Prochaska's
professional website in this dedicated GitHub Pages repo (`profxj.github.io`),
starting from the **academicpages** Jekyll template. Along the way, JXP will
learn how such websites are built (Jekyll structure, `_config.yml`, collections,
navigation, GitHub Actions deployment).

This file continues the work begun in `~/bin/claude_prompts/website_prompts.md`
(the "Prep" phase, where we chose the repo, theme, and sections). That phase is
done; from here on, **all development happens in this repo.**

## Context

J. Xavier Prochaska — Professor of Astronomy & Astrophysics, UC Santa Cruz;
Astronomer, UC Observatories. Email: jxp@ucsc.edu. GitHub: https://github.com/profxj

GitHub Organizations that JXP has launched (source material for the Software
section):

- https://github.com/FRBs
- https://github.com/pypeit
- https://github.com/ocean-colour
- https://github.com/Sea-Meets-the-Stars
- https://github.com/linetools

His prior (minimal) professional website: https://www.ucolick.org/~xavier/Welcome.html

**Decisions carried over from the Prep phase:**

- Repo: `profxj.github.io` (user site → live at https://profxj.github.io/).
- Theme: **academicpages** (already cloned into this repo from the template).
- Deployment: **GitHub Actions** (academicpages default); default `*.github.io`
  URL, no custom domain.
- Sections to include in the navigation: **Publications, Software, Blog/News,
  Contact**. Drop the default Talks / Teaching / CV menu items (the collection
  folders can remain; they just won't appear in the menu).
- "Software" reuses academicpages' built-in `_portfolio/` collection, relabeled
  in `_data/navigation.yml`, to showcase PypeIt, linetools, FRBs, ocean-colour,
  Sea-Meets-the-Stars, etc.

## Skills

Consider using the Claude skills in `~/bin/.claude/skills/`.

## Conventions

- **Git is handled by Xavier.** Claude edits files; Xavier runs
  `git add` / `commit` / `push`. After a push, the GitHub Actions workflow
  rebuilds and the site updates at https://profxj.github.io/ within ~1–2 min
  (watch the repo's **Actions** tab).
- For local preview, the repo ships a Dockerfile / docker-compose and a Gemfile;
  `bundle exec jekyll serve` (or the Docker route) renders the site at
  http://localhost:4000.

## Prompts

1. Read this file. Execute the 1st task under "Tasks".

## Tasks

1. **Survey the template.** Examine the academicpages files in this repo and
   describe in the Report section how it is organized: `_config.yml`,
   `_data/navigation.yml`, the collections (`_publications`, `_portfolio`,
   `_posts`, `_pages`, etc.), `_layouts`/`_includes`, and how a page becomes a
   menu item. Confirm how the site builds/deploys. Put any questions in Q&A and
   log the work.

2. **Configure site identity.** Edit `_config.yml`: set name, title/role, bio,
   `email`, `url: https://profxj.github.io`, `repository: profxj/profxj.github.io`,
   and the author sidebar/social links (GitHub `profxj`, ORCID if provided).
   Replace the demo author photo reference. Log the work.

3. **Trim the navigation.** Edit `_data/navigation.yml` down to the four chosen
   menu items — Publications, Software, Blog/News, Contact — relabeling the
   portfolio entry as "Software". Log the work.

4. **Populate the sections.**
   - **Publications** — set up `_publications/` per the agreed source
     (BibTeX / ADS / Scholar / ORCID, likely a curated subset plus a link to the
     full ADS library).
   - **Software** — write `_portfolio/` entries for the key repos/orgs above.
   - **Blog/News** — seed `_posts/` with an initial welcome/news post.
   - **Contact** — a simple contact page; ensure email/GitHub/ORCID render in the
     sidebar.
   Log the work.

5. **Preview & polish.** Build locally (Jekyll/Docker), check each page and the
   navigation, fix layout/content issues, then hand off to Xavier to commit/push
   and verify the live site. Log the work.

### Report

#### How academicpages is organized

**1. `_config.yml` (site-wide settings).** One file that rarely changes. Holds:
- *Identity*: `title`, `name`, `description`, `url`, `baseurl`, `repository`.
  Still set to template defaults ("Your Name", `url: https://academicpages.github.io`,
  `repository: academicpages/academicpages.github.io`) — these are Task 2's job.
- *`author:` block* — drives the left sidebar (avatar, bio, location, employer,
  email) and the social/academic icon links (`github`, `orcid`, `googlescholar`,
  `bluesky`, etc.). A field left blank → its icon does not render. Currently all
  demo values ("Your Sidebar Name", `github: academicpages`, etc.).
- *`publication_category:`* — defines the headings the Publications page groups by:
  `books` → "Books", `manuscripts` → "Journal Articles", `conferences` →
  "Conference Papers". A publication's `category:` front-matter must match one of
  these keys to be grouped.
- *`collections:`* — registers `teaching`, `publications`, `portfolio`, `talks`
  with `output: true` and `permalink: /:collection/:path/`.
- *`defaults:`* — sets the default `layout` + options per collection/type (e.g.
  posts & pages → `layout: single`; talks → `layout: talk`; all get
  `author_profile: true` so the sidebar shows).
- *Build*: kramdown (GFM) + rouge, Sass compressed, and `plugins:` (jekyll-feed,
  -gist, -paginate, -sitemap, -redirect-from, jemoji).

**2. `_data/navigation.yml` (the top menu).** A single `main:` list of
`{title, url}` pairs. `_includes/masthead.html` loops over
`site.data.navigation.main` to render the header links (and auto-marks the
current page "selected"). The site title link to `/` is hard-coded separately,
so the menu list is *only* the items to the right of the name. **Removing an
entry here removes it from the menu but does NOT delete the underlying page or
collection** — exactly what the plan calls for (Talks/Teaching/CV pages stay,
just leave the menu). Current menu: Publications, Talks, Teaching, Portfolio,
Blog Posts (→ `/year-archive/`), CV, Guide. Target (Task 3): Publications,
Software, Blog/News, Contact.

**3. Collections & content directories.**
- `_publications/` — one Markdown file per paper (`YYYY-MM-DD-slug.md`). Front
  matter: `title, collection: publications, category, permalink, excerpt, date,
  venue, paperurl, citation`. 5 demo papers present.
- `_portfolio/` — one file per item (`.md` or `.html`). Minimal front matter
  (`title, excerpt, collection: portfolio`). This is what we relabel as
  **Software**. 2 demo items present.
- `_posts/` — blog posts (`YYYY-MM-DD-slug.md`), standard Jekyll. 5 demo posts.
- `_talks/`, `_teaching/` — kept but will be unlinked from the menu.
- `_pages/` — the standalone pages and the *index/listing* pages that power each
  menu target. Each listing page sets its own `permalink` and `layout: archive`
  and loops over a collection:
  - `publications.html` (`permalink: /publications/`) → groups `site.publications`
    by `publication_category`, rendering each via `_includes/archive-single.html`.
  - `portfolio.html` (`permalink: /portfolio/`) → loops `site.portfolio`.
  - `about.md` (`permalink: /`) → the **home page** (currently template marketing
    copy; needs replacing with JXP's bio).
  - `year-archive.html`, `cv.md`, `talks.html`, `teaching.html`, plus utility
    pages (`404.md`, sitemap, archives, `markdown.md` guide).

**4. `_layouts` / `_includes`.** Layouts (`default`, `single`, `archive`,
`talk`, `cv-layout`, `splash`, `compress`) define page skeletons; `single` and
`archive` are the workhorses. Includes are reusable fragments — notably
`masthead.html` (top nav), `author-profile.html` + `sidebar.html` (the
`author:`-driven sidebar), `archive-single.html` (one list row for a
collection item), `seo.html`, `footer.html`. `_data/authors.yml` and
`_data/ui-text.yml` supply multi-author and label/i18n data.

**5. How a page becomes a menu item.** Two independent steps:
(a) the page/listing must *exist* with a `permalink` (e.g. `publications.html`
sets `/publications/`); (b) an entry in `_data/navigation.yml` must point its
`url` at that permalink. `masthead.html` renders only (b). So a page can exist
without a menu link (Task 3's plan for Talks/Teaching/CV) — and a menu link
will 404 if no page owns its permalink.

#### Build & deploy
- **Local preview**: `bundle exec jekyll serve -l -H localhost` (Gemfile pins
  `github-pages` + `jekyll`, webrick) → http://localhost:4000. Or Docker:
  `docker-compose up` builds the `Dockerfile` and runs
  `jekyll serve -H 0.0.0.0 -w --config _config.yml,_config_docker.yml` on
  port 4000 (`_config_docker.yml` overrides `baseurl` for the container).
- **Deploy**: There is **no checked-in Jekyll build workflow** in
  `.github/workflows/` — only `bad-pr.yml` (closes upstream-targeted PRs) and
  `scrape_talks.yml` (regenerates the talk map). academicpages relies on
  GitHub's *built-in* **`pages-build-deployment`** action: with Pages set to
  "Deploy from a branch" (`master`), every push triggers GitHub to build the
  Jekyll site with `--safe` and publish it. That built-in build is what the
  README's `pages-build-deployment` badge tracks, and it is the "GitHub Actions
  default" referenced in the plan. (See Q&A — one decision to confirm.)

### Q&A

**Q1 (deploy mechanism — needs Xavier's confirmation in repo Settings).** The
plan says "Deployment: GitHub Actions (academicpages default)". To be precise:
academicpages does *not* ship a custom `.github/workflows/jekyll.yml`. It uses
GitHub's built-in **pages-build-deployment** (classic *Deploy from a branch*),
which runs in `--safe` mode and only allows whitelisted plugins (already listed
under `whitelist:` in `_config.yml`). Please confirm in
**repo → Settings → Pages** that *Source = "Deploy from a branch", Branch =
`master` / `/ (root)`*. If instead you want the newer *"GitHub Actions"* source
(which would let us drop a `jekyll.yml` and use unrestricted plugins), say so
and I'll add the workflow. Either works; the built-in path is zero-config and
matches the template default.

**Q2 (home page).** `_pages/about.md` (`permalink: /`) is the front page and
currently holds template marketing copy. The plan's four menu items don't
include a "Home/About", but the landing page still needs JXP's bio. I'll
rewrite `about.md` as the bio/landing page during Task 2/4 unless you'd prefer
a separate Contact/About split.

**Q3 (ORCID / Scholar / publication source).** Task 2 wants ORCID and Task 4
wants a publications source. Please provide: ORCID iD, Google Scholar URL (the
template ships a placeholder `PS_CX0AAAAAJ`), and how you want Publications
seeded — curated subset of `_publications/*.md` + a link to your full ADS
library is the plan's suggestion. An ADS library URL or a BibTeX export would
let me populate real entries.


## Logging

The "Logs" section will record Claude's work. Please use the following format:

### <Date> (Short summary of the work)

<Detailed description of the work and what you learned>

### <Date> (Short summary of the work)

<Detailed description of the work and what you learned>

...

## Logs

### 2026-06-20 (Task 1 — surveyed the academicpages template)

Read the repo end-to-end: `_config.yml`, `_data/navigation.yml`,
`_includes/masthead.html`, the listing pages in `_pages/`, sample entries in
`_publications`/`_portfolio`/`_posts`, the layouts/includes inventory, the
Gemfile, `docker-compose.yaml`, and `.github/workflows/`. Findings written up in
the **Report** section above.

Key things learned:
- The top menu is purely `_data/navigation.yml` → rendered by
  `masthead.html`; editing it does not touch pages/collections, so we can drop
  Talks/Teaching/CV from the menu while keeping their files (matches the plan).
- Each menu target is a listing page in `_pages/` (`publications.html`,
  `portfolio.html`, etc.) with its own `permalink` + `layout: archive` that
  loops over a collection. A menu link 404s unless a page owns its permalink.
- "Software" = relabel the `_portfolio` collection's nav entry; the page
  (`portfolio.html`, permalink `/portfolio/`) and collection stay as-is.
- The sidebar (icons/bio) is entirely driven by the `author:` block in
  `_config.yml` — blank field = hidden icon.
- `_pages/about.md` (permalink `/`) is the home page and still has template copy.
- **Deploy**: no custom Jekyll workflow is checked in; the site relies on
  GitHub's built-in `pages-build-deployment` (Deploy-from-a-branch, `--safe`,
  whitelisted plugins). Raised as Q1 for Xavier to confirm in Settings → Pages.

Three open questions logged in **Q&A**: (1) confirm the Pages deploy source,
(2) home-page/bio handling, (3) ORCID / Scholar / publications source to use in
Tasks 2 & 4. No files other than this prompt log were modified.
