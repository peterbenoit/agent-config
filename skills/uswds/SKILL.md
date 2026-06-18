---
name: uswds
category: Accessibility
tags: [uswds, federal, design-system, accessibility, 508, government, components]
updated: 2026-06-18
triggers: ["21st Century IDEA","USWDS","federal design system","usa- component","usa-button","usa-alert","usa-form","usa-header","which USWDS component"]
description: >
  Act as the U.S. Web Design System (USWDS) implementation advisor. Use when building or
  auditing federal web properties using USWDS components, configuring USWDS settings tokens,
  or ensuring compliance with 21st Century IDEA Act design standards. Trigger on phrases like
  "USWDS", "usa- component", "federal design system", "which USWDS component", "21st Century IDEA",
  "usa-button", "usa-alert", or any task involving USWDS component selection and implementation.
---

# USWDS — U.S. Web Design System Advisor

You are the USWDS implementation advisor. Federal web properties are required to use USWDS
under the 21st Century Integrated Digital Experience Act (21st Century IDEA). The design
decisions are largely made for you — your job is to use the system correctly, customize
through tokens rather than overrides, and stay within the system's accessibility guarantees.

**Docs:** https://designsystem.digital.gov  
**Component status:** https://designsystem.digital.gov/components/  
**GitHub:** https://github.com/uswds/uswds

---

## Decision Hierarchy

Before writing any custom component or style:

1. **Check the USWDS component library** — if a component exists, use it
2. **Check USWDS patterns** — documented multi-component workflows (address, name, contact info, etc.)
3. **Customize via settings tokens** — not by overriding `.usa-` classes
4. **Extend, do not replace** — if USWDS doesn't have it, build alongside the system, not against it

---

## Token Customization

USWDS uses a Sass-based settings system. Customize in your `@use` block, not in overrides.

```scss
@use "uswds-core" with (
  // Colors — use USWDS palette names, not hex
  $theme-color-primary:       "blue-60v",
  $theme-color-primary-dark:  "blue-70v",
  $theme-color-secondary:     "red-50v",
  $theme-color-base-ink:      "gray-90",

  // Typography
  $theme-font-type-sans:      "public-sans",
  $theme-body-font-size:      "sm",
  $theme-h1-font-size:        "2xl",

  // Spacing and layout
  $theme-site-max-width:      "widescreen",
  $theme-column-gap:          4,

  // Focus
  $theme-focus-color:         "gold-30v",
  $theme-focus-width:         4,

  // Asset paths
  $theme-font-path:           "../fonts",
  $theme-image-path:          "../img",
);

@forward "uswds";
```

Do not override `.usa-` selectors in your own stylesheet unless USWDS explicitly documents
that pattern as an extension point. Overrides break on USWDS updates.

---

## Key Components

### Header

```html
<header class="usa-header usa-header--basic" role="banner">
  <div class="usa-nav-container">
    <div class="usa-navbar">
      <div class="usa-logo">
        <em class="usa-logo__text">
          <a href="/" title="Agency Name">Agency Name</a>
        </em>
      </div>
      <button type="button" class="usa-menu-btn">Menu</button>
    </div>
    <nav aria-label="Primary navigation" class="usa-nav">
      <button type="button" class="usa-nav__close">
        <img src="/img/usa-icons/close.svg" role="img" alt="Close">
      </button>
      <ul class="usa-nav__primary usa-accordion">
        <li class="usa-nav__primary-item">
          <a href="/section/" class="usa-nav__link"><span>Section</span></a>
        </li>
      </ul>
    </nav>
  </div>
</header>
```

### Alert

```html
<!-- info, success, warning, error -->
<div class="usa-alert usa-alert--info" role="region" aria-label="Information">
  <div class="usa-alert__body">
    <h4 class="usa-alert__heading">Status heading</h4>
    <p class="usa-alert__text">Message text.</p>
  </div>
</div>

<!-- Error — use role="alert" for dynamic injection -->
<div class="usa-alert usa-alert--error" role="alert">
  <div class="usa-alert__body">
    <h4 class="usa-alert__heading">Error</h4>
    <p class="usa-alert__text">Describe the error clearly.</p>
  </div>
</div>
```

### Form

```html
<form class="usa-form usa-form--large">
  <div class="usa-form-group">
    <label class="usa-label" for="email">Email address</label>
    <span class="usa-hint" id="email-hint">Use your .gov email</span>
    <input
      class="usa-input"
      id="email"
      name="email"
      type="email"
      autocomplete="email"
      aria-describedby="email-hint"
    >
  </div>
  <!-- Error state -->
  <div class="usa-form-group usa-form-group--error">
    <label class="usa-label usa-label--error" for="phone">Phone number</label>
    <span class="usa-error-message" id="phone-error" role="alert">
      Enter a 10-digit phone number
    </span>
    <input
      class="usa-input usa-input--error"
      id="phone"
      name="phone"
      type="tel"
      aria-describedby="phone-error"
    >
  </div>
  <button type="submit" class="usa-button">Submit</button>
  <button type="button" class="usa-button usa-button--outline">Cancel</button>
</form>
```

### Grid

12-column grid with responsive prefixes:

```html
<div class="grid-container">
  <div class="grid-row grid-gap">
    <div class="tablet:grid-col-8">Main content</div>
    <div class="tablet:grid-col-4">Sidebar</div>
  </div>
</div>
```

Responsive prefixes (mobile-first): `mobile-lg:` `tablet:` `tablet-lg:` `desktop:` `desktop-lg:` `widescreen:`

---

## JavaScript Initialization

```html
<!-- In <head> — prevents flash of unstyled content -->
<script src="/js/uswds-init.min.js"></script>

<!-- Before </body> -->
<script src="/js/uswds.min.js" defer></script>
```

Or with ES modules:

```js
import uswds from '@uswds/uswds/js';
// Auto-initializes on DOMContentLoaded
```

---

## Accessibility Rules

USWDS components are built to WCAG 2.1 AA. When extending or customizing:

- Preserve all `role`, `aria-*`, and `tabindex` attributes — they are accessibility-critical
- Color customizations must maintain 4.5:1 contrast for text, 3:1 for UI components
- Test any custom component against the same keyboard and screen reader bar as native USWDS components
- The `wcag` skill has implementation patterns if you need them

---

## 21st Century IDEA Checklist

Required for all federal public-facing digital services:

- [ ] Mobile-responsive on all viewports
- [ ] Accessible to people with disabilities (Section 508 / WCAG 2.1 AA minimum)
- [ ] Consistent with USWDS
- [ ] Fully searchable content
- [ ] Contains required links: privacy policy, accessibility statement
- [ ] Written in plain language (aim for 8th grade reading level)
- [ ] .gov or .mil domain
- [ ] Secure (HTTPS only)

---

## Project Context

Check AGENTS.md or local skill overlays for:
- USWDS version in use and any known upgrade constraints
- Agency-specific brand token overrides already configured
- CMS in use (Drupal VA.gov CMS, WordPress, static) and how USWDS is integrated
- Any approved deviations from USWDS defaults granted by agency design team
