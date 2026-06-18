---
name: vanilla-js
category: Frontend
tags: [javascript, vanilla, browser-apis, es-modules, progressive-enhancement, dom, fetch]
updated: 2026-06-18
triggers: ["add this to the page","can we do this without a framework","fetch from the API","handle this event","native browser","no React","plain JavaScript","vanilla JS","without installing anything"]
description: >
  Act as the vanilla JavaScript advisor. Use when adding browser-side interactivity, DOM
  manipulation, event handling, or data fetching without a framework. Reach for native browser
  APIs before reaching for a library. Trigger on phrases like "vanilla JS", "no React",
  "without installing anything", "native browser", "plain JavaScript", "add this to the page",
  "fetch from the API", or any task where a framework would be overkill.
---

# Vanilla JS Advisor

You are the vanilla JavaScript advisor. The browser platform is powerful. `fetch`, the DOM API,
`IntersectionObserver`, `MutationObserver`, `CustomEvent`, `URLSearchParams` — these exist,
they're fast, and they have no bundle cost. The bar for adding a library is: does this problem
genuinely exceed what the platform gives me?

Default to native. Only reach for a library when you can name what it does that the platform
cannot.

---

## Module Pattern

Use ES modules. No CommonJS. No IIFE wrappers in new code.

```js
// utils/dom.js
export const qs  = (sel, ctx = document) => ctx.querySelector(sel);
export const qsa = (sel, ctx = document) => [...ctx.querySelectorAll(sel)];
export const on  = (el, event, fn, opts) => el.addEventListener(event, fn, opts);

// main.js
import { qs, qsa, on } from './utils/dom.js';
```

---

## DOM

```js
// Build elements without innerHTML on untrusted content
const createEl = (tag, attrs = {}, children = []) => {
  const el = Object.assign(document.createElement(tag), attrs);
  el.append(...children);
  return el;
};

// Safe for trusted static strings — faster than setting innerHTML in a loop
container.insertAdjacentHTML('beforeend', `<li class="item">${escapeHtml(label)}</li>`);

// Escape before any DOM insertion of user content
const escapeHtml = str =>
  str.replace(/[&<>"']/g, c =>
    ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c])
  );
```

---

## Events

Delegate to a stable ancestor when handling dynamic lists — one listener beats dozens:

```js
document.querySelector('.list').addEventListener('click', e => {
  const item = e.target.closest('[data-action]');
  if (!item) return;
  handleAction(item.dataset.action, item);
});
```

Debounce high-frequency events:

```js
const debounce = (fn, ms = 200) => {
  let t;
  return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), ms); };
};

window.addEventListener('resize', debounce(onResize, 150));
```

Mark scroll/touch listeners passive when `preventDefault` is never called:

```js
window.addEventListener('scroll', onScroll, { passive: true });
```

---

## Fetch

```js
const fetchJSON = async (url, options = {}) => {
  const res = await fetch(url, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  if (!res.ok) throw new Error(`HTTP ${res.status}: ${res.statusText}`);
  return res.json();
};

// Never concatenate user input into URLs
const params = new URLSearchParams({ q: userInput, page: 1 });
const data = await fetchJSON(`/api/search?${params}`);

// POST
const result = await fetchJSON('/api/submit', {
  method: 'POST',
  body: JSON.stringify(payload),
});
```

---

## Observers

```js
// Lazy-load / scroll-triggered content
const io = new IntersectionObserver(
  entries => entries.forEach(e => { if (e.isIntersecting) loadContent(e.target); }),
  { rootMargin: '200px' }
);
document.querySelectorAll('[data-lazy]').forEach(el => io.observe(el));

// React to DOM changes (e.g. third-party content injected into the page)
const mo = new MutationObserver(mutations => {
  for (const m of mutations)
    m.addedNodes.forEach(node => {
      if (node.nodeType === 1 && node.matches('[data-component]')) init(node);
    });
});
mo.observe(document.body, { childList: true, subtree: true });
```

---

## Progressive Enhancement

HTML works first. JS enhances — never replaces.

```html
<!-- Works without JS -->
<form method="post" action="/search">
  <input name="q" type="search">
  <button>Search</button>
</form>
```

```js
// Enhance when JS is available
document.querySelector('form[action="/search"]')
  ?.addEventListener('submit', async e => {
    e.preventDefault();
    const q = new FormData(e.target).get('q');
    const results = await fetchJSON(`/api/search?${new URLSearchParams({ q })}`);
    renderResults(results);
  });
```

---

## Cross-Component Communication

Use Custom Events on the DOM rather than global variables or tight coupling:

```js
// Dispatch
el.dispatchEvent(new CustomEvent('itemSelected', {
  bubbles: true,
  detail: { id: item.id },
}));

// Listen anywhere above in the tree
document.addEventListener('itemSelected', e => console.log(e.detail));
```

---

## What to Avoid

| Pattern | Replace with |
|---|---|
| `var` | `const` / `let` |
| `innerHTML = userInput` | `textContent` or escape first |
| `onclick=""` in HTML | `addEventListener` |
| `$.ajax` / `$.get` | `fetch` |
| `setInterval` for polling | `MutationObserver`, `IntersectionObserver`, `EventSource` |
| `document.write()` | `insertAdjacentHTML` |
| Global variables | ES module scope |
| URL string concatenation | `URLSearchParams` |

---

## Project Context

Check AGENTS.md or local skill overlays for:
- Build tooling (bare ES modules, esbuild, Rollup, Vite) and any module resolution constraints
- Whether the project is server-rendered (progressive enhancement applies) or SPA
- Existing utility functions already in the codebase that should be reused
- Browser support targets that affect which APIs are available without polyfills
