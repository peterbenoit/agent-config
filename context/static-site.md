# CONTEXT — {Project Name}

{One sentence: what this project is and does, in plain language.}

---

## Glossary

Terms that have a specific meaning in this project. Skip general programming terms — only the
ones that would confuse or mislead an outside reader belong here.

**{Term}** — {Definition. Include where it lives in the codebase if relevant.}

<!-- Example entries — replace with your own: -->

**Grow entry** — A single article in the `src/grow/` directory. Each is a Markdown file with
frontmatter (`title`, `date`, `tags`, `draft`). The collection is distinct from Posts, which
are news/announcements. Never use the terms interchangeably.

**Plant card** — The `<plant-card>` web component defined in `src/js/plant-card.js`. Renders
a photo, common name, and Latin name from a plant data object. Styling lives in
`src/css/plant-card.css`. Do not add layout styles to the component — it is designed to be
placed inside a grid container.

**Slug** — The URL path segment for any page (`/grow/companion-planting/`). Always lowercase,
hyphen-separated, derived from the filename. Never change a published slug — it breaks inbound
links and search indexing.

**Netlify redirects** — `netlify.toml` contains redirect rules for retired URLs. Check it before
removing or renaming any page. Adding a redirect there is the correct way to retire a URL.

---

## Key Relationships

Non-obvious connections between parts of the system. Focus on dependencies an agent would
otherwise have to rediscover by reading every file.

<!-- Example entries — replace with your own: -->

- `src/_data/plants.json` is the source of truth for all plant data. The plant card component,
  the plant index page, and the `/api/plants.json` endpoint all read from this file. Update
  here first.

- Eleventy processes `src/grow/` into `_site/grow/` on every build. Do not manually edit
  anything in `_site/` — it is a build artifact and gets wiped on every build.

- Netlify's build command runs `npm run build`, which runs Eleventy then copies `public/` into
  `_site/`. Assets in `public/` are served as-is without Eleventy processing.

- Image optimization runs as a separate script (`npm run images`) before deployment. It is not
  part of `npm run build`. Run it manually before committing new images.

---

## Decisions

Choices that were made deliberately and should not be undone without knowing why.

<!-- Example entries — replace with your own: -->

**No JavaScript framework.** The site uses vanilla JS and web components only. This is
intentional — Eleventy was chosen specifically to avoid a JS framework dependency. Do not
introduce a framework to solve a problem that plain JS can handle.

**Grow is not a Blog.** The `grow/` collection is not a blog. Blog implies reverse-chronological
news. Grow entries are evergreen reference content and are sorted alphabetically, not by date.
The distinction is maintained in copy, navigation, and URL structure.

**No client-side search.** Search is handled by Netlify's native search integration. Do not
add a client-side search library — it was evaluated and removed because it added 40KB to the
bundle and duplicated content that Netlify already indexes.
