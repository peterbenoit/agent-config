# CONTEXT — {Store / Project Name}

{Describe what the store sells, who its customers are, and whether the implementation uses hosted
Stencil, Catalyst, another headless storefront, apps/integrations, or a combination.}

---

## Architecture

- **Storefront:** `<!-- Stencil / Catalyst / other headless implementation -->`
- **Store hash configuration:** `<!-- env/config location; never place the value in this file if sensitive -->`
- **Channels and storefronts:** `<!-- IDs, names, domains, and purpose -->`
- **Theme/app versions:** `<!-- package, CLI, Node, Catalyst, or app versions that constrain behavior -->`
- **Server-side integration layer:** `<!-- service/API routes/functions that hold privileged credentials -->`
- **Queues and scheduled jobs:** `<!-- webhook consumers, catalog sync, reconciliation, cache refresh -->`

Record when these facts were last verified. Store configuration may differ from current platform
defaults and from other BigCommerce projects.

---

## Authentication and Access

Document each credential class separately. BigCommerce token types and exposure rules are not
interchangeable.

| Capability | API/surface | Execution location | Credential/session type | Scope | Config name |
|---|---|---|---|---|---|
| `<!-- example: catalog read -->` | `<!-- Management REST -->` | `<!-- server -->` | `<!-- store API account/OAuth -->` | `<!-- read-only -->` | `<!-- env name -->` |
| `<!-- example: shopper cart -->` | `<!-- Storefront GraphQL/REST -->` | `<!-- browser/server -->` | `<!-- exact token/session type -->` | `<!-- channel/origin/customer context -->` | `<!-- config name -->` |

- Never place credential values in this file.
- Identify which operations are approved for read-only diagnostics and which require explicit
  authorization.
- Record API account scopes and token restrictions from current official documentation.

---

## Storefront and Theme

### Stencil

Complete this section only for hosted Stencil work.

- Theme repository and branch: `<!-- location -->`
- Supported local runtime: `<!-- verify against lockfile and current official docs -->`
- Local Stencil configuration file: `<!-- .stencil or current config filename -->`
- Theme settings and schema ownership: `<!-- config.json/schema.json conventions -->`
- Context-to-JavaScript mechanism: `<!-- established injection pattern -->`

Custom templates belong in the appropriate page-type directory:

```text
templates/pages/custom/{brand|category|product|page}/<descriptive-name>.html
```

| Template file | Page type | Local mapped URL | Assigned entity/channel | Assignment owner |
|---|---|---|---|---|
| `<!-- file -->` | `<!-- product/page/etc. -->` | `<!-- real store URL -->` | `<!-- ID/channel -->` | `<!-- control panel/API -->` |

### Catalyst or Other Headless Storefront

- Framework/version: `<!-- version -->`
- Channel and site configuration: `<!-- location -->`
- Session and customer strategy: `<!-- describe -->`
- Checkout handoff/session synchronization: `<!-- describe -->`
- Cache ownership and invalidation: `<!-- describe -->`
- Hosting and environment boundaries: `<!-- describe -->`

---

## Page Builder and Content

- Widget templates managed in code: `<!-- list or None -->`
- Widget instances/placements managed in code: `<!-- list or None -->`
- Merchant-managed regions that automation must not overwrite: `<!-- list -->`
- Content ownership and deployment process: `<!-- describe -->`

Record template, widget, and placement identifiers in the project configuration or a secure
operational system rather than copying mutable live values into universal skill files.

---

## Commerce Flows

### Cart, Checkout, and Order

These are distinct lifecycle objects. Document the project's actual flow:

- Cart API and session context: `<!-- describe -->`
- Checkout creation/handoff: `<!-- describe -->`
- Customer identity and login: `<!-- describe -->`
- Currency, locale, tax, shipping, and promotion authority: `<!-- describe -->`
- Post-order reconciliation: `<!-- describe -->`
- Recovery from expired sessions, unavailable items, and repeated submission: `<!-- describe -->`

### Catalog, Inventory, and Pricing

| Data | Source of truth | API/sync path | Cache | Reconciliation |
|---|---|---|---|---|
| Products/variants | `<!-- source -->` | `<!-- path/job -->` | `<!-- policy -->` | `<!-- policy -->` |
| Inventory/locations | `<!-- source -->` | `<!-- path/job -->` | `<!-- policy -->` | `<!-- policy -->` |
| Price lists/pricing | `<!-- source -->` | `<!-- path/job -->` | `<!-- policy -->` | `<!-- policy -->` |

For distributor integrations such as Lipsey's, keep vendor semantics and mappings in the
project-specific integration overlay. Do not make the universal BigCommerce skill own distributor
pricing, inventory buffers, allocation, or SKU identity rules.

---

## Apps, Webhooks, and Jobs

| Integration | Event/operation | Handler/job | Idempotency key | Reconciliation source |
|---|---|---|---|---|
| `<!-- name -->` | `<!-- scope -->` | `<!-- location -->` | `<!-- strategy -->` | `<!-- authoritative API -->` |

Document retry, deduplication, ordering, dead-letter, and alerting behavior. Webhook receipt is not
proof that downstream processing completed.

---

## Platform Evidence and Known Constraints

For every workaround or platform-sensitive decision, record:

```text
Decision/constraint:
Repository evidence:
Official documentation:
Changelog/deprecation evidence:
Store evidence:
Last verified:
Owner:
```

Do not preserve a workaround after its evidence has expired without re-verifying it.

---

## Decisions

Record project decisions and why they were made. Examples include:

- Hosted versus headless storefront
- Storefront GraphQL versus REST for a particular flow
- Direct storefront calls versus a server intermediary
- OAuth app versus store-level API account
- Theme and Page Builder ownership boundaries
- Cart reconciliation and optimistic update policy
- Cache, webhook, retry, and rate-limit strategy

Each decision should identify its scope, rationale, current source evidence, and conditions that
would justify revisiting it.
