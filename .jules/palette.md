## 2026-04-12 - Add tooltip to icon-only back buttons
**Learning:** In Flutter, ensure icon-only buttons (like `IconButton`) always have a descriptive `tooltip` attribute added. This provides proper accessibility labels for screen readers and helpful context for mouse hover states.
**Action:** Always include a `tooltip` string on `IconButton` widgets, especially when they act as standalone navigational elements.

## 2024-05-23 - Retaining explicit semantics on parent containers
**Learning:** In Flutter, while `InkWell` provides implicit button semantics, wrapping a structural layout widget (like `Container`) with `Semantics` requires retaining the `button: true` trait if that container acts as the overall interactive target, even if there is an `InkWell` deeper within it. Removing the explicit button semantics from the wrapping `Container` removes the button trait entirely from screen reader announcements.
**Action:** When auditing redundant `button: true` traits, never remove them from `Semantics` widgets wrapping structural components like `Container`. Instead, look to add appropriate visual and auditory feedback, such as `Tooltip`, to icon-only custom widgets.
