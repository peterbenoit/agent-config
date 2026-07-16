# BigCommerce Verification Checklist

Apply the sections relevant to the task. Do not claim a workflow is verified from static code
inspection alone when it can be exercised safely.

## Source and Scope

- [ ] Platform surface and store/channel scope identified
- [ ] Current official documentation retrieved for volatile behavior
- [ ] Repository version and local project conventions inspected
- [ ] Changelog and deprecations checked when adopting or replacing a capability
- [ ] Store-specific claims verified against authorized evidence

## Credentials and Security

- [ ] Credential/token type and execution location are correct
- [ ] Minimum required scopes used
- [ ] No privileged credential is delivered to browser code
- [ ] Logs, errors, screenshots, and fixtures contain no secrets or sensitive customer/order data
- [ ] User-controlled input is validated before reaching privileged APIs

## Stencil

- [ ] Supported repository runtime and Stencil CLI confirmed from current sources
- [ ] Existing template, partial, context, and component patterns reused
- [ ] Custom template resides in the correct page-type directory and maps to a real URL locally
- [ ] Page Builder/schema changes render correctly with incomplete and existing configuration
- [ ] Target page verified at representative viewports with keyboard and console checks
- [ ] Project lint/build/bundle checks pass
- [ ] Upload, assignment, and activation scope kept distinct

## API and Integration

- [ ] Exact current operation and schema confirmed
- [ ] Empty, permission, validation, transient, and partial-failure responses handled
- [ ] Endpoint-specific pagination completes without duplicate or missing records
- [ ] Live rate-limit headers read and retries respect current reset guidance
- [ ] Repeated mutations and webhook deliveries are idempotent
- [ ] Authoritative state is reconciled after asynchronous or notification-only events
- [ ] No production write occurred without explicit authorization

## Storefront Journeys

- [ ] Shopper, session, channel, currency, and locale context verified
- [ ] Cart, checkout, and order states remain distinct
- [ ] Repeated clicks, stale sessions, unavailable items, and failed requests are handled
- [ ] Server-calculated totals remain authoritative
- [ ] Accessibility and responsive behavior verified through the actual flow
