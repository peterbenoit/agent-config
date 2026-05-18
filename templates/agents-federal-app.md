# Project Name

<!-- One paragraph: what this federal web project does, which agency it serves, and what the
     development work covers (new site, redesign, USWDS implementation, accessibility remediation,
     API integration, etc.) -->

Federal web project serving <!-- Agency Name -->. Built with <!-- USWDS / custom / CMS -->.
Deployed on <!-- cloud.gov / AWS GovCloud / Azure Government / agency infrastructure -->.

## Skills

Agent skills are in `./skills/`. Each subfolder contains a SKILL.md with the role definition,
methodology, and trigger phrases for that specialist. Read the relevant skill before starting
any matching task — don't rely on memory for things the skill defines.

**Recommended for federal projects:** `508`, `security`, `qa`, `performance`, `content-strategy`

For this project, the most relevant skills are: `508`, `qa`, `security`, `performance`.
To add project-specific context, create a local overlay: `./skills/<name>.local.md`.
Do not edit `SKILL.md` directly — it will be overwritten on updates.

## Context

Read `CONTEXT.md` before starting any task. It defines agency-specific terms, system
relationships, and decisions that should not be silently reversed.
AGENTS.md drives behavior; CONTEXT.md informs language.

## Build & Dev

```sh
# Add your build commands here
npm run start    # local dev server
npm run build    # production build
npm run test     # run tests
```

<!-- Add: any agency-specific build steps, proxy configuration, CAC/PIV requirements for local dev -->

## Environment Variables

```
# Add required env vars here
# Never commit credentials — federal projects often have agency-specific secrets management
```

Agency secrets management: `<!-- AWS Secrets Manager / HashiCorp Vault / agency-managed -->`

## Architecture

<!-- Describe the system: what it does, what calls what, where source-of-truth lives.
     Include: CMS if applicable, API integrations, authentication system, hosting environment -->

## Accessibility Requirements

This is a federal project subject to Section 508 of the Rehabilitation Act (29 U.S.C. § 794d).
WCAG 2.1 AA is the minimum standard. Target WCAG 2.2 AA where feasible.

- Accessibility testing: `<!-- axe / NVDA / JAWS / VoiceOver — specify tools and process -->`
- VPAT required: `<!-- Yes / No / In progress — and where it lives if yes -->`
- Remediation priority: blockers (can't complete task) before high-impact before moderate

Never ship a change that introduces a new accessibility blocker, even temporarily. Flag
accessibility regressions immediately — they are legal liabilities, not nice-to-haves.

## USWDS

<!-- Remove this section if not using USWDS -->

Using USWDS `<!-- version -->`. Configuration:
- Theme settings: `<!-- _uswds-theme.scss or equivalent -->`
- Custom components: `<!-- directory -->`
- Permitted overrides: `<!-- anything that deviates from USWDS defaults -->`

Do not override USWDS component behavior without checking whether the override breaks
keyboard navigation or screen reader compatibility.

## Security Requirements

<!-- Federal projects often have specific security requirements beyond OWASP baseline -->

- FedRAMP authorization: `<!-- Yes — authorized at [Low/Moderate/High] / Not required -->`
- Agency ATO (Authority to Operate): `<!-- In place / Pending / Not required -->`
- Scanning: `<!-- OWASP ZAP / Fortify / agency-mandated scanner -->`
- <!-- Example guardrail (replace with agency-specific requirement): Dependency scanning: run `npm audit` before every deployment; no high/critical unresolved -->

## Agency Constraints

<!-- Document anything specific to this agency engagement:
     - COR or contracting officer expectations
     - Required review/approval process before deployment
     - Specific browsers or assistive technology combinations that must be tested
     - Data handling requirements (PII, FISMA, Privacy Act)
     - Change freeze periods or deployment windows -->

## What Not to Do

- Never disable accessibility features to meet a deadline — flag the conflict instead
- Never deploy without running the accessibility scan and resolving blockers
- Never commit credentials, PII, or agency-internal data to the repository
- Never bypass the agency's required review process, even for hotfixes
- `<!-- Add project-specific guardrails here -->`
