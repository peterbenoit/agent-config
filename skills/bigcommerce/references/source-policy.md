# BigCommerce Source Policy

Use this reference whenever a claim may have changed since the skill was written.

## Preferred Current Sources

BigCommerce provides agent-readable official documentation:

- Documentation MCP server: `https://docs.bigcommerce.com/_mcp/server`
- Documentation index: `https://docs.bigcommerce.com/llms.txt`
- Changelog: `https://docs.bigcommerce.com/developer/changelog`
- Deprecation guidance: locate the current “Deprecations and Sunsets” page through the index

The docs site states that an individual documentation page can be retrieved as Markdown by adding
`.md`, and page-level indexes are available by appending `/llms.txt`.

Prefer the official MCP server when callable because it can search the current documentation. If it
is unavailable, use the root index to locate the relevant official page and retrieve its Markdown
form. Use ordinary web search only as a fallback, restricted to official BigCommerce sources for
technical contracts.

## Evidence Ladder

| Question | Authoritative evidence |
|---|---|
| What does BigCommerce currently support? | Current official docs and API reference |
| What changed or is going away? | Current changelog and deprecation notices |
| What does this repository implement? | Code, configuration, lockfiles, tests, and local overlay |
| What is configured in this store? | Authorized live store response or control-panel evidence |
| What quota applies now? | Current response headers plus official rate-limit docs |
| Why does an undocumented behavior occur? | Reproduction evidence, then official support/community context |

Documentation examples are not proof of store configuration. Live store output is not proof that
the same behavior is universal across plans, channels, or API surfaces.

## Volatile Facts

Retrieve rather than memorize:

- Endpoint paths, request fields, response shapes, pagination, and limits
- GraphQL schema fields and mutations
- Token types, scopes, origin restrictions, and authentication flows
- Stencil CLI package name, supported Node/Python versions, and Sass requirements
- Catalyst versions and conventions
- Plan-specific quotas and platform limits
- API versions, beta status, deprecations, and sunset dates
- Control-panel navigation labels

When a response depends on a volatile fact, name the official source and verification date.

## Conflicts

If the repository conflicts with current docs:

1. Confirm the repository version and platform surface.
2. Check whether the code intentionally targets a legacy or deprecated behavior.
3. Check changelog, migration, and deprecation guidance.
4. Report the conflict before changing code.
5. Preserve working compatibility until the user authorizes a migration.
