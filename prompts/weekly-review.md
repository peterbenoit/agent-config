---
name: 'weekly-review'
description: 'Run the analytics weekly check-in workflow and produce a 3-bullet action summary'
argument-hint: 'Paste GA4 and Search Console data, or describe what you are seeing'
agent: 'ask'
---

Run a weekly analytics review for: ${input:data:paste GA4/Search Console data or describe what you're seeing}

Read [skills/analytics/SKILL.md](../skills/analytics/SKILL.md) for the analytical framework.
Read AGENTS.md for site-specific context: analytics property, known issues, conversion goals.

---

## Weekly Check-In Workflow

Work through this in order. Do not skip sections because data is missing —
note what is missing and what it would change.

**1. Traffic overview**
- Top 5 pages by sessions this week vs. last week
- Any pages with significant drops (> 20%) or spikes?
- What caused the change? (algorithm, content, technical, social spike)

**2. Search Console**
- New impressions or position changes since last week
- Any crawl errors or coverage issues?
- Pages with high impressions but low CTR (< 2%) — title/description problem

**3. Indexing health**
- Are recently published pages getting indexed within 1–2 weeks?
- Any pages in "Discovered — currently not indexed"?
- For unindexed pages: sitemap inclusion, canonical, internal links, content quality

**4. Content performance**
- Which pages are growing? What do they have in common?
- Which pages have zero impressions? (indexing or topic gap)
- Any pages with good CTR but high bounce? (content doesn't match query)

---

## Output

**Three bullets — what's working, what's not, what to do:**

```
✓ What's working:   [specific page or pattern that's performing]
✗ What's not:       [specific problem with a cause]
→ Action this week: [one specific thing to do, not "monitor"]
```

Then: a prioritized list of pages to fix, improve, or remove — ordered by impact.

---

## What to Ignore

- Bounce rate on blog posts (use engagement rate instead)
- Day-level fluctuations on low-traffic sites
- Social traffic spikes (they don't compound — note them but don't act on them)
- Vanity metrics without a decision attached
