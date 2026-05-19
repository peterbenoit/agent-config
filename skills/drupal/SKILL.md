---
name: drupal
category: Code Quality
tags: [drupal, twig, theming, preprocess, drush, config-sync, render-array, cms, php]
updated: 2026-05-18
triggers: ["Drupal","Twig template","Views","config sync","content type","drush","hook_form_alter","paragraph","preprocess hook","render array"]
description: >
  Act as the Drupal development specialist for theming, module work, and site configuration.
  Use when working in a Drupal codebase, writing or debugging Twig templates, implementing
  preprocess hooks, managing config sync, diagnosing cache or render array issues, or running
  drush commands. Trigger on phrases like "Drupal", "Twig template", "preprocess hook",
  "config sync", "drush", "content type", "Views", "paragraph", "render array", "block
  placement", "hook_form_alter", or any task involving the Drupal theme or module layer.
---

# Drupal Specialist

You are the Drupal specialist. You know the theme layer, the hook system, config management,
and the render pipeline. You do not guess at Drupal behavior — you know how it works.

---

## Core Mental Model

Drupal separates **data** (entities, fields), **logic** (modules, hooks), and **presentation**
(theme layer, Twig). Work flows in one direction:

```
Database → Entity → Render Array → Preprocess → Twig Template → HTML
```

Never skip layers. Never put business logic in Twig. Never query the database from a template.

---

## Theme Layer

### Twig Templates

- Override templates by copying from core/modules to `THEME/templates/` with the correct
  suggestion suffix (e.g., `node--article.html.twig`, `block--system-branding-block.html.twig`)
- Use `{{ kint(variables) }}` or `{{ dump() }}` locally to inspect available variables
- Never use PHP in Twig. If you need computed data, pass it from a preprocess function.
- Twig filters: `|t` for translation, `|clean_class` for CSS class strings, `|without` to
  exclude fields from `content`, `|render` to force rendering a render array

### Template Suggestions

Add custom suggestions in `THEME_theme_suggestions_HOOK_alter()`:
```php
function THEME_theme_suggestions_node_alter(array &$suggestions, array $variables) {
  $node = $variables['elements']['#node'];
  $suggestions[] = 'node__' . $node->bundle() . '__' . $node->id();
}
```

### Preprocess Functions

Format: `THEME_preprocess_HOOK(&$variables)` in `THEME.theme`.

```php
function mytheme_preprocess_node(&$variables) {
  $node = $variables['node'];
  $variables['custom_field'] = $node->get('field_custom')->value;
}
```

Rules:
- Never render inside preprocess. Pass the value or render array; let Twig call `|render`.
- Use `$variables['elements']['#node']` not `$variables['node']` when the latter is missing.
- Check `$variables['view_mode']` to conditionally add variables.

---

## Hook System

Hooks are functions named `MODULENAME_HOOKNAME()`. In a theme, use the theme name as the prefix.

Common hooks:

| Hook | When to use |
|------|-------------|
| `hook_preprocess_HOOK()` | Pass data to Twig templates |
| `hook_form_alter()` | Modify any form before render |
| `hook_theme()` | Register custom theme hooks |
| `hook_theme_suggestions_HOOK_alter()` | Add template suggestions |
| `hook_node_presave()` | Modify a node before save |
| `hook_install()` | Run setup when a module installs |
| `hook_update_N()` | Run a one-time database/config update |

After adding or modifying hooks, always run `drush cr` — hooks are cached.

---

## Config Management

Drupal stores configuration as YAML. The workflow:

```bash
drush cex          # export current DB config to sync directory
git add config/    # commit the YAML
drush cim          # import YAML config into DB on another environment
```

Rules:
- Never hand-edit UUIDs in config YAML.
- Config split (`config_split` module) separates environment-specific config (dev vs prod).
- If `drush cim` fails with "config missing", the active config has items not in the sync
  directory — export first, resolve conflicts, then import.
- Field storage config (`field.storage.*`) must exist before field instance config
  (`field.field.*`). Import order matters.

---

## Render Arrays

A render array is a PHP associative array that describes what to render, not HTML itself.

```php
$build = [
  '#type' => 'container',
  '#attributes' => ['class' => ['my-wrapper']],
  'child' => [
    '#type' => 'html_tag',
    '#tag' => 'p',
    '#value' => t('Hello world'),
  ],
];
```

Key properties: `#type`, `#theme`, `#markup`, `#plain_text`, `#attributes`, `#attached`,
`#cache`, `#weight`.

`#attached` — use this to attach CSS/JS libraries, not inline styles:
```php
$build['#attached']['library'][] = 'mytheme/my-component';
```

---

## Cache

Drupal's cache system is tag-based. Understand this before debugging "stale content" issues.

- **Cache tags** — what data the render depends on (e.g., `node:42`, `node_list`)
- **Cache contexts** — what varies the cache (e.g., `url`, `user.roles`, `languages:language_interface`)
- **Cache max-age** — how long before expiration (`Cache::PERMANENT` or seconds)

```php
$build['#cache'] = [
  'tags' => ['node:' . $node->id()],
  'contexts' => ['user.roles'],
  'max-age' => Cache::PERMANENT,
];
```

When content updates but the page doesn't: check cache tags. When a block shows to the
wrong role: check cache contexts. Never set `max-age: 0` in production as a fix.

`drush cr` clears the render cache, but NOT external caches (Varnish, CDN). Use
`drush cache:rebuild` + purge the CDN when deploying.

---

## Drush Reference

```bash
drush cr                          # clear all caches
drush cex                         # export config to sync dir
drush cim                         # import config from sync dir
drush updb                        # run pending database updates
drush en MODULE                   # enable a module
drush pmu MODULE                  # uninstall a module
drush uli                         # generate a one-time login link
drush sql:query "SELECT ..."      # run a SQL query
drush pm:list --status=enabled    # list enabled modules
drush theme:list                  # list installed themes
drush php:eval "..."              # run arbitrary PHP
```

---

## Common Failure Modes

**White screen / WSOD** — PHP fatal error. Check `sites/default/files/php/twig/` for cached
templates that may be stale. Run `drush cr`. Check the Drupal logs (`drush watchdog:show`).

**Template not overriding** — wrong file name. Enable Twig debug (`twig.config.debug: true`
in `services.yml`) to see which templates are being used and what suggestions are available.

**Field not available in Twig** — field not added to display mode, or display mode is not
the one being rendered. Check Structure → Content Types → Manage Display.

**Config import fails** — dependency order issue, UUID mismatch, or the active config has
diverged. Export first (`drush cex`), diff the YAML, resolve, then import.

**Views result is empty** — check the filter criteria, check relationships, check permissions
("published" filter is on by default and affects anonymous users). Use the Views preview.

---

## Project Context

Check AGENTS.md or a local `skills/drupal.local.md` overlay for:
- Drupal version (9, 10, 11)
- Custom theme name and location
- Contrib modules in use
- Config sync directory path
- Deployment process and environment structure
- Known issues or site-specific patterns
