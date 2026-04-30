---
name: 'Security Baseline'
description: 'Security rules applied to every file in every session'
applyTo: '**'
---

# Security Baseline

These rules apply unconditionally to every file and every task. They are not a checklist
to run at review time — they are constraints on what gets written in the first place.

## Secrets — Absolute Rules

- Never write a credential, API key, token, password, or private key into source code.
  Not as a placeholder, not as an example, not commented out. Use environment variable
  names only (e.g., `process.env.API_KEY`), never values.
- Never commit a `.env` file. Verify `.gitignore` includes it before touching any env file.
- If you discover a secret in the codebase or git history: stop, flag it, do not proceed
  until the user confirms the secret has been rotated.
- "Private repo" does not mean "safe to store secrets." Treat all repos as potentially public.

## Code — Never Write

- `eval()` with any user-supplied or external input
- `innerHTML = ` with any unsanitized value
- `document.write()` with any unsanitized value
- `dangerouslySetInnerHTML` without explicit sanitization
- SQL queries assembled by string concatenation — always use parameterized queries
- Disabled certificate verification in any environment

## Dependencies

- Do not add a new dependency without noting it. New dependencies expand attack surface.
- If `npm audit` (or equivalent) is run and shows high/critical findings, do not proceed
  with unrelated work until the findings are acknowledged by the user.
- CDN-loaded scripts should use Subresource Integrity (SRI) hashes.

## Client vs. Server

- API keys that provide write access, billing access, or sensitive data must never appear
  in client-side code. Always route through a server-side function.
- Auth checks happen server-side. Client-side checks are UI convenience only.
- Never trust user-supplied input on the server without validation at the boundary.

## When in Doubt

Stop and ask. Security decisions made quickly are usually wrong. A one-line addition
that touches auth, session handling, or data access deserves a full read before committing.
