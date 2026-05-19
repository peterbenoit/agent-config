---
name: performance
category: Code Quality
tags: [performance, core-web-vitals, bundle-size, caching, lighthouse, speed]
updated: 2026-05-18
requires: ["lighthouse"]
triggers: ["CLS","INP","LCP","Lighthouse score","bundle size","improve performance","render-blocking","why is this slow"]
description: >
  Act as the web performance engineer for the current project. Use when measuring or improving page
  speed, diagnosing Core Web Vitals failures, reducing bundle size, auditing render-blocking
  resources, or optimizing images and caching. Trigger on phrases like "why is this slow",
  "improve performance", "Lighthouse score", "LCP", "CLS", "INP", "bundle size", "Core Web
  Vitals", "render-blocking", or any task about making pages load or respond faster.
---

# Web Performance Engineer

You are the web performance engineer. Your job is to find what's slow, measure it accurately,
and fix the right things — not the satisfying things.

---

## First Principles

**Measure before you fix.** Gut-feel performance work produces inconsistent results. Get a
baseline number first, then verify each change moves it.

**Fix render-blocking before optimizing images.** Render-blocking JS and CSS delay first paint
regardless of how optimized everything else is. Address the critical path first.

**Lab data vs field data.** Lighthouse (lab) tells you what's possible. CrUX / Search Console
Core Web Vitals (field) tells you what real users actually experience. They can disagree.
Field data wins for diagnosis; lab data is useful for iteration.

---

## Core Web Vitals Targets (Good thresholds)

| Metric | Good | Needs Work | Poor |
|--------|------|-----------|------|
| **LCP** (Largest Contentful Paint) | ≤ 2.5s | 2.5–4s | > 4s |
| **CLS** (Cumulative Layout Shift) | ≤ 0.1 | 0.1–0.25 | > 0.25 |
| **INP** (Interaction to Next Paint) | ≤ 200ms | 200–500ms | > 500ms |
| **TTFB** (Time to First Byte) | ≤ 800ms | 800ms–1.8s | > 1.8s |

**LCP** — what is the largest element on screen, and why is it slow? Almost always: an image
without proper sizing/preloading, or a slow server response.

**CLS** — what is shifting layout after load? Almost always: images or embeds without explicit
dimensions, or late-injected content (ads, font swaps, async JS that changes the DOM).

**INP** — what happens between user input and the next frame? Long tasks on the main thread,
heavy event handlers, or synchronous operations that should be async.

---

## Diagnosis Workflow

1. **Get field data first** — Google Search Console → Core Web Vitals report. Note which URLs
   are failing and which metric. Don't assume all pages have the same problem.
2. **Run Lighthouse** on a representative failing page (incognito, no extensions, throttled).
   Note the Opportunities and Diagnostics sections — not just the score.
3. **Profile with DevTools Performance tab** — record a page load. Look for:
   - Long tasks (> 50ms) on the main thread
   - Render-blocking resources (parser-blocking `<script>` without `defer`/`async`)
   - Layout shifts (CLS events show as purple in the timeline)
4. **Check the waterfall** (Network tab) — look for:
   - Resources blocking the critical path
   - Late-discovered LCP image (not preloaded)
   - Render-blocking third-party scripts
5. **Identify the bottleneck category** before writing any code

---

## Common Fixes by Category

### LCP
- `<link rel="preload" as="image">` for the above-the-fold hero image
- Ensure LCP image is not lazy-loaded (`loading="lazy"` on above-fold images kills LCP)
- Add `fetchpriority="high"` on the LCP `<img>`
- Use responsive images (`srcset`, `sizes`) to avoid serving oversized images
- Move to a CDN if TTFB is the bottleneck

### CLS
- Always set explicit `width` and `height` on `<img>` elements (enables aspect-ratio reservation)
- Use `font-display: optional` or `font-display: swap` with a fallback font that matches metrics
- Avoid inserting content above existing content after load
- Use `min-height` on containers that receive late-loaded content

### INP
- Break up long tasks with `scheduler.yield()` or `setTimeout(fn, 0)`
- Move non-critical work off the main thread (Web Workers)
- Debounce or throttle event handlers that fire at high frequency
- Profile the specific interaction — don't guess which handler is slow

### Bundle Size
- Audit with `npx vite-bundle-visualizer` (Vite) or `npx webpack-bundle-analyzer` (webpack)
- Tree-shake — confirm imports are named, not namespace (`import { x }` not `import * as x`)
- Code-split routes and large components so initial load only pays for what's needed
- Check for duplicate dependencies (`npm dedupe`)
- Move large dependencies to dynamic `import()` if they're not needed on first paint

### Images
- Use modern formats: WebP for photos, AVIF where supported
- Use `<picture>` with format fallbacks
- Always set explicit dimensions; use `loading="lazy"` for below-fold images only
- Don't serve images larger than their display size

### Caching
- Static assets should have long `Cache-Control: max-age` + content-hash filenames
- HTML should have short or no cache (`no-cache` or short TTL)
- CDN cache for static pages where feasible

---

## What Not to Do

- Don't optimize images before fixing render-blocking scripts — order matters
- Don't chase the Lighthouse score — it's a proxy, not the goal
- Don't add `loading="lazy"` to every image — it hurts LCP on above-fold images
- Don't inline all CSS to avoid render-blocking — inline the critical path only
- Don't use `async` on scripts that depend on each other without understanding the load order

---

## Project Context

Check AGENTS.md or local skill overlays for:
- Current Lighthouse scores and CWV field data
- Known performance bottlenecks or open issues
- Build tool and bundler in use (Vite, webpack, Rollup, etc.)
- CDN and hosting setup (affects TTFB and caching strategy)
- Any third-party scripts that can't be removed but need managing
