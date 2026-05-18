# CONTEXT — {Project Name} (VA.gov)

{One to two sentences: what this VA.gov property does, which office or program it supports,
and what the development work covers — new feature, content migration, accessibility remediation,
analytics instrumentation, or design system implementation.}

---

## Glossary

Terms with specific meaning in the VA.gov ecosystem. Many of these are VA-specific acronyms
or terms that differ from their general usage.

**VADS (VA Design System)** — The VA's component library and design system, built on top of
USWDS. Components, tokens, and patterns live at design.va.gov. When building VA.gov UI, use
VADS components before reaching for USWDS primitives directly. Do not build custom UI that
duplicates an existing VADS component.

**USWDS (U.S. Web Design System)** — The federal design system that VADS extends. Provides
base tokens, typography, spacing, and components. VADS overrides or extends many of these.
Always prefer VADS over raw USWDS when working on VA.gov properties.

**508** — Section 508 of the Rehabilitation Act. Requires federal electronic content to be
accessible to people with disabilities. At VA, 508 compliance is enforced more strictly than
the minimum WCAG 2.1 AA baseline. The 508 skill covers remediation methodology.

**WCAG** — Web Content Accessibility Guidelines. The technical standard underlying 508.
VA targets WCAG 2.1 AA at minimum. Do not mark something compliant unless it passes
keyboard, screen reader, color contrast, and cognitive load checks.

**Veteran** — The primary user. Capitalize in all copy. Do not refer to Veterans as
"users", "patients" (unless in a clinical context), or "customers". The preferred term
is Veteran or Veterans (no apostrophe for possessive in headers: "Veterans Benefits",
not "Veteran's Benefits").

**VAMC (VA Medical Center)** — A VA hospital facility. VAMC pages on VA.gov are generated
from the Drupal CMS and follow a strict template. Do not create one-off VAMC pages.

**VSO (Veterans Service Organization)** — Nonprofits that assist Veterans with claims and
benefits (e.g., DAV, VFW, American Legion). Not the same as VA staff. VSOs have their own
accreditation process and access levels.

**MHV (My HealtheVet)** — VA's patient health portal. Being migrated into VA.gov as part
of the MHV on VA.gov initiative. Distinct from MPI (Master Person Index) and MFA flows.

**VBA (Veterans Benefits Administration)** — The VA business line handling disability
compensation, education, and home loan benefits. Distinct from VHA (healthcare) and NCA
(cemeteries).

**VHA (Veterans Health Administration)** — The VA business line running the hospital and
clinic system. Governs VAMC pages and most health-related content on VA.gov.

**vets-website** — The front-end application repo for VA.gov. React-based. Lives at
github.com/department-of-veterans-affairs/vets-website.

**content-build** — The static site generator that pulls content from the Drupal CMS and
builds the static pages on VA.gov. Lives at
github.com/department-of-veterans-affairs/content-build.

**Drupal CMS** — The content management system behind VA.gov. Editors manage structured
content here. content-build pulls from it. The CMS is not vets-website — they are separate
repos with separate deployments.

**Flipper / Feature flags** — VA.gov uses Flipper for feature flag management. Features
gated by Flipper can be toggled per-user, per-team, or globally. Do not ship code that
changes user-facing behavior without a feature flag during development.

**GA4 (Google Analytics 4)** — VA.gov's analytics platform. Events are tracked via GTM
(Google Tag Manager). Do not instrument raw GA4 calls directly — use the established
data layer pattern and GTM triggers. Event naming follows VA's event taxonomy.

**GTM (Google Tag Manager)** — The tag management layer over GA4 on VA.gov. Custom events
are pushed to `window.dataLayer`. GTM picks them up and maps them to GA4 events. Changes
to GTM require approval from the platform analytics team.

**PII (Personally Identifiable Information)** — Never log, track, or transmit PII.
On VA.gov this includes: name, SSN, date of birth, address, phone, email, and any health
or benefits data. GA4 and GTM must never receive PII — scrub it before pushing to dataLayer.

<!-- Add project-specific terms below: -->

**{Term}** — {Definition.}

---

## Key Relationships

- VA.gov front-end is split across `vets-website` (React app) and `content-build`
  (Drupal-sourced static pages). Know which one owns the page you are working on before
  starting. A VAMC page is content-build. A form application (526, 1010, etc.) is
  vets-website.

- Analytics events flow: code pushes to `window.dataLayer` → GTM picks up and fires → GA4
  receives. Never call `gtag()` directly. Never send PII in any dataLayer push. Confirm
  the event name matches VA's existing event taxonomy before adding a new one.

- Accessibility reviews are required before production. The VA's 508 Office reviews
  at-risk components. Platform teams (OCTO) may require a Collaboration Cycle review
  for significant UI changes.

- `<!-- CMS, hosting, and environment details specific to this project go here. -->`

---

## Decisions

**VADS components first** — Do not build custom UI that duplicates a VADS component.
If a VADS component almost fits but not quite, open a VADS issue or use the existing
component with an allowed override before building from scratch.

**No PII in analytics** — This is non-negotiable and has legal consequences. Every
dataLayer push must be reviewed for PII before merge. Form field values, query parameters
that may contain names or SSNs, and URL paths that include claim IDs must be scrubbed.

**Veteran-centric language** — Follow the VA content style guide. Plain language,
second person ("you"), and active voice. Avoid jargon and acronyms in body copy unless
they have been introduced and defined. Veterans in headers are not possessive.

**Collaboration Cycle** — Significant new features on VA.gov go through OCTO's
Collaboration Cycle: Design Intent → Midpoint Review → Staging Review → Privacy &
Security Review. Do not skip stages — they catch accessibility, security, and design
issues before production.

<!-- Project-specific decisions: -->

---

## Deployment and Release Process

- VA.gov deployments happen on a scheduled cadence (typically daily at `<!-- time -->`).
  Merging to main does not deploy immediately.
- Feature flags (Flipper) must be off before merging if the feature is not ready for
  all users.
- Staging environment: `staging.va.gov` (requires VA network or SOCKS proxy access)
- `<!-- Team-specific deployment notes, PR review requirements, or approval chain -->`
