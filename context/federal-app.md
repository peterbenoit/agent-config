# CONTEXT — {Project Name}

{One to two sentences: what this federal web project does, which agency it serves, and what
the development work covers — new site, redesign, USWDS implementation, accessibility
remediation, API integration, etc.}

---

## Glossary

Terms with a specific meaning in this project. Skip general programming terms — only the
ones that would confuse or mislead an outside reader belong here.

**ATO (Authority to Operate)** — The formal security authorization required before a federal
system can operate in a production environment. Issued by the agency's Authorizing Official (AO).
Changes that expand attack surface may require re-authorization or formal deviation approval.

**VPAT (Voluntary Product Accessibility Template)** — The document used to communicate Section
508 conformance to federal buyers and agency stakeholders. The 508 skill handles VPAT preparation.

**FedRAMP** — Federal Risk and Authorization Management Program. Cloud services used by federal
agencies must be FedRAMP authorized at the appropriate impact level (Low, Moderate, High).
Confirm the authorization level of any new cloud dependency before using it in production.

**COR (Contracting Officer's Representative)** — The agency point of contact responsible for
overseeing contractor performance. Technical decisions that affect scope, cost, or schedule
should be raised with the COR before proceeding.

<!-- Add project-specific terms below: -->

**{Term}** — {Definition. Include which table, file, or component owns it if relevant.}

---

## Key Relationships

Non-obvious connections between parts of the system.

<!-- Example entries — replace with your own: -->

- Authentication is managed by `<!-- IAM provider / PIV/CAC / login.gov / agency SSO -->`.
  Do not implement custom auth. Route protection reads from `<!-- auth context / session -->`.

- Environment configuration lives in `<!-- .env / secrets manager / vault -->`.
  Never read agency credentials from the filesystem directly — always through the approved
  secrets mechanism.

- The CMS (if applicable) is `<!-- platform -->`. Content editors access it at `<!-- URL -->`.
  The build pipeline fetches content at `<!-- build time / runtime -->` from `<!-- API / webhook -->`.
  Content changes do not require a code deployment unless the schema changes.

---

## Decisions

Choices that were made deliberately and should not be quietly reversed.

<!-- Example entries — replace with your own: -->

**Accessibility-first rendering** — Pages are server-rendered or statically generated so
assistive technology receives complete content without waiting for JavaScript. Do not move
content delivery into client-side JS without assessing the accessibility impact first.

**No third-party analytics without approval** — Adding client-side scripts from third-party
vendors requires agency review for Privacy Act and PIA (Privacy Impact Assessment) compliance.
Confirm with the COR before adding any new external script.

**USWDS as the baseline** — All UI components derive from USWDS unless a specific deviation
is documented below. Overriding USWDS component behavior requires confirming the override does
not break keyboard navigation or screen reader compatibility.

<!-- Deviations from USWDS defaults: -->

---

## Deployment and Release Process

- Deployment targets: `<!-- staging / production URLs or environments -->`
- Deployment process: `<!-- CI/CD pipeline, manual steps, required approvals -->`
- Change freeze periods: `<!-- dates or link to agency calendar -->`
- Rollback procedure: `<!-- describe or link -->`
- Who approves production deployments: `<!-- COR / tech lead / automated -->`

---

## Testing Requirements

- Accessibility: `<!-- axe-core in CI / manual JAWS + NVDA + VoiceOver -->`
- Security scanning: `<!-- OWASP ZAP / Fortify / agency-mandated tool -->`
- Browsers: `<!-- agency-required browser/OS matrix -->`
- Assistive technology: `<!-- required AT + browser combinations for acceptance -->`

Run `npm audit` (or equivalent) before every deployment. No high or critical unresolved
vulnerabilities may ship without documented risk acceptance from the agency.
