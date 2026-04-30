# App Name

<!-- One paragraph: what this app does, who uses it, what problem it solves. -->

Built with <!-- React / Vue / Next.js / SvelteKit -->. Backend: <!-- Supabase / Postgres / Firebase / custom API -->. Deployed on <!-- Vercel / Railway / Fly / AWS -->.

## Skills

Agent skills are in `./skills/`. Each subfolder contains a SKILL.md with the role definition,
methodology, and trigger phrases for that specialist. Read the relevant skill before starting
any matching task — don't rely on memory for things the skill defines.

To add project-specific context to a universal skill, create a local overlay:
`./skills/<name>/SKILL.md` — the agent reads both; the local file wins on conflicts.

## Context

If this project has a CONTEXT.md in the root, read it before starting any task.
It defines domain-specific terms, key system relationships, and decisions that should
not be silently reversed. AGENTS.md drives behavior; CONTEXT.md informs language.

## Build & Dev

```sh
npm run dev      # local dev server (typically http://localhost:5173 or :3000)
npm run build    # production build
npm test         # run tests
npm run typecheck  # type-check without emitting
```

<!-- Add: database migrations, seeding, type generation (e.g. npm run types for Supabase) -->

## Environment Variables

Required in `.env.local` (not committed):

```
# Example — replace with actual vars
DATABASE_URL=
API_KEY=
PUBLIC_API_BASE_URL=
```

`.env.local` is in `.gitignore`. Ask the team for values — never commit credentials.

## Architecture

- Auth: <!-- where auth state lives, e.g. src/lib/auth.ts via Supabase client -->
- Data layer: <!-- typed client location, e.g. src/lib/db.ts — import from here, not directly -->
- Routing: <!-- file-based / React Router / TanStack Router -->
- State: <!-- Zustand / Jotai / Context / server state only -->

<!-- Describe non-obvious relationships: what calls what, where source-of-truth lives per concern. -->

## Environments

| Environment | Database | Notes |
|-------------|----------|-------|
| Development | <!-- local Postgres / dev Supabase project --> | `.env.development` |
| Staging | <!-- staging project --> | `.env.staging` |
| Production | <!-- prod project --> | `.env.production` |

Never point a development instance at the production database.

## What Not to Do

- Never commit `.env` files or credentials — use environment variables at runtime
- Never bypass auth middleware at the route level — check authentication inside route handlers too
- <!-- Example guardrail (replace or remove if not using RLS): Never disable Row Level Security (or equivalent access control) to simplify a query — fix the policy -->
- <!-- Add project-specific guardrails here: optimistic update policy, soft-delete pattern, etc. -->
