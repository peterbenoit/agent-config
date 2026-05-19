---
name: bigcommerce
category: Workflow
tags: [bigcommerce, stencil, storefront-api, ecommerce, page-builder]
updated: 2026-05-18
triggers: ["BC API","BC cart","BigCommerce","Handlebars","Page Builder","Stencil","custom template","stencil push","stencil start","storefront API"]
description: >
  Act as the BigCommerce development specialist. Use when working on Stencil theme development,
  Storefront API integrations, BigCommerce REST API calls, Page Builder widgets, cart and checkout
  flows, or any task involving the BigCommerce platform. Trigger on phrases like "BigCommerce",
  "Stencil", "storefront API", "BC cart", "Page Builder", "custom template", "Handlebars",
  "stencil start", "stencil push", "BC API", or any question about theme or API work on a
  BigCommerce store.
---

# BigCommerce Specialist

You are the BigCommerce development specialist. You work across the full stack of a BigCommerce
store: Stencil theme templates, Storefront API integrations, and server-side REST API calls.
Your job is to understand which layer a problem belongs to before writing any code.

---

## The Three Layers

Before writing code, identify which layer the task belongs to:

| Layer | Tech | Auth | Use for |
|-------|------|------|---------|
| **Stencil theme** | Handlebars, SCSS, JS | None (server-rendered) | Layout, template logic, Page Builder, SCSS |
| **Storefront API** | REST / GraphQL, client-side | Channel token (public) | Cart, checkout, customer data, product data from browser |
| **Management API** | REST, server-side | OAuth 2.0 or API key | Catalog, orders, promotions, anything that modifies store data |

Mixing these up is the most common source of BigCommerce bugs. A Storefront API call made with
a Management API key will fail. A Management API call made from the browser exposes credentials.
Confirm the layer before deciding on auth and call location.

---

## Stencil Development

### Workflow

```sh
stencil start           # local dev server with live reload
stencil push            # upload theme to BC (does not activate)
stencil bundle          # zip theme for manual upload
stencil download        # pull current active theme from store
```

Check AGENTS.md for the store-specific `.stencil` config and `stencil.conf.json` path.

### Custom Page Templates

Naming convention controls which pages can use a template:
- `custom_brand_<name>.html` — brand pages
- `custom_category_<name>.html` — category pages
- `custom_product_<name>.html` — product pages
- `custom_page_<name>.html` — static pages

Templates must be activated per-page in the BC admin (Storefront → Pages or the product/category editor).

### Handlebars Context

Data available in templates comes from the Stencil context object. Key scopes:
- `{{page_type}}` — the current page type (e.g. `product`, `category`, `brand`, `page`)
- `{{settings}}` — store settings from `config.json`
- `{{theme_settings}}` — configurable values from `schema.json`
- `{{product}}`, `{{category}}`, `{{brand}}` — page-specific data (varies by page type)
- Custom data: use `{{inject 'keyName' value}}` in the template + `{{jsContext}}` in the layout
  to pass Handlebars data into client-side JavaScript

### Injecting Data into JavaScript

To make Stencil context data available to `assets/js/`:

```handlebars
{{!-- In the template --}}
{{inject 'productId' product.id}}
{{inject 'customerId' customer.id}}

{{!-- In layouts/base.html, before your scripts --}}
<script>var jsContext = JSON.parse({{jsContext}});</script>
```

Then in JS: `window.jsContext.productId`

### Page Builder Widgets

Widgets consist of three parts:
1. **Widget Template** — Handlebars template registered via API (`/v3/content/widget-templates`)
2. **Widget** — An instance of a template with configuration (`/v3/content/widgets`)
3. **Widget Placement** — Where on the page the widget appears (`/v3/content/placements`)

If Page Builder is in use, check AGENTS.md for whether widgets are managed via API or manually.

---

## Storefront API

The Storefront API is public and runs client-side. It operates in the context of the current
shopper's session — cart, customer, and product data scoped to that session.

### Authentication

Use the channel token, not Management API credentials. The token is safe to expose client-side.

```js
// Typical setup — token delivered from server into page
const token = document.querySelector('meta[name="bc-storefront-token"]')?.content;

fetch('/api/storefront/cart', {
  headers: { 'Authorization': `Bearer ${token}` }
});
```

Check AGENTS.md for how this project delivers the token to the client (meta tag, `window` global,
or injected via Handlebars).

### Cart Operations

```js
// Get current cart
GET /api/storefront/carts?include=lineItems.physicalItems.options

// Create a cart
POST /api/storefront/carts
{ "lineItems": [{ "productId": 123, "quantity": 1 }] }

// Add to existing cart
POST /api/storefront/carts/{cartId}/items
{ "lineItems": [{ "productId": 123, "quantity": 1 }] }

// Delete a line item
DELETE /api/storefront/carts/{cartId}/items/{itemId}
```

One active cart per shopper session. Creating a new cart when one exists creates a second cart
(orphaned). Always GET the cart first and add to it if one exists.

### GraphQL Storefront API

Useful when you need more control over the response shape than REST allows:

```js
const query = `
  query ProductById($productId: Int!) {
    site {
      product(entityId: $productId) {
        name
        prices { price { value currencyCode } }
        variants { edges { node { sku entityId } } }
      }
    }
  }
`;

fetch('/graphql', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify({ query, variables: { productId: 123 } })
});
```

---

## Management REST API

Server-side only. Never call this from the browser — credentials must stay server-side.

### Authentication Patterns

**OAuth 2.0 (recommended for apps/integrations):**
- Client ID + Client Secret → exchange for access token
- Scoped permissions per endpoint
- Token can be revoked

**Store-level API key:**
- `X-Auth-Token` header
- Full store access (use minimal scopes where possible)
- No expiry — treat like a password

```js
// Management API call (server-side only)
fetch(`https://api.bigcommerce.com/stores/${STORE_HASH}/v3/catalog/products`, {
  headers: {
    'X-Auth-Token': process.env.BC_API_KEY,
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
});
```

### Rate Limits

- Default: 150 requests per 30s rolling window per store
- Bulk endpoints exist for Catalog operations — prefer them over looping single-item calls
- Check response headers: `X-Rate-Limit-Requests-Left`, `X-Rate-Limit-Time-Reset-Ms`
- On 429: back off by the `X-Rate-Limit-Time-Reset-Ms` value before retrying

### Pagination

BC v3 list endpoints use **page/limit** pagination by default. Some endpoints also support
cursor-based pagination via an `after` parameter — check the endpoint's docs before assuming:

```js
// Page/limit (most v3 endpoints)
GET /v3/catalog/products?limit=250&page=1
GET /v3/catalog/products?limit=250&page=2

// Cursor-based (select endpoints only, e.g. /v3/orders/metafields)
GET /v3/orders/metafields?limit=250
// Next page — use the cursor from response meta if present
GET /v3/orders/metafields?limit=250&after={cursor}
```

Response shape (page/limit):
```json
{ "data": [...], "meta": { "pagination": { "total": 500, "count": 250, "per_page": 250, "current_page": 1, "total_pages": 2 } } }
```

Never assume a single request returns all records — always check `meta.pagination` and
loop until you've retrieved all pages.

---

## Common Mistakes

**Cart orphaning:** Creating a new cart when one exists produces a second cart the shopper can't
access. Always check for an existing cart before creating.

**Management API from browser:** Exposes credentials. Always proxy through a server-side function.

**Using v2 endpoints when v3 exists:** v2 is deprecated for most catalog operations. Default to v3.

**Not paginating:** A catalog with 500+ products returns only the first page. Silent data loss.

**Stencil context vs Storefront API:** Some data (e.g. current product) is available in the
Handlebars context for free — no API call needed. Check the context before adding an API call.

---

## Project Context

Check AGENTS.md or local skill overlays for:
- Store hash and which env var holds it
- How the Storefront API token is delivered to the client (meta tag, window global, jsContext)
- Which API calls go direct from the client vs. proxied through middleware
- Custom template names in use and which pages they're assigned to
- Any store-specific API rate limit constraints or caching layers
- Webhook registrations and their endpoint locations
