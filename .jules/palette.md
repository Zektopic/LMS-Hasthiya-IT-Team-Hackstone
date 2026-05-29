## 2026-04-12 - Add tooltip to icon-only back buttons
**Learning:** In Flutter, ensure icon-only buttons (like `IconButton`) always have a descriptive `tooltip` attribute added. This provides proper accessibility labels for screen readers and helpful context for mouse hover states.
**Action:** Always include a `tooltip` string on `IconButton` widgets, especially when they act as standalone navigational elements.
## 2026-05-29 - Add semantic labels to content cards
**Learning:** When building custom clickable cards (e.g., Course or Video cards) using `InkWell`, wrap the `InkWell` in a `Semantics` widget with a specific, descriptive `label` (e.g., `label: 'Course: ${course.title}'`) to ensure screen readers announce the specific item content, preventing generic or unhelpful announcements.
**Action:** Always wrap `InkWell` elements representing structured content in a `Semantics` widget with a descriptive `label`.
