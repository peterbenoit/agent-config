---
name: 'pre-publish'
description: 'Run QA, accessibility, SEO, and security checks before publishing a page or post'
argument-hint: 'Path to the file to review, or leave blank to use the active file'
agent: 'agent'
tools: ['search/codebase', 'vscode/openFile']
---

Run a full pre-publish review on ${input:file:path to file, or press Enter to use active file}.

If no file is specified, use the file currently open in the editor.

Work through each section below in order. Report every finding — do not silently skip checks.
At the end, produce a summary: what passed, what failed, what needs a decision.

---

## 1. HTML Correctness

- [ ] `<title>` present, unique, 50–70 chars for blog posts / 50–60 for project pages
- [ ] `<meta name="description">` present, 150–160 chars, specific and active
- [ ] `<meta charset="utf-8">` present
- [ ] `lang` attribute on `<html>` matches the page language
- [ ] No duplicate `id` attributes
- [ ] No deprecated elements (`<center>`, `<font>`, `<b>` for styling)

## 2. Accessibility (WCAG 2.1 AA)

- [ ] Exactly one `<h1>` — heading hierarchy logical, no skipped levels
- [ ] `<main id="main-content">` wraps primary content
- [ ] `<nav>` elements have `aria-label`
- [ ] All `<img>` have `alt` attributes (decorative = `alt=""` + `aria-hidden="true"`)
- [ ] All buttons have accessible names
- [ ] All links have meaningful text (not "click here", "read more")
- [ ] No `user-scalable=no`
- [ ] SVG icons: decorative = `aria-hidden="true"`, standalone = `aria-label` on parent

## 3. SEO

- [ ] Canonical tag present and pointing to the correct URL
- [ ] Full Open Graph tags: `og:type`, `og:url`, `og:title`, `og:description`, `og:image`
- [ ] Twitter card tags: `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image`
- [ ] `og:image` URL is absolute (not relative)
- [ ] Correct JSON-LD schema type for this page (BlogPosting / SoftwareSourceCode / Article)
- [ ] JSON-LD includes: `headline` or `name`, `url`, `author`
- [ ] If noindex is intentional, confirm `<meta name="robots" content="noindex">` is present

## 4. Security

- [ ] No credentials, API keys, or tokens in source — check comments too
- [ ] No private URLs (staging, internal IPs, non-public repo links)
- [ ] No personal contact info (email, phone, home address)
- [ ] No employer or client names not already public
- [ ] GitHub repo links — confirm repos are public before publishing

## 5. Content Quality

> The checks below reflect personal publishing preferences, not universal standards.
> Adjust to match the project's own voice and style guidelines.

- [ ] No em-dashes anywhere (titles, meta, body, related links, comments)
- [ ] No "battle-tested", "robust", "seamless", or marketing language
- [ ] Opening sentence does not start with "In this post..." or "I'm excited to share..."
- [ ] Page has enough unique content to be worth indexing (not a stub)

## 6. Required Scripts / Structure (check AGENTS.md for project conventions)

- [ ] Required scripts present before `</body>` in the correct order
- [ ] Analytics snippets present before `</head>`
- [ ] Footer is outside `</main>`
- [ ] Breadcrumb nav (if present) is outside `<main>`

---

## Output Format

Produce a checklist with pass/fail for each item. For each failure:
1. Quote the specific element or line that fails
2. State which criterion it violates
3. Give the exact fix needed (with corrected code if short)

End with one of:
- **Ready to publish** — all checks pass
- **Publish with fixes** — minor issues, list them
- **Do not publish** — blocking issues found, list them
