## 2026-04-12 - Add tooltip to icon-only back buttons
**Learning:** In Flutter, ensure icon-only buttons (like `IconButton`) always have a descriptive `tooltip` attribute added. This provides proper accessibility labels for screen readers and helpful context for mouse hover states.
**Action:** Always include a `tooltip` string on `IconButton` widgets, especially when they act as standalone navigational elements.

## 2024-05-24 - Add Semantics to Stacked InkWell Custom Cards
**Learning:** In Flutter, when building custom clickable cards (like Course or Video cards) using an `InkWell` inside a `Stack` (e.g. over other contents), wrapping the `InkWell` in a `Semantics` widget with a descriptive `label` ensures that screen readers announce the specific item content, preventing generic or unhelpful announcements.
**Action:** Always wrap `InkWell` within custom generic cards with a `Semantics` widget supplying a specific, descriptive `label` (e.g., `label: 'Course: ${course.title}'`).
