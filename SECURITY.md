# Security Policy

## Scope

agent-config is a personal toolkit of shell scripts, markdown skill files, and agent
configuration templates. It is not a deployed service or public package. The primary
security concern is the hook system, which executes shell scripts in response to agent
tool calls.

## Reporting a Problem

If you find a security issue in any script, hook, or configuration in this repo, open a
GitHub issue marked **[security]** or email the maintainer directly. Do not include
reproduction steps for active exploits in a public issue.

For a personal toolkit with no active user base, full CVE-style disclosure is not
required. A clear description of the problem and the affected file is enough to act on.

## What Warrants a Report

- A hook script that can be exploited to execute arbitrary commands
- A pattern in skill files that could cause an agent to exfiltrate secrets
- A validation bypass in `block-dangerous-git.sh` that allows blocked commands through
- Any script that writes to paths outside the intended project directory

## What Does Not Warrant a Report

- Missing documentation
- Stylistic disagreements
- Features that are simply not implemented yet

## Expectations

Reports will be reviewed promptly. There is no bug bounty program. Credit in the
CHANGELOG is offered if requested.
