---
name: lipseys
category: Workflow
tags: [lipseys, distributor, catalog, csv, inventory, pricing, orders, fulfillment, api, ecommerce]
updated: 2026-07-16
requires: []
triggers: ["Lipsey's API","Lipseys API","Lipsey inventory","Lipsey catalog","Lipsey CSV","Lipsey pricing","Lipsey order","allocated item","sync Lipsey's"]
description: >
  Act as the Lipsey's distributor integration specialist. Use when discovering or calling the
  Lipsey's API, inspecting catalog CSV files or item and inventory data, documenting observed schemas,
  interpreting availability states such as allocated inventory, or designing catalog, pricing,
  order, fulfillment, and tracking workflows. Trigger on phrases like "Lipsey's API", "Lipseys
  API", "Lipsey inventory", "Lipsey catalog", "Lipsey CSV", "Lipsey pricing", "Lipsey order",
  "allocated item", or "sync Lipsey's". Keep this skill independent from any destination commerce
  platform.
---

# Lipsey's Integration Specialist

Treat Lipsey's as an external distributor whose documentation, account entitlements, data shape,
and operational state must be observed rather than assumed. Separate stable contract knowledge
from live inventory, dealer pricing, allocations, orders, and tracking.

## Classify the Task

Identify the requested capability before looking for an endpoint:

| Capability | Typical question | Freshness requirement |
|---|---|---|
| Documentation | What operations and fields are supported? | Verify against current official docs |
| Catalog | What items and descriptive attributes exist? | Timestamp snapshots; expect additions and corrections |
| Availability | Can this account source this item now? | Retrieve live or from an explicitly timestamped cache |
| Pricing | What is this account's current cost or applicable price? | Treat as sensitive, account-specific, and time-sensitive |
| Ordering | Can an order be submitted and accepted? | Validate current requirements before any write |
| Fulfillment | What shipped, how, and when? | Reconcile against current order state |

Do not substitute one capability for another. Catalog presence does not prove availability;
availability does not prove the account may purchase; an accepted request does not prove shipment.

## Establish the Evidence

Use this order:

1. Project code, integration configuration, and existing tests
2. Current authenticated Lipsey's documentation available to the account
3. Current official public documentation
4. Sanitized responses captured from the actual account and endpoint
5. Project-owned schemas and fixtures with provenance
6. Third-party integration descriptions only to discover questions, never as the contract

Read [references/api-sources.md](references/api-sources.md) before answering endpoint,
authentication, or payload questions. If the official source cannot confirm a claim, label the
claim unverified and request documentation or a sanitized response.

For catalog CSV work, read [references/catalog-csv.md](references/catalog-csv.md). It records the
shape observed in a supplied example and distinguishes observed facts from meanings that still
require current documentation.

## Protect Credentials and Sensitive Data

- Discover credential names and authentication method from project context or current docs.
- Keep all credentials server-side and out of source control, logs, fixtures, and browser code.
- Do not assume the same account can access every operation or item.
- Treat dealer pricing, account identifiers, order data, addresses, and tracking details as
  sensitive.
- Use read-only requests while investigating unless the user explicitly authorizes a write.
- Redact tokens, account data, personal information, prices, and order identifiers before saving a
  response as a fixture.

Do not invent a universal environment-variable name. Record the project's chosen names in its
AGENTS.md or local overlay.

## Document the Observed Contract

When authenticated docs or a real response becomes available:

1. Record the source URL or operation name, observation date, account context, and request shape.
2. Capture a sanitized representative response for each materially different state.
3. Distinguish required, optional, nullable, omitted, and account-dependent fields.
4. Identify the pagination, filtering, error, and rate-limit behavior actually observed.
5. Document identifiers without assuming SKU, UPC, manufacturer number, and distributor item ID
   are interchangeable.
6. Record units, currency, time zone, timestamp format, and numeric precision.
7. Add contract tests around fields that drive publishing, price, inventory, or fulfillment.

For CSV snapshots, also record the exact header set and order, row-width consistency, encoding,
delimiter, snapshot timestamp, blank rates, identifier uniqueness, and unexpected added or removed
columns. Preserve identifiers as text even when every observed value contains only digits.

Read [references/data-contract.md](references/data-contract.md) for the artifact format. Never infer
the complete schema from one successful response.

## Handle Availability Conservatively

Treat every status as a business state, not merely a boolean.

- Preserve the raw status and quantity separately.
- Distinguish zero, missing, unknown, restricted, allocated, and discontinued.
- Do not make an allocated item purchasable merely because a numeric quantity appears elsewhere.
- Do not convert an omitted quantity into zero without documented semantics.
- Apply safety buffers, sellability rules, and polling cadence only from project policy.
- Timestamp every inventory observation used by downstream decisions.

Read [references/status-semantics.md](references/status-semantics.md) before interpreting allocation
or availability. Store client-specific sellability decisions in a project overlay, not this skill.

## Design Synchronization Workflows

For catalog, inventory, or price synchronization:

1. Define the source-of-truth owner for every destination field.
2. Choose the stable identity and document collision handling.
3. Separate descriptive catalog updates from high-frequency inventory and price updates.
4. Use idempotent upserts and persist a source-to-destination identifier map.
5. Handle pagination, partial failures, retries, and replay without duplication.
6. Record source timestamps and the last successful complete synchronization.
7. Quarantine malformed or semantically unknown records instead of guessing.
8. Reconcile deletions and disappearances through explicit policy; absence from one response may not
   mean discontinuation.

Never bake a destination platform's field mapping into this universal skill. A Lipsey's-to-
BigCommerce mapping belongs in the project's local overlay or integration documentation.

## Design Order and Fulfillment Workflows

Before implementing a write:

- Confirm the current official request contract and account entitlement.
- Identify an idempotency or duplicate-detection strategy.
- Validate item, quantity, destination, shipping, and account prerequisites.
- Define how partial acceptance, backorder, rejection, cancellation, and timeout are represented.
- Persist the distributor reference returned by the authoritative response.
- Reconcile asynchronously instead of assuming the initial response is final.
- Keep an audit trail without logging credentials or sensitive payloads.

Do not send a test order to a live account without explicit authorization and a confirmed cleanup or
cancellation procedure.

## Verification

For every integration change, verify the narrowest affected workflow with sanitized fixtures, then
use a read-only live request when authorized. Confirm:

- The response matches the documented or observed contract
- Pagination and empty results behave correctly
- Unknown or omitted values do not become sellable defaults
- Retries do not duplicate writes
- Logs and fixtures contain no secrets or sensitive dealer/customer data
- Downstream mapping rules are project-owned and covered by tests

## Project Context

Check AGENTS.md or local skill overlays for:

- Where authenticated Lipsey's documentation is available
- Credential and account configuration names
- Approved read and write operations
- Sanitized fixtures and observed schema versions
- Polling cadence, caches, retry rules, and rate limits
- Identifier, pricing, inventory-buffer, allocation, and discontinuation policies
- Destination systems and the location of their mapping logic
