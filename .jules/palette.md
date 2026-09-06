## 2024-08-18 - [Add Semantic Button traits]
**Learning:** Adding explicit semantic wrappers with `button: true` to custom interactive components that utilize `InkWell` internally improves how screen readers identify and present these components to users. Without this, standard buttons might not be announced with the proper traits.
**Action:** When building custom interactive components and nesting `InkWell` deep within other widgets like layout wrappers or containers without default semantics, always make sure to apply the appropriate `Semantics` wrappers. Ensure to manage states such as disabled (`enabled: !isDisabled`).
## 2026-08-27 - Explicit focus and hover states
**Learning:** InkWell widgets placed on top of custom dark or glassmorphic backgrounds lose their default focus and hover visibility, making keyboard navigation and mouse interactions inaccessible.
**Action:** Explicitly define `focusColor` and `hoverColor` (e.g., `Colors.white.withValues(alpha: 0.1)`) on `InkWell` widgets within custom interactive components to ensure keyboard focus indicators and mouse hover states remain visible against custom backgrounds.
## 2024-06-25 - Focus and hover colors for Glass widgets
**Learning:** Glassmorphism UI elements using `Colors.white.withValues(alpha: opacity)` for their background can mask default `InkWell` keyboard focus and mouse hover states.
**Action:** Always explicitly define `focusColor` and `hoverColor` (e.g. `Colors.white.withValues(alpha: 0.1)`) on `InkWell` components used within glassmorphism widgets to maintain accessibility for keyboard and mouse users.

## 2024-09-02 - Add Semantic Button traits to custom filter pills
**Learning:** Filter chips built with AnimatedContainer and GestureDetector lack standard button semantics and keyboard focus states, making them inaccessible.
**Action:** Replace GestureDetector with InkWell inside a Semantics(button: true) wrapper to explicitly add button traits, and define hoverColor/focusColor to ensure keyboard accessibility.
## 2026-09-06 - Add tooltip to PopupMenuButton
**Learning:** Icon-only interactive elements like `PopupMenuButton` default to generic screen reader announcements (e.g. 'Show menu'). This can be confusing for users relying on accessibility tools or needing context on desktop via hover states.
**Action:** Always provide a descriptive `tooltip` attribute (e.g. `tooltip: 'Sort reviews'`) to `PopupMenuButton` and similar icon-only widgets to ensure screen readers announce the element's specific purpose clearly.
