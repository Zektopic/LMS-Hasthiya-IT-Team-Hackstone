## 2024-08-18 - [Add Semantic Button traits]
**Learning:** Adding explicit semantic wrappers with `button: true` to custom interactive components that utilize `InkWell` internally improves how screen readers identify and present these components to users. Without this, standard buttons might not be announced with the proper traits.
**Action:** When building custom interactive components and nesting `InkWell` deep within other widgets like layout wrappers or containers without default semantics, always make sure to apply the appropriate `Semantics` wrappers. Ensure to manage states such as disabled (`enabled: !isDisabled`).
## 2026-08-27 - Explicit focus and hover states
**Learning:** InkWell widgets placed on top of custom dark or glassmorphic backgrounds lose their default focus and hover visibility, making keyboard navigation and mouse interactions inaccessible.
**Action:** Explicitly define `focusColor` and `hoverColor` (e.g., `Colors.white.withValues(alpha: 0.1)`) on `InkWell` widgets within custom interactive components to ensure keyboard focus indicators and mouse hover states remain visible against custom backgrounds.
