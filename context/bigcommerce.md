# CONTEXT — {Store / Project Name}

{One to two sentences: what this BigCommerce store sells, who its customers are, and what the
custom development work covers (Stencil theme, API integrations, etc.).}

---

## Glossary

BigCommerce-specific terms and any project-specific names that extend them. Skip general
e-commerce terms — only the ones that would confuse or mislead an outside reader belong here.

**Channel** — A BigCommerce sales channel. This store uses a single channel. The channel ID
is required for Storefront API token requests and multi-storefront configuration.
This project's channel ID: `<!-- channel ID -->`

**Storefront API token** — A public, client-side-safe token scoped to a specific channel.
Used for all Storefront API calls from the browser (cart, checkout, customer, products).
Never use Management API credentials client-side. In this project, the token is delivered to
the browser via: `<!-- meta tag name / window global / jsContext key -->`.

**Store hash** — The unique identifier for this BC store, used in all Management API URLs
(`api.bigcommerce.com/stores/{store_hash}/v3/...`). Stored in: `<!-- env var name -->`.

**Stencil context** — The server-rendered Handlebars data object available in `.html` templates.
Use `{{inject}}` + `{{jsContext}}` to pass context values into client-side JavaScript.
Do not make an API call to fetch data that is already available in the Stencil context.

**Custom template** — A Stencil `.html` file following the `custom_<type>_<name>.html` naming
convention. Templates must be activated per-page in the BC admin after upload via `stencil push`.
Templates in use on this store: `<!-- list them -->`.

**Widget** — A Page Builder component registered via the Widgets API. Consists of a Widget
Template (Handlebars) + a Widget instance (configuration) + a Placement (where on the page).
`<!-- List any custom widgets this project has registered, or 'None' -->`.

**Cart vs. Checkout vs. Order** — Distinct states in BC's purchase flow:
- Cart: line items before checkout begins (`/api/storefront/carts`)
- Checkout: payment and shipping collected (Embedded Checkout or hosted BC checkout)
- Order: post-purchase record (`/v2/orders` or `/v3/orders`)

**`<!-- Project-specific term »`** — `<!-- Definition -->`.

---

## Key Relationships

Non-obvious connections between parts of the system.

- Management API calls (Catalog, Orders, Promotions) are server-side only — never called directly
  from the browser. They are proxied through: `<!-- serverless functions / API routes / middleware -->`.

- Storefront API calls (Cart, Customer, product data) are client-side. The Storefront API token
  is injected into the page by: `<!-- how: meta tag in base.html / Stencil jsContext / etc. -->`.

- `config.json` controls available theme settings; `schema.json` exposes them to Page Builder.
  Changes to `schema.json` require `stencil push` to take effect in the admin.

- Product data available in the Stencil Handlebars context (`{{product}}`) does not require a
  Storefront API call. Check the context before adding an API call that may be redundant.

- `<!-- Source-of-truth data flow: e.g. "Promotions are managed via the BC Promotions API and
  cached in X. The Stencil template reads from the cache, not live API." -->`.

---

## Decisions

Choices that were made deliberately and should not be undone without knowing why.

**Direct vs. proxied API calls.** Storefront API calls go direct from the browser using the
channel token. Management API calls are always proxied through server-side middleware because
Management API credentials must never be exposed client-side. Do not move Management API calls
into client-side code.

**`<!-- Auth method decision -->`.** This store uses `<!-- API key / OAuth tokens -->` for
Management API access because `<!-- reason: simpler for a single-store integration / required
for multi-store app, etc. -->`. Do not swap the auth method without updating all endpoints.

**No optimistic cart updates.** Cart state is always re-fetched from the Storefront API after
a mutation. BC cart IDs can change between operations (a new cart is created if the session
expires). Trust the API response, not local state.

**`<!-- Other deliberate decision -->`.** `<!-- Rationale -->`.
