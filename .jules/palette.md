## 2026-04-12 - Add tooltip to icon-only back buttons
**Learning:** In Flutter, ensure icon-only buttons (like `IconButton`) always have a descriptive `tooltip` attribute added. This provides proper accessibility labels for screen readers and helpful context for mouse hover states.
**Action:** Always include a `tooltip` string on `IconButton` widgets, especially when they act as standalone navigational elements.

## 2024-06-03 - Semantic labels for overlay InkWells
**Learning:** When building custom clickable cards using a Stack where an InkWell overlay is separated from the visual content via Positioned.fill, screen readers will announce a generic or empty button because the InkWell has no semantic children.
**Action:** Wrap the overlay InkWell in a Semantics widget with a specific, descriptive label (e.g., label: 'Course: ${course.title}') to ensure screen readers announce the specific item content.
