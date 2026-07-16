# Stencil Workflow

Use this reference for hosted Stencil theme work. Retrieve current official documentation before
relying on CLI version, runtime requirements, configuration filenames, or deployment behavior.

## Inspect First

- Read `package.json`, lockfile, theme metadata, `config.json`, `schema.json`, and local Stencil
  configuration.
- Locate the page template, partials, browser entry point, and existing component pattern.
- Check page front matter and available Stencil context before adding an API request.
- Identify whether the project uses the default Cornerstone structure or a customized build.
- Preserve secrets in ignored local configuration.

## Custom Templates

Current Stencil structure places assignable custom templates beneath:

```text
templates/pages/custom/
├── brand/
├── category/
├── product/
└── page/
```

Use an ordinary descriptive `.html` filename in the appropriate directory. For local testing, map
that filename to an existing store URL through the Stencil configuration's current custom-layout
mechanism. Verify the current configuration filename and syntax in official docs rather than
assuming an older `.stencil` format.

After upload, assignment through the control panel or an appropriate association API is separate
from creating the file. Verify the intended channel and entity association.

## Data Flow

- Prefer template context and front matter for data already available during server rendering.
- Use the project's established context-injection method for browser JavaScript.
- Escape data correctly for its HTML, attribute, URL, CSS, or JavaScript context.
- Keep privileged API calls outside browser-delivered theme code.
- Avoid fetching the same data twice across template and browser layers.

## Page Builder and Widgets

Inspect current official content/widget documentation before creating or mutating templates,
instances, or placements. Confirm:

- Schema fields and editor behavior
- Region name and target page/channel
- Whether the widget is managed in code or manually
- Update and deletion ownership
- Fallback behavior when configuration is incomplete

Do not overwrite merchant-managed content without explicit scope.

## Local Verification

- Start the theme using the repository's documented command and supported runtime.
- Visit the exact page type and mapped custom-template URL.
- Exercise responsive and interactive behavior.
- Check browser console, network failures, template rendering, and missing translation keys.
- Verify keyboard behavior and visible focus.
- Run project lint, build, and theme-size checks.
- Bundle and inspect output before any upload.

Uploading, assigning, and activating a theme can affect external state. Follow the user's requested
deployment scope and do not activate a theme merely because an upload succeeded.
