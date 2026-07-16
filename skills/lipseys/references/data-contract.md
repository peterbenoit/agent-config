# Observed Data Contract

Use this format when turning authenticated documentation or sanitized Lipsey's responses into
project-owned reference material.

## Operation Record

For each operation, document:

```text
Operation:
Purpose:
Official source:
Observed on:
Account/entitlement assumptions:
Freshness class: documentation | catalog snapshot | live operational state
Authentication location:
Request parameters:
Pagination/filtering:
Success responses:
Empty response:
Error responses:
Rate-limit evidence:
```

Do not include credential values, dealer prices, customer data, live order identifiers, or other
sensitive values in a universal reference.

## Field Record

For every field that drives downstream behavior, capture:

| Attribute | Record |
|---|---|
| Path | Exact JSON or document path |
| Type | Observed type or documented union |
| Presence | Required, optional, nullable, or conditionally omitted |
| Meaning | Business meaning from an authoritative source |
| Identifier role | Distributor ID, SKU, UPC, MPN, order reference, or other |
| Units | Currency, minor/major unit, weight, dimension, quantity, timestamp zone |
| Freshness | Stable metadata, snapshot, or live state |
| Sensitive | Whether it must be redacted from fixtures and logs |
| Evidence | Documentation section or sanitized fixture name |

## Required Fixtures

Capture the smallest sanitized set that covers materially different behavior:

- Successful populated result
- Successful empty result
- Optional or nullable fields omitted
- Pagination boundary
- Authentication or authorization failure
- Validation failure for writes
- Rate-limit or transient failure if safely reproducible
- Each availability or order state that changes downstream behavior

One successful payload is not a complete schema. Keep unknown fields unknown until documented or
observed.

## Contract Tests

Prioritize tests that protect:

- Identifier stability and collision handling
- Numeric precision, units, and timestamp parsing
- Missing versus zero versus false
- Availability and allocation semantics
- Pagination completion
- Idempotent writes and duplicate detection
- Redaction of secrets and sensitive account/order data
