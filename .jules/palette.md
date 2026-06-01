## 2026-04-12 - Add tooltip to icon-only back buttons
**Learning:** In Flutter, ensure icon-only buttons (like `IconButton`) always have a descriptive `tooltip` attribute added. This provides proper accessibility labels for screen readers and helpful context for mouse hover states.
**Action:** Always include a `tooltip` string on `IconButton` widgets, especially when they act as standalone navigational elements.
## 2024-06-01 - Specific Semantics for Stacked Clickable Cards
**Learning:** When building custom clickable cards using a Stack where the InkWell is separated from the visual content (e.g., via Positioned.fill), screen readers may announce a generic "button" without context. Adding a specific, descriptive label to the InkWell's Semantics wrapper prevents unhelpful generic announcements.
**Action:** Always wrap InkWells used as card overlays in a Semantics widget with a descriptive label reflecting the card's specific content.
