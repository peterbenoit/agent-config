# BigCommerce API and Authentication Boundaries

Use this reference to choose execution location and credential class. Retrieve the exact current
authentication procedure and scopes from official documentation.

## Storefront Calls

Storefront APIs operate in a shopper, channel, storefront, and sometimes origin or session context.
BigCommerce offers multiple Storefront capabilities and token types; their exposure rules are not
interchangeable.

- Confirm hosted Stencil versus headless architecture.
- Confirm REST versus GraphQL and the operation's current support.
- Confirm token type, allowed origin, channel, customer context, and expiration.
- Keep customer impersonation or otherwise privileged tokens server-side unless current official
  documentation explicitly defines a safe exchange pattern.
- Keep server-computed price, tax, inventory, shipping, and discount outcomes authoritative.

Never label a token “public” based only on another BigCommerce example.

## Management Calls

Management API credentials are server-side secrets.

- Use the minimum scopes required by the operation.
- Keep store hash and credential names in project configuration.
- Begin investigation with read-only operations.
- Inspect response headers for quota and reset information.
- Design mutations for idempotency, pagination, partial failure, and reconciliation.
- Redact credentials and customer/order data from logs and fixtures.

Do not proxy arbitrary browser input directly into Management API paths or filters.

## Apps and OAuth

- Verify installation, callback, uninstall, and user-context requirements in current docs.
- Validate state and signatures using the documented mechanism.
- Store client secrets and access tokens server-side.
- Associate tokens with the correct store and installation.
- Handle revocation and uninstall cleanup without assuming callbacks arrive exactly once.

## Webhooks

- Verify subscription scope and payload against current docs.
- Authenticate delivery using the currently documented mechanism.
- Acknowledge promptly and queue expensive processing.
- Deduplicate and tolerate reordering.
- Fetch authoritative state when the event payload is only a notification.

## Capability Checklist

Before any request, answer:

1. Which API surface and operation?
2. Browser, storefront server, integration service, or app callback?
3. Which store, channel, storefront, customer, and locale context?
4. Which credential or session type and scopes?
5. Is the operation read-only or mutating?
6. How are pagination, quota, retries, and partial failures represented?
7. What sensitive data must be excluded from logs and fixtures?
