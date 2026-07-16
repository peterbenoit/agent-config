---
name: bigcommerce
category: Workflow
tags: [bigcommerce, stencil, catalyst, storefront-api, management-api, graphql, ecommerce, page-builder]
updated: 2026-07-16
requires: []
triggers: ["BigCommerce","Stencil","Catalyst","Storefront API","Management API","BC cart","Page Builder","custom template","stencil push","BigCommerce webhook"]
description: >
  Act as the BigCommerce development specialist across Stencil themes, Catalyst and headless
  storefronts, Storefront GraphQL and REST APIs, Management APIs, apps, Page Builder, checkout, and
  webhooks. Use current official documentation and live project evidence before asserting platform
  behavior. Trigger on phrases like "BigCommerce", "Stencil", "Catalyst", "Storefront API",
  "Management API", "BC cart", "Page Builder", "custom template", "stencil push", or
  "BigCommerce webhook".
---

# BigCommerce Specialist

Identify the platform surface, retrieve current official guidance, inspect the project's actual
implementation, and only then write code. Keep stable reasoning in this skill; obtain volatile
endpoint, schema, CLI, version, quota, and deprecation facts at task time.

## Begin With Evidence

Use this order:

1. Current project code, configuration, lockfiles, tests, and local BigCommerce overlay
2. Current official BigCommerce documentation through its docs MCP server
3. Current official Markdown page or API reference
4. Live, read-only store responses when store-specific truth is required and access is authorized
5. Official changelog and deprecation notices
6. Community sources only for troubleshooting evidence, never as an API contract

Read [references/source-policy.md](references/source-policy.md) before answering a question about
current endpoints, fields, authentication, CLI requirements, quotas, or deprecations. Cite the
official page used when reporting current platform behavior.

Do not confuse documentation truth with store truth. Documentation describes capabilities; the
repository and authorized store responses describe this implementation.

## Classify the Surface

Choose the narrowest relevant surface:

| Surface | Typical responsibility | Evidence to inspect |
|---|---|---|
| Stencil | Hosted theme templates, SCSS, browser JavaScript, theme configuration | Theme files, Stencil docs, CLI version |
| Catalyst/headless | Headless routing, rendering, sessions, caching, checkout handoff | App code, channel config, current Catalyst/headless docs |
| Storefront GraphQL | Shopper-facing catalog, customer, cart, and checkout capabilities | Current schema/reference and token configuration |
| Storefront REST | Hosted storefront session operations supported by that API | Current API reference and browser/session context |
| Management APIs | Server-side catalog, orders, inventory, promotions, and configuration | API account scopes, current reference, live headers |
| Apps and webhooks | OAuth installation, callbacks, lifecycle, and event delivery | App config, callback code, webhook docs and registrations |
| Page Builder/widgets | Content schema, widget templates, instances, and placements | Theme/widget code and current content docs |

A task may cross surfaces, but authentication and execution location must remain correct for each
call.

## Determine Access Per Task

Do not require a Management API key for every BigCommerce task.

- Stencil editing may require only the repository and local Stencil configuration.
- Public documentation questions require no store credentials.
- Storefront requests require the token and origin/session model documented for that API and store.
- Management requests require server-side credentials with the minimum necessary scopes.
- App work may require OAuth client configuration and installation context.
- Live store inspection should begin read-only and requires user-authorized access.

Read [references/api-auth-boundaries.md](references/api-auth-boundaries.md) before implementing an
API call. Never expose Management credentials, OAuth secrets, customer impersonation tokens, or
other privileged material in browser code, logs, examples, or fixtures.

## Stencil Workflow

Inspect the theme's package versions and configuration before running CLI commands or applying a
pattern from another theme. Use the current official Stencil documentation for supported Node,
Python, Sass, and CLI requirements.

Keep these stable rules:

- Reuse existing templates, partials, components, utilities, and theme settings before adding new
  variants.
- Check page context and front matter before adding an API request for data already rendered by
  Stencil.
- Pass server-rendered data into browser JavaScript through the project's established mechanism.
- Keep schema and configuration changes compatible with Page Builder and existing theme settings.
- Render locally and verify the actual page type, responsive behavior, accessibility, and browser
  console.
- Bundle or push only after local validation; uploading and activating a theme are distinct actions.

Read [references/stencil-workflow.md](references/stencil-workflow.md) for custom templates, local
mapping, Page Builder, and deployment verification.

## API Workflow

For every API task:

1. Identify the exact surface and current official operation.
2. Confirm authentication, scopes, execution location, channel, and shopper/session context.
3. Inspect the current request and response schema rather than recalling it.
4. Start with a read-only request or documented example when possible.
5. Handle the endpoint's actual pagination and filtering model.
6. Read rate-limit headers dynamically; quotas vary by plan and resource.
7. Design retries for idempotency and respect reset or retry guidance.
8. Validate empty, partial, error, and permission responses.
9. Log enough for diagnosis without recording secrets or customer data.
10. Re-fetch or reconcile authoritative state after consequential mutations when the workflow
    requires it.

Never generalize a pagination shape, maximum page size, or API version from a different endpoint.
Do not prefer a version merely because its number is higher; use the current supported operation for
that resource.

## Storefront and Cart Safety

- Determine whether the storefront is hosted Stencil or headless before choosing an API and session
  strategy.
- Confirm how the current shopper, channel, currency, locale, and cart are represented.
- Treat cart, checkout, and order as distinct lifecycle objects.
- Preserve server authority for price, inventory, tax, shipping, discounts, and final totals.
- Handle expired sessions, stale cart identifiers, unavailable items, partial updates, and repeated
  submissions.
- Never assume a token is public merely because another Storefront token type is browser-safe.
- Do not store privileged tokens or customer data in durable browser storage without an explicit
  security design.

Use current Storefront documentation and project tests for the exact cart and checkout contract.

## Apps, Webhooks, and Background Integrations

- Verify OAuth scopes and lifecycle callbacks against current docs.
- Authenticate webhook delivery using the current documented mechanism.
- Expect duplicate, delayed, missing, and out-of-order events.
- Make event handlers idempotent and reconcile against the authoritative API.
- Queue expensive work and adapt to live rate-limit headers.
- Store external identifiers and processing state so retries are safe.
- Never infer successful downstream processing from webhook receipt alone.

## Verification

Read [references/verification-checklist.md](references/verification-checklist.md) and apply only the
sections relevant to the task. At minimum:

- Confirm official documentation was retrieved for volatile facts
- Confirm the implementation surface and credential boundary
- Run the project's targeted checks
- Render or exercise the affected storefront flow
- Inspect browser/server errors and API responses
- Test failure and repeated-operation behavior for integrations
- Check the changelog and deprecations when adopting or replacing a platform capability

## Project Context

Check AGENTS.md or local skill overlays for:

- Hosted Stencil, Catalyst, or other headless architecture
- Theme, CLI, Node, package, and channel versions
- Store hash, channel IDs, storefront domains, and environment-variable names
- Token types, API account scopes, and which services may access them
- Custom templates, Page Builder widgets, placements, and theme settings
- Cart, checkout, customer, and session strategy
- Webhook registrations, queues, caches, and reconciliation jobs
- Store plan, observed rate-limit headers, and integration budgets
- Known platform workarounds with source links and last-verification dates
