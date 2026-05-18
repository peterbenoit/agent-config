# <!-- Project Name --> (Drupal)

<!-- One paragraph: what this Drupal site does, which team or client it serves, and what the
     current development scope covers — new theme, module work, migration, content modeling,
     accessibility remediation, or major version upgrade. -->

## Skills

Agent skills are in `./skills/`. Each subfolder contains a SKILL.md with the role definition,
methodology, and trigger phrases for that specialist. Read the relevant skill before starting
any matching task.

For this project, the most relevant skills are: `drupal`, `debug`, `508`, `performance`, `security`, `tdd`.
To add project-specific context, create a local overlay: `./skills/<name>.local.md`.
Do not edit `SKILL.md` directly — it will be overwritten on updates.

## Context

Read `context/drupal.md` from agent-config, or a local `CONTEXT.md` if one exists, before
starting any Drupal task. Drupal has precise vocabulary (node, bundle, entity, view, region,
preprocess, hook) — use it correctly.

## Drupal Version

<!-- Drupal 9 / 10 / 11 -->

PHP: `<!-- version -->`
Composer: `<!-- version -->`

## Theme

Custom theme: `<!-- theme machine name -->`
Location: `web/themes/custom/<!-- theme name -->/`
Base theme: `<!-- Stable9 / Stable / Classy / none -->`

Template overrides go in `templates/`. Preprocess functions and hook implementations go
in `<!-- theme name -->.theme`. Libraries are defined in `<!-- theme name -->.libraries.yml`.

## Modules

Contrib modules relevant to this project:
<!-- List key contrib modules: paragraphs, views, pathauto, metatag, webform, etc. -->

Custom modules (if any):
<!-- Location: web/modules/custom/ -->

## Config Sync

Config sync directory: `<!-- config/sync or similar -->`

Workflow:
```bash
drush cex          # export current config to sync dir
git add config/    # commit
drush cim          # import on another environment
drush cr           # clear caches after any config change
```

Never hand-edit UUIDs. Config split module: `<!-- in use / not in use -->`.

## Build & Dev

```bash
# Local environment
<!-- lando / ddev / docksal / native -- add start command here -->

# Common drush commands
drush cr                    # clear all caches
drush updb                  # run pending database updates
drush cex && drush cim      # sync config
drush uli                   # one-time login link
```

## Environments

| Environment | URL | Purpose |
|-------------|-----|---------|
| Local | `<!-- http://project.lndo.site or similar -->` | Development |
| Dev | `<!-- URL -->` | Integration, review |
| Staging | `<!-- URL -->` | Pre-release QA |
| Production | `<!-- URL -->` | Live |

Deployment process: `<!-- describe: manual / CI/CD pipeline / platform.sh / Acquia / Pantheon -->`

## Environment Variables

```
# Drupal database — managed by local env tool (Lando/DDEV) or .env file
DRUPAL_DB_HOST=
DRUPAL_DB_NAME=
DRUPAL_DB_USER=
DRUPAL_DB_PASS=
# External service API keys (if any)
```

Never commit `.env` or `settings.local.php`. Secrets managed via:
`<!-- hosting platform secrets / AWS / manual server config -->`

## Architecture

<!-- Describe the content model at a high level: main content types, key views, key integrations.
     Include: headless/decoupled if applicable, any external APIs the Drupal site calls,
     search integration (Solr / search_api), media handling, multilingual setup. -->

## Known Issues / Active Work

<!-- List any open bugs, performance problems, or in-progress migrations that an agent
     should know about before touching related code. -->

## Hard Rules

- Never hand-edit exported config UUID fields
- Run `drush cr` after any hook, preprocess, or module change
- Never query the database directly from a Twig template
- Never put business logic in Twig — pass computed values from preprocess
- Accessibility: WCAG 2.1 AA minimum; Section 508 if federal client
