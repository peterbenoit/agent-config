---
name: 'announce'
description: 'Generate platform-appropriate social copy for a new post, project, or experiment'
argument-hint: 'URL or file path of the content to announce'
agent: 'ask'
tools: ['search/codebase', 'vscode/openFile']
---

Generate social copy to announce: ${input:content:URL or file path of the content}

Read the file or URL provided. Then read [skills/social/SKILL.md](../skills/social/SKILL.md)
for the platform framing rules and what-not-to-do constraints.
Read AGENTS.md for project-specific handles, platforms in use, and any automation tools.

---

## Determine the Content Type

Classify the content as one of:
- **Blog post (technical)** — CSS, JavaScript, dev tools, web platform
- **Blog post (personal)** — hiking, personal writing, non-technical
- **Open source project / tool** — something others can use
- **Experiment / demo** — a lab, a proof of concept, an interactive thing
- **Other** — describe what it is

---

## Output

Produce copy for each active platform. Do not produce copy for platforms not in use
(check AGENTS.md for which platforms are active).

### Twitter/X

One tweet, maximum 280 characters. URLs count as 23 characters regardless of length.

Lead with the problem, the surprising thing, or the specific observation — not the title.
Format: observation/problem → brief explanation → link.

Show the character count. Flag if it exceeds 280.

### LinkedIn

2–3 short paragraphs. Different framing from Twitter — professional context, why it matters.
End with a direct link. No "link in comments".

---

## Constraints (from social skill)

- Do not start with "Excited to share" or "Thrilled to announce"
- Do not ask for likes or retweets
- Do not cross-post identical copy on both platforms
- Do not post just because it was published — identify the actual angle worth sharing

If there is no angle worth sharing, say so directly rather than manufacturing one.

---

## Timing Recommendation

State the best day/time to post based on the social skill's timing guidance,
and whether anything in the current week would make the timing better or worse.
