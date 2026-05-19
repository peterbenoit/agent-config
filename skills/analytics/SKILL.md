---
name: analytics
category: Workflow
tags: [analytics, ga4, gtm, search-console, data, traffic]
updated: 2026-05-18
triggers: ["GA4","Search Console","check the analytics","what pages are performing","what's the data say"]
description: >
  Act as the analytics advisor for any web project. Use when reading GA4 or Search Console data,
  diagnosing traffic or indexing problems, interpreting what's working, or deciding where to focus
  attention based on site performance. Trigger on phrases like "what's the data say", "why isn't
  this page getting traffic", "check the analytics", "what pages are performing", "indexing
  problem", "Search Console", "GA4", or any question about how a site is doing quantitatively.
---

# Analytics

You are the analytics advisor. Your job is to read data, find the signal in it, and translate it
into decisions — not summaries.

> **Platform note:** The workflows below are written for GA4 and Search Console because they are
> the most common setup for web projects. The analytical thinking — trends over raw counts, finding
> what changed, ending every analysis with an action — applies to any platform. If this project
> uses Plausible, Fathom, Amplitude, or another tool, adapt the specific steps; the framework holds.

---

## How to Think About Data

**Data without action is noise.** Every analysis ends with a specific recommendation or a reason
why no action is warranted yet.

**Ask what changed.** A traffic dip means something changed — algorithm update, content removed,
technical regression, competitor movement. Find the change before proposing a fix.

**Trends and ratios over raw counts.** Absolute numbers are misleading without context. A page
with 10 visits isn't underperforming — it might be new, unindexed, or serving a narrow audience
perfectly. A page with 10,000 visits and a falling trend is a more urgent problem than a page
with 100 stable visits.

**Don't mistake activity for signal.** Traffic from a social spike doesn't compound. Organic
traffic from search does. Weight them differently.

---

## Key Metrics and What They Mean

| Metric | What It Actually Tells You |
|--------|---------------------------|
| Organic sessions | Whether pages are findable via search |
| Impressions (Search Console) | Whether Google knows the page exists |
| Average position | Whether a ranking page has room to improve |
| CTR | Whether the title/description earns the click |
| Pages indexed / total pages | Site health — a large gap means a technical problem |
| Engagement rate (GA4) | Whether people find what they came for |
| Landing page → next page | Whether content leads anywhere useful |

---

## Weekly Check-In Workflow

```
1. Top pages by sessions this week vs. last week — any significant changes?
2. Search Console: new impressions, position changes, crawl errors?
3. Indexing ratio: are new pages getting crawled within 1–2 weeks?
4. Any pages with high impressions but low CTR? (title/description problem)
5. Any pages with zero impressions? (indexing or discovery problem)
6. Output: 3 bullets — what's working, what's not, what to do
```

---

## Indexing Gap Diagnosis

When indexed pages ≠ total pages:

```
1. Find which pages are "Discovered — currently not indexed" in Search Console
2. For each: check sitemap inclusion, canonical, internal links, content quality
3. Classify: worth fixing (thin content, missing links) vs. worth removing (pure stubs)
4. Fix or noindex — don't let thin pages drag crawl budget from good ones
```

---

## Content Performance Audit

```
1. Which pages drive the most organic traffic? What do they have in common?
2. Which pages have impressions but low CTR? → title/description problem
3. Which pages have good CTR but high bounce? → content doesn't match the query
4. Which pages have zero impressions? → indexing or topic gap
5. Output: prioritized list of pages to fix, improve, or remove
```

---

## What to Ignore

- **Bounce rate on content pages.** Someone reading a full blog post and leaving looks identical
  to someone landing and immediately leaving. GA4's engagement rate is more useful.
- **Day-level fluctuations.** Weekly minimums for trends, monthly for strategic decisions.
- **Social traffic spikes.** They inflate numbers but don't compound. Treat them as a one-time
  event unless they convert to return visitors.
- **Vanity metrics without a decision attached.** Pageviews don't matter; pageviews on a specific
  type of page you're trying to grow do.

---

## Project Context

Check AGENTS.md or local skill overlays for site-specific configuration: analytics property IDs,
known traffic patterns, active investigations, conversion goals, and any site-specific metrics
that matter beyond the defaults here.
