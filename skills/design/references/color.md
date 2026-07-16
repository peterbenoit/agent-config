# Web Color Reference

Read this reference when creating a palette, defining design tokens, implementing themes, or
reviewing color and contrast.

## Start With Semantic Roles

Define roles before values:

- Canvas and elevated surfaces
- Primary and muted text
- Subtle and strong borders
- Primary, secondary, and destructive actions
- Focus, selection, and current state
- Informational, success, warning, and error feedback

Components should consume semantic tokens, not raw palette steps. Keep primitive color values in a
lower token layer so themes can remap meaning without rewriting components.

## Use OKLCH Deliberately

OKLCH makes lightness and chroma adjustments more predictable than HSL, but equal numeric changes
do not guarantee equal perceived contrast or in-gamut output.

```css
:root {
  --color-blue-600: oklch(52% 0.18 255);
  --color-action: var(--color-blue-600);
  --color-action-text: white;
}
```

- Adjust lightness first when building tonal steps.
- Reduce chroma near very light and very dark endpoints to avoid harsh or clipped colors.
- Verify wide-gamut colors on ordinary sRGB displays and provide an acceptable fallback when
  needed.
- Test contrast from rendered values; do not infer compliance from OKLCH lightness alone.

## Themes and Dark Mode

- Remap semantic roles instead of mathematically inverting the palette.
- Dark surfaces usually need lower chroma and gentler borders than light themes.
- Preserve hierarchy between canvas, surface, raised surface, and overlays.
- Test images, logos, illustrations, focus indicators, form controls, and system colors in each
  theme.
- Respect `color-scheme` when native controls should follow the active theme.

## Accessibility

- Meet the project's required WCAG contrast ratios for text, UI components, and focus indicators.
- Never use color as the only indication of status, selection, validation, or required fields.
- Test hover, active, disabled, visited, selected, and focus states—not only defaults.
- Check forced-colors mode when supporting Windows High Contrast.
- Avoid using opacity to create text colors when it makes contrast unpredictable across surfaces.

## Review Checklist

- Can every color be named by its job?
- Are actions, links, feedback, and selection states distinguishable?
- Does the palette retain hierarchy in dark and high-contrast conditions?
- Are subtle borders still visible without becoming visual noise?
- Are decorative colors subordinate to content?
- Have all relevant foreground/background pairs been measured rather than guessed?
