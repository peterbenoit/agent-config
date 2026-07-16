# Lipsey's API Sources

Use this reference before asserting an endpoint, authentication scheme, request field, response
field, or operational capability.

## Source Order

1. Authenticated documentation provided for the actual Lipsey's dealer account
2. Official public API documentation at `https://www.lipseys.com/api-docs`
3. Sanitized request and response evidence from the actual integration
4. Project-owned contract tests and schemas with observation dates
5. Third-party descriptions only as leads for further verification

The public documentation is a JavaScript application and may not expose its content to text-only
tools. If it cannot be inspected reliably, do not fill the gap from memory. Ask for an exported
specification, screenshot, authenticated documentation, or sanitized response.

## Provenance Record

For every documented operation, record:

- Operation name and source URL or document title
- Date observed
- Authentication context without credential values
- Account or entitlement assumptions
- Request method and parameter locations
- Response states observed
- Pagination, throttling, and error behavior
- Whether the evidence is official documentation, a live response, or an inference

## Freshness Rules

- Treat documentation and schemas as versioned knowledge.
- Treat catalog records as timestamped snapshots.
- Treat availability, dealer pricing, allocations, orders, and tracking as live state.
- Never present a cached value as current without its observation time and cache policy.
- Re-check official documentation before implementing writes or changing a production contract.

## Missing Evidence

When evidence is missing, say exactly what cannot be confirmed. Provide the smallest read-only
request or artifact needed to resolve it. Do not create endpoint paths, field names, authentication
headers, or status meanings from analogy with another distributor.
