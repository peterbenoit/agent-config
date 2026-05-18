---
name: npm-safety
category: Security
tags: [npm, security, packages, dependencies, supply-chain, audit]
description: >
  Apply security precautions whenever recommending npm or pnpm package installs.
  ALWAYS trigger this skill when about to suggest `npm install`, `npm i`, `pnpm add`,
  `npx`, `pnpm dlx`, or any package manager install command. Also trigger when
  recommending a new dependency, suggesting a package by name, or adding anything
  to package.json. Do NOT skip this skill just because the task feels routine or
  the package seems well-known. Supply chain attacks happen to popular packages too.
---

# npm Safety

Apply these precautions every time a package install is recommended, without exception.

---

## Required behavior on every package recommendation

### 1. Flag the install explicitly

Never let a package install slide by silently. Always surface it with a clear label, e.g.:

> **Package install:** `pnpm add marked`

This makes the user aware something is being added to their dependency tree.

---

### 2. Include a socket.dev check link

Always provide the socket.dev link for the package so the user can inspect it before running anything:

```
https://socket.dev/npm/package/PACKAGE_NAME
```

Look for red flags: new maintainers, new network calls, install scripts added recently, obfuscated code, ownership transfers.

---

### 3. Recommend --ignore-scripts by default

Always suggest the `--ignore-scripts` flag unless there's a confirmed need for post-install scripts:

```bash
pnpm add some-package --ignore-scripts
# or
npm install some-package --ignore-scripts
```

If `--ignore-scripts` will break the package (native bindings, compilers, etc.), say so explicitly and explain why the script is needed before dropping the flag.

---

### 4. Note transitive risk on new additions

When recommending a package that pulls in many dependencies, note it. A package with 80 transitive deps is a larger attack surface than one with 3. You don't need an exact count every time, but flag it when it's notable.

---

### 5. Context-tiered caution

Apply stricter language based on project context:

| Context | Guidance |
|---|---|
| Government / VA / Peraton work | Highest scrutiny. Flag every install. Suggest alternatives from already-trusted deps first. |
| Published packages (reQuery, etc.) | Your users are downstream. Vet carefully. Prefer zero new deps where possible. |
| Personal site / blog | Standard caution, lighter tone. |
| CodePens / quick experiments | Remind that CDN links from trusted sources (unpkg, cdnjs) can sidestep npm entirely. |

---

### 6. Prefer stdlib and existing deps first

Before recommending a new package, ask: can this be done with what's already installed, or with a native browser/Node API? If yes, suggest that first. Only reach for a new package when it's genuinely the right tool.

---

### 7. npx and pnpm dlx are installs too

Treat `npx some-tool` and `pnpm dlx some-tool` with the same scrutiny as a full install. They pull and execute in one step with no lockfile protection. Always note this when suggesting them.

---

## Quick reference output format

When recommending a package install, the response should include at minimum:

```
📦 Package install: `pnpm add [package] --ignore-scripts`
🔍 Check first: https://socket.dev/npm/package/[package]
⚠️  [Any relevant notes: install scripts, transitive deps, ownership, etc.]
```

Keep it concise. Don't turn every install into a lecture. The goal is a consistent, visible speed bump, not friction paralysis.
