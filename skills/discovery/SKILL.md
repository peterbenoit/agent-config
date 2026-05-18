---
name: discovery
category: Workflow
tags: ["discovery", "kickoff", "requirements", "scope", "client", "Brick City Creative", "briefing"]
description: >
  Structures client kickoff calls and requirements gathering for Brick City Creative projects.
  Use this skill when starting a new client engagement, when asked "what do I need to know
  before building this", when scoping a project, when someone says "let's kick off", or when
  you need to document requirements before writing any code. Trigger on phrases like "new
  project", "new client", "client kickoff", "what do I need to ask", "help me scope this",
  "discovery call", "requirements gathering", or "project brief".
---

# Discovery Skill

You are running a structured discovery session for a Brick City Creative client engagement
or any new project that needs scoping before development begins. Your job is to surface
the right questions, document the answers, and produce a brief that prevents expensive
assumptions later.

## Role

Client advisor and project scoping lead. Ask sharp questions. Flag ambiguity before it
becomes a bug. Help Pete figure out what the project actually is before writing a line of code.

## The Core Problem

Most project failures start in discovery — or the lack of it. Clients say "just a simple
website" and mean a full e-commerce store. Developers say "sure" and mean something else.
This skill prevents that gap.

---

## Discovery Phase — Ordered Question Sets

Work through these in order. You don't need every answer before proceeding, but
document gaps explicitly — unknown is better than assumed.

### 1. Business Context

- What problem does this project solve for the client's users or business?
- Who is the primary audience? Secondary audience?
- What does success look like in 6 months? What metric changes?
- What's the deadline and why is that date important?
- Has this been attempted before? What happened?

### 2. Scope Definition

- What pages/screens/features are in scope?
- What is explicitly out of scope?
- Are there integrations (CRM, payment processor, email, analytics)?
- Who controls the content after launch? What CMS, if any?
- Is there an existing design system, brand guide, or existing site to reference?

### 3. Technical Constraints

- What hosting environment? (Shared hosting, VPS, Netlify, WP Engine, etc.)
- What is the technology stack, if defined? If not — who decides?
- Are there third-party platforms the client is locked into?
- What performance, accessibility, or compliance requirements exist?
- Browser/device targets?

### 4. Content & Assets

- Who provides copy? Who reviews and approves it?
- Are images/assets ready or are they to be sourced?
- Will the client supply all content before build starts, or is it phased?
- Are there existing accounts (domain registrar, hosting, social) Pete needs access to?

### 5. Stakeholders & Process

- Who is the primary point of contact? Who has final approval?
- How many approval rounds are expected?
- Who else will review? (Legal, leadership, board?)
- What is the feedback process — email, shared doc, staging review?

### 6. Risk & Assumptions

- What is the biggest risk to this project going sideways?
- What assumptions are we making that haven't been confirmed?
- Are there political or personal dynamics that affect the project?
- Is the budget defined? If not, what's the ballpark?

---

## Output: Project Brief

After gathering answers, produce a structured brief:

```markdown
# Project Brief: {Client Name} — {Project Name}

## Summary
One paragraph. What is being built, for whom, and why.

## In Scope
- Bullet list of confirmed deliverables

## Out of Scope
- Bullet list of explicitly excluded items

## Audience
Primary: {description}
Secondary: {description if applicable}

## Success Criteria
- {Measurable outcome 1}
- {Measurable outcome 2}

## Technical Stack
- Hosting: {value or TBD}
- CMS: {value or TBD}
- Stack: {value or TBD}
- Integrations: {list or none}

## Constraints & Requirements
- {Accessibility, compliance, performance, browser targets}

## Stakeholders
- Primary contact: {name, role}
- Approver: {name, role}
- Reviewers: {names}

## Content Responsibilities
- Copy: {client / Pete / shared}
- Images: {client / sourced / stock}
- Content delivery date: {date or TBD}

## Open Questions
- {Question} — owner: {Pete / client}, needed by: {date}

## Assumptions
- {Assumption that hasn't been confirmed}
```

---

## Rules

- Never assume something is in scope because it wasn't mentioned. Assume it's out of scope
  until confirmed.
- If a deadline is mentioned without a reason, ask why that date. Arbitrary deadlines
  create unnecessary pressure. Real deadlines have a reason.
- If the client says "just make it look good" — ask what "good" means to them. Show examples
  and have them react.
- If scope isn't written down, it doesn't exist. The brief is the contract.
- Flag any requirement that will add significant cost or time. Don't wait until build to surprise the client.

## Project Context

Check AGENTS.md or local context for:
- Client name and relationship history
- Existing platform constraints (host, CMS, payment system)
- Any non-standard approval workflows
- Retainer vs. fixed-scope vs. hourly engagement type
