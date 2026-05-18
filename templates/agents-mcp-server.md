# AGENTS.md — <!-- Project name --> MCP Server

<!-- One sentence: what this MCP server does and what it connects to. -->

---

## What This Is

<!-- Describe the MCP server: what protocol it implements, what host (Claude Code, Claude Desktop,
VS Code Copilot), what resources, tools, or prompts it exposes, and what backend it talks to. -->

---

## Architecture

```
<!-- Fill in the server architecture. Example:
Client (Claude Code) → MCP server → External API / Local file system / Database
-->
```

**Server type:** <!-- stdio | SSE | HTTP -->
**Transport:** <!-- stdin/stdout | HTTP+SSE -->
**Protocol version:** <!-- MCP spec version implemented -->

---

## Resources

<!-- List MCP resources exposed by this server.
A resource is a URI-addressed piece of content the client can read.

| URI Pattern | Description |
|-------------|-------------|
| `resource://...` | ... |
-->

---

## Tools

<!-- List MCP tools exposed by this server.
A tool is a callable function the model can invoke.

| Tool name | Description | Input schema |
|-----------|-------------|-------------|
| `tool_name` | What it does | `{param: type}` |
-->

---

## Prompts

<!-- List MCP prompts exposed by this server, if any.
A prompt is a reusable message template the client can request.

| Prompt name | Description |
|-------------|-------------|
| `prompt_name` | ... |
-->

---

## Local Setup

```bash
# Install dependencies
npm install

# Start the server (stdio mode)
node server.js

# Or with MCP inspector for debugging
npx @modelcontextprotocol/inspector node server.js
```

---

## Client Configuration

### Claude Code / Claude Desktop

Add to `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "<!-- server-name -->": {
      "command": "node",
      "args": ["/absolute/path/to/server.js"],
      "env": {
        "API_KEY": "..."
      }
    }
  }
}
```

### VS Code Copilot

Add to `.vscode/mcp.json`:

```json
{
  "servers": {
    "<!-- server-name -->": {
      "type": "stdio",
      "command": "node",
      "args": ["./server.js"]
    }
  }
}
```

---

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| <!-- `API_KEY` --> | Yes | <!-- What it is --> |

Never commit `.env`. Copy `.env.example` and fill in real values locally.

---

## Testing

```bash
# Run unit tests
npm test

# Test a specific tool with the MCP inspector
npx @modelcontextprotocol/inspector node server.js
```

---

## Deployment

<!-- Describe how this server is deployed if it runs remotely.
For local-only stdio servers, note that here. -->

---

## Hard Rules

- Never log or expose secrets in tool responses or resource content
- All tool inputs must be validated before use — never trust model-provided arguments
- Tool error responses must not include stack traces in production
- Resources must not return content from paths outside the allowed root

---

## Skills

Agent skills are in `./skills/`. **Recommended for MCP servers:** `security`, `tdd`, `qa`, `debug`, `npm-publish`

---

## Known Issues / Gotchas

<!-- List anything non-obvious: edge cases, rate limits, known model behaviors, auth quirks. -->
