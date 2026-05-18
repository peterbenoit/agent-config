# CONTEXT — Node.js API Development

Building HTTP APIs and backend services with Node.js. This context covers: route structure,
middleware patterns, input validation, authentication, error handling, and test strategy.
Relevant for REST APIs, JSON services, and lightweight server-side applications built with
Node.js — with or without a framework.

---

## Glossary

**Route** — A handler registered for a specific HTTP method + path combination
(e.g., `GET /users/:id`). Routes match incoming requests and produce responses.

**Middleware** — A function that runs before a route handler and can modify the request,
produce a response, or pass control to the next middleware. Examples: auth checks, request
logging, body parsing, CORS headers.

**Handler** — The function that processes a matched request and sends the response.
Receives `(req, res)` in Express-style frameworks, or `(request)` returning a `Response` in
fetch-based runtimes (Hono, Cloudflare Workers).

**`req` / `request`** — The incoming HTTP request object. Contains: method, URL, headers,
body (after parsing), path params, and query string.

**`res` / `response`** — The outgoing HTTP response object. Methods: `res.json()`,
`res.send()`, `res.status()`, `res.set()`.

**Body parsing** — HTTP request bodies arrive as a stream. A body parser reads the stream
and makes it available as `req.body`. Must be applied as middleware before any handler
reads the body.

**Path param** — A named segment in the route path: `/users/:id` → `req.params.id`.

**Query string** — Key-value pairs after `?` in a URL: `/items?page=2&limit=10` →
`req.query.page`, `req.query.limit`. Always strings — parse/validate before using as numbers.

**Status code** — The HTTP response status. Common ones: 200 OK, 201 Created, 400 Bad Request,
401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict, 422 Unprocessable Entity, 500 Internal Server Error.

**JWT (JSON Web Token)** — A signed token used for stateless authentication. Contains a payload
(claims) and a signature. The server verifies the signature; it does not look up a session.
JWTs are not encrypted by default — do not put secrets in the payload.

**Bearer token** — The convention for passing a JWT in an HTTP header:
`Authorization: Bearer <token>`. Middleware extracts and verifies it before the route handler runs.

**CORS (Cross-Origin Resource Sharing)** — A browser security mechanism that blocks requests
from origins not explicitly allowed by the server. Must be configured server-side via headers.
Does not affect server-to-server requests.

**Rate limiting** — Capping how many requests a client can make in a time window. Prevents
abuse and brute-force attacks. Applied as middleware, usually before auth.

**Environment variable** — Configuration injected at runtime via `process.env`. Credentials,
API keys, database URLs, and environment-specific settings always go here — never in source code.

---

## Key Relationships

- Middleware runs in order — order matters. Body parser before routes. Auth before anything
  that needs a user. Rate limiter before auth (to block before doing expensive work).
- Route handlers should be thin — extract business logic into separate functions or modules.
  A handler that is 50+ lines is doing too much.
- `req.params` is always a string. `req.query` is always a string or string[]. Validate and
  coerce before using as a number, boolean, or enum.
- A 500 error means something broke in your code. A 400 means the client sent bad data.
  Never return a 500 for invalid client input.

---

## Common Decisions

| Decision | Preferred approach | Why |
|----------|-------------------|-----|
| Framework | Express (established) or Hono (modern, fetch-based) | Both are minimal; pick based on runtime target |
| Auth | JWT + Bearer token for stateless; sessions for stateful | JWT is simpler for APIs; sessions for web apps |
| Input validation | Zod or native checks | Zod gives schema + TypeScript types; native for simple cases |
| Error handling | Centralized error middleware | One place to log, format, and send error responses |
| CORS | `cors` middleware with explicit origins | Never `*` in production |
| Environment | `dotenv` in dev; real env vars in production | Never commit `.env` |
| Testing | `node --test` with `supertest` for integration | Tests at the route level, not the handler level |

---

## Route Structure

Keep routes organized by resource:

```
routes/
  users.js      # GET /users, POST /users, GET /users/:id, etc.
  items.js
  health.js     # GET /health — no auth, returns 200 if running
index.js        # app setup, middleware registration, route mounting
```

Mount with a prefix:
```js
app.use('/users', usersRouter);
app.use('/items', itemsRouter);
```

---

## Error Handling

Always use a centralized error handler — the last middleware registered:

```js
// Last middleware
app.use((err, req, res, next) => {
  console.error(err);
  const status = err.status || 500;
  res.status(status).json({
    error: err.message || 'Internal server error'
  });
});
```

Throw or call `next(err)` from handlers and middleware — never swallow errors.
Use a custom error class with a `status` property for predictable handling:

```js
class ApiError extends Error {
  constructor(message, status = 500) {
    super(message);
    this.status = status;
  }
}
throw new ApiError('Not found', 404);
```

---

## Input Validation

Never trust client input. Validate at the boundary before any processing:

```js
const { id } = req.params;
if (!id || !/^\d+$/.test(id)) {
  throw new ApiError('Invalid id', 400);
}
```

For complex bodies, use a schema library (Zod) and throw 422 on validation failure.

---

## Security Baseline

Every API should have:
- CORS configured with explicit allowed origins (not `*`)
- Rate limiting on all public endpoints
- Auth middleware on all protected endpoints
- Helmet (or equivalent headers) for security headers
- No stack traces in error responses in production
- No secrets in source code — environment variables only
- Input validation on every endpoint that receives data

---

## Failure Modes / Gotchas

**`Cannot read properties of undefined` in a handler** — Body wasn't parsed. Check that
`express.json()` middleware is registered before the route.

**CORS error in the browser** — The server is not sending the `Access-Control-Allow-Origin`
header, or the browser's preflight `OPTIONS` request isn't handled. Fix server-side.

**Auth middleware passes but user is wrong** — JWT was valid but the `sub` or user ID claim
is from a different environment's token. Check which secret was used to sign.

**Query param is `"true"` not `true`** — Query strings are always strings. `req.query.active`
is the string `"true"`. Compare with `=== 'true'` or parse explicitly.

**Rate limiter blocks legitimate users** — Limit is per-IP but the app is behind a proxy.
All requests look like they come from the proxy IP. Fix: set `app.set('trust proxy', 1)`.

---

## Project Context

Check AGENTS.md or a local context overlay for:
- Node.js version and framework in use
- Auth strategy (JWT vs sessions vs API key)
- Database and ORM/query builder
- Deployment target (cloud function, container, bare server)
- Rate limiting strategy and thresholds
- Known security constraints or compliance requirements
