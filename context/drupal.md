# CONTEXT — {Project Name} (Drupal)

{One to two sentences: what this Drupal site does, which team or agency it serves, and
what the development work covers — new theme, module work, migrations, accessibility
remediation, or platform upgrade.}

---

## Glossary

Terms with a specific meaning in Drupal development. Included here because agents not
familiar with Drupal will conflate these or use the wrong word.

**Node** — A piece of content with a type (bundle) and a set of fields. Not every piece
of content is a node — blocks, taxonomy terms, and media entities are distinct. When someone
says "content" without qualification, clarify which entity type they mean.

**Bundle** — A subtype of an entity. For nodes, a bundle is a content type (Article, Page,
Event). For taxonomy, a bundle is a vocabulary. Field configuration is per-bundle.

**Entity** — The generic term for any first-class data object in Drupal: nodes, users,
taxonomy terms, paragraphs, media, blocks, etc. Always say which entity type.

**Field** — A named, typed data attachment to an entity bundle. Managed in configuration.
Fields are reusable across bundles (field storage) but the display and widget settings
are bundle-specific (field instance).

**View** — A configured query and display built with the Views module. Not a PHP template
and not a Twig file. When someone says "the news listing view", they mean a Views-powered
display, not a theme file.

**Block** — A discrete chunk of content or UI placed into a region. Blocks can be custom,
Views-powered, or provided by modules. Block placement is configured per-theme in
Structure → Block Layout.

**Region** — A named slot in the theme where blocks are placed. Defined in `THEMENAME.info.yml`.
Blocks are assigned to regions; regions are rendered in Twig templates.

**Preprocess function** — A PHP function in a `.theme` or module file that runs before a
Twig template renders. Used to pass computed values to templates. Format:
`THEMENAME_preprocess_HOOKNAME(&$variables)`.

**Hook** — Drupal's event/extension system. A hook is a function named
`MODULENAME_HOOKNAME()` that Drupal invokes at specific points. Not to be confused with
React hooks or git hooks.

**Drush** — The Drupal CLI. Essential for cache clears (`drush cr`), config import/export,
database updates, and user management. Assume drush is available unless told otherwise.

**Config sync** — Drupal's configuration management system. Configuration is exported to
YAML files in a sync directory and committed to version control. `drush config:export` and
`drush config:import` are the workflow. Never make configuration changes in production
without a plan to export and commit them.

**Paragraph** — A component-style entity type (from the Paragraphs module) attached to a
node or other entity. A node may have a field that holds a collection of paragraph entities
of mixed types. Paragraphs are how most structured content layouts are built.

**Cache tag** — A string identifier attached to a render element that tells Drupal which
cached output to invalidate when that data changes. Missing cache tags cause stale content.
Overly broad invalidation (like `cache_tags: [node_list]`) kills performance.

**Service** — A PHP class registered in a module's `services.yml` and available via the
Drupal service container. Use `\Drupal::service('service.name')` only outside of injectable
classes; prefer constructor injection.

**Render array** — Drupal's structured array format for describing markup to be rendered.
Do not produce raw HTML strings when a render array is expected — caching, security
(XSS filtering), and alter hooks will not apply to raw strings.

<!-- Add project-specific terms below: -->

**{Term}** — {Definition.}

---

## Key Relationships

- Theme templates live in `<!-- THEMENAME/templates/ -->`. The naming convention is
  `ENTITY--BUNDLE--VIEW-MODE.html.twig`. Drupal selects the most specific match it finds.
  Use `drush twig:debug` (or `twig.config: debug: true` in services.yml) to see which template
  is active on a given element.

- Configuration is managed via `<!-- config/sync/ or sites/default/config/ -->`.
  Export after every configuration change: `drush config:export`. Import in other environments:
  `drush config:import`. Never manually edit the database-stored config in production.

- The active theme is `<!-- THEMENAME -->`. It extends `<!-- PARENT_THEME or none -->`.
  Custom modules live in `<!-- web/modules/custom/ -->`.

- Caching is aggressive. After any code or template change, run `drush cr` (cache rebuild).
  After a configuration change, run `drush config:import` then `drush cr`.

- `<!-- Database, hosting, and environment details go here. -->` 

---

## Decisions

**Configuration in code** — All configuration changes must be exported and committed.
Database-only configuration changes are not acceptable. The config sync directory is the
source of truth, not the live database.

**No direct database queries without cache tags** — If a custom query is used instead of
entity API, cache tags must be set manually on the render array. Missing this causes
stale output after content updates.

**Twig strict mode** — Twig strict variables is `<!-- enabled / disabled -->`. If enabled,
accessing an undefined variable throws an error. Use `variable ?? ''` or `variable|default`
to guard optional variables.

<!-- Project-specific decisions: -->

---

## Common Drush Commands

```bash
drush cr                    # rebuild caches (do this constantly)
drush config:export         # export active config to sync dir
drush config:import         # import config from sync dir to database
drush updb                  # run pending database updates
drush en MODULE_NAME        # enable a module
drush pmu MODULE_NAME       # uninstall a module
drush uli                   # generate a one-time login link
drush sql:dump > dump.sql   # database dump
```

---

## Deployment and Release Process

- Environments: `<!-- local / dev / staging / production -->`
- Deployment steps: pull code → `drush config:import` → `drush updb` → `drush cr`
- Configuration changes require export before deployment; never config:import in prod
  from an unreviewed export
- `<!-- CI/CD pipeline details, if any -->`
