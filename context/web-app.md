<!--
  TEMPLATE: context/web-app.md
  Copy to your project root as CONTEXT.md and replace the example content.
  The fictional project below ("Fieldnotes") shows the right level of detail and register.
  Delete entries that don't apply. Add entries for anything project-specific an agent would
  have to rediscover or guess without this file.
-->

# CONTEXT — {App Name}
<!-- Replace: Fieldnotes is a research capture app — bookmark, annotate, and resurface saved
sources during writing. Built with React, Supabase, and deployed on Railway. -->

{One to two sentences: what this app does, who uses it, and where it runs.}

---

## Glossary

Terms that have a specific meaning in this app. Skip general programming terms — only the
ones that would confuse or mislead an outside reader belong here.

**{Term}** — {Definition. Include which table, component, or file owns it if relevant.}

<!-- Example entries — replace with your own: -->

**Capture** — A saved item in the system (URL, quote, note, file). The top-level domain object.
Maps to the `captures` table in Supabase. Not called "bookmark", "item", or "note" — the
distinction matters because captures can contain child annotations and can be of multiple types.

**Annotation** — A user comment or highlight attached to a Capture. Lives in the `annotations`
table with a `capture_id` foreign key. An annotation belongs to exactly one capture. Never
refer to annotations as "notes" — notes are a capture type, not a synonym for annotation.

**Collection** — A user-created group of captures. Many-to-many: one capture can appear in
multiple collections. The join table is `collection_captures`. UI component: `<CollectionSidebar>`.

**Surfacing** — The process of the app proactively showing the user captures relevant to what
they are currently writing. Distinct from search (which is user-initiated). Implemented in
`src/lib/surfacing.ts`. Do not conflate with recommendations or suggestions in copy or comments.

**RLS** — Supabase Row Level Security. Every table has RLS policies that restrict reads and
writes to the owning user. Never disable RLS to simplify a query — fix the policy instead.

---

## Key Relationships

Non-obvious connections between parts of the system.

<!-- Example entries — replace with your own: -->

- Auth state lives in `src/lib/auth.ts` via Supabase's client. All route protection reads
  from the auth context — never from localStorage directly. `src/components/RequireAuth.tsx`
  is the gating component; use it on every authenticated route.

- `src/lib/supabase.ts` exports the typed Supabase client. Import from here, not from
  `@supabase/supabase-js` directly. Types are generated from the live schema via `npm run types`
  and should be regenerated after any schema change.

- Captures, annotations, and collections are all soft-deleted: they have a `deleted_at` column.
  Every query that lists these objects must filter `deleted_at IS NULL`. Supabase RLS policies
  do not enforce this — it is an application-layer concern. Missing this filter is a silent
  data bug.

- `src/lib/surfacing.ts` runs on every editor focus event. It is debounced at 2 seconds. Do
  not reduce the debounce — it caused 40+ Supabase calls per minute in testing.

---

## Decisions

Choices that were made deliberately and should not be undone without knowing why.

<!-- Example entries — replace with your own: -->

**No optimistic updates.** All mutations wait for the Supabase response before updating UI.
This was decided after an optimistic update caused a sync conflict that corrupted two users'
annotation data in staging. The UX cost is a ~200ms lag; the data integrity benefit is real.

**Client-side rendering only.** The app is a pure SPA deployed as a static bundle. SSR was
evaluated and deferred — Supabase auth cookies behave differently server-side and the session
handling complexity was not worth it for this user base.

**One Supabase project per environment.** Dev, staging, and production each have their own
Supabase project with separate credentials. Never point a dev instance at the production
Supabase URL. The correct URLs are in `.env.development`, `.env.staging`, `.env.production`.
These files are in `.gitignore` — ask for the values in the project channel if you need them.
