# Web Typography Reference

Read this reference when selecting fonts, defining a type system, implementing text styles, or
reviewing typography in rendered UI.

## Choose Roles Before Families

Define what the system needs before choosing typefaces:

- **Display:** character and emphasis for a limited set of large headings
- **Body:** high readability across long and short passages
- **Utility:** labels, controls, captions, navigation, and dense data
- **Data:** tabular figures or a monospace face only when the content benefits

One family may cover several roles if its range is sufficient. Multiple families must create a
useful contrast rather than novelty.

## Build a Practical Scale

- Use a small, named set of text roles rather than arbitrary sizes.
- Combine size, line-height, weight, width, and spacing; size alone does not establish hierarchy.
- Use `clamp()` for display sizes when continuous scaling helps, with tested minimum and maximum
  values.
- Keep body copy near a comfortable measure—typically 45–75 characters per line—while allowing
  UI labels and data displays to follow their task.
- Tighten display leading carefully; give multi-line body copy enough leading to track easily.

## Font Delivery

- Prefer WOFF2 and subset only when the project can maintain the subsets correctly.
- Preload only fonts needed for initial rendering.
- Choose `font-display` according to the product: `swap` prioritizes immediate text, while
  `optional` can reduce late layout changes on performance-sensitive pages.
- Match fallback metrics with `size-adjust`, `ascent-override`, `descent-override`, and
  `line-gap-override` when font swapping causes layout shift.
- Avoid loading weights or styles the interface never uses.

## Detailed Text Treatment

- Use `font-variant-numeric: tabular-nums` for changing values, tables, timers, and aligned totals.
- Enable OpenType features only when the font supports them and the content benefits.
- Use `text-wrap: balance` sparingly for short headings and `text-wrap: pretty` for prose where
  supported; verify the actual line breaks.
- Truncate only when the full value remains available by another accessible method.
- Style links so they remain identifiable without color alone.
- Avoid low-contrast placeholder text and prevent iOS form zoom with inputs of at least 16px rather
  than disabling viewport zoom.

## Review Checklist

- Does the typography fit the subject rather than a trend?
- Are hierarchy and action labels clear without relying on color?
- Are line lengths and line breaks comfortable at every target width?
- Do real long names, translated strings, and large numbers fit?
- Are numerals aligned where comparison matters?
- Is text still readable at 200% zoom and with user font overrides?
- Are font loading and fallback shifts acceptable?
