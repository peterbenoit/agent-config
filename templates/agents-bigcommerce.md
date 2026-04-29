# Store / Project Name

<!-- One paragraph: what this BigCommerce store sells, who its customers are, and what the
     custom development work covers (theme customizations, which API integrations, etc.) -->

BigCommerce store. Single channel. Stencil theme with custom templates and Storefront API
integrations. Management API calls proxied server-side.

## Skills

Agent skills are in `./skills/`. Each subfolder contains a SKILL.md with the role definition,
methodology, and trigger phrases for that specialist. Read the relevant skill before starting
any matching task — don't rely on memory for things the skill defines.

Start with the `bigcommerce` skill for any Stencil or API work. To add project-specific context
to a universal skill, create a local overlay: `./skills/<name>/SKILL.md` — the agent reads both;
the local file wins on conflicts.

## Context

Read `CONTEXT.md` before starting any task. It defines store-specific terms, how the Storefront
API token reaches the client, which API calls are direct vs. proxied, and decisions that should
not be silently reversed.

## Store Details

- Store hash: `<!-- stored in BC_STORE_HASH env var -->`
- Channel ID: `<!-- stored in BC_CHANNEL_ID env var -->`
- Storefront API token: delivered to client via `<!-- meta tag / window global / jsContext -->`

## Build & Dev

```sh
stencil start     # local dev server with live reload (http://localhost:3000 by default)
stencil push      # upload theme to BC (does not activate — activate in BC admin)
stencil bundle    # zip theme for manual upload
stencil download  # pull current active theme from store
```

Custom templates must be activated per-page in the BC admin after `stencil push`.

## Environment Variables

Required in `.env` (not committed):

```
BC_STORE_HASH=
BC_CLIENT_ID=
BC_CLIENT_SECRET=
BC_API_KEY=
BC_CHANNEL_ID=
```

`.env` is in `.gitignore`. Never commit credentials or expose Management API keys client-side.

## Architecture

- Stencil templates: `templates/pages/custom/` — custom page templates
- Client-side JS: `assets/js/` — Storefront API calls and UI logic
- SCSS: `assets/scss/` — theme styles
- Server-side middleware: `<!-- directory or function location -->` — proxies Management API calls
- Storefront API: called directly from browser using channel token (Cart, Customer, product data)
- Management API: called server-side only (Catalog, Orders, Promotions) via middleware

## Custom Templates in Use

| Template file | Assigned to |
|--------------|-------------|
| `<!-- custom_page_example.html -->` | `<!-- /example-page/ -->` |

## What Not to Do

- Never make Management API calls from the browser — credentials must stay server-side
- Never use a Management API key as the Storefront API token — they are different auth systems
- Never create a new cart without first checking for an existing cart — orphaned carts accumulate
- Never edit `templates/` files in the BC admin interface — always work in the local Stencil repo
  and push via `stencil push`
- Never change the channel ID or store hash without updating all references — they appear in
  multiple env vars and API calls
- `<!-- Add project-specific guardrails here -->`
