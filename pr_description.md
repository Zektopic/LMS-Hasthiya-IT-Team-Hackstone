💡 **What:**
Wrapped the `InkWell` components for the course and video cards in `home_view.dart` and `explore_view.dart` with `Semantics(button: true, enabled: true, label: ...)` wrappers, using the respective course or video title as the label. Excluded the use of `excludeSemantics: true` to preserve the screen reading of child text elements like duration and descriptions.

🎯 **Why:**
Custom interactive components that use `InkWell` internally do not always expose proper button traits or specific, descriptive labels to screen readers by default. This makes navigation confusing for users relying on assistive technologies.

📸 **Before/After:**
Before, screen readers would interact with the custom glass cards without explicitly recognizing them as tappable interactive buttons, and without a high-level label announcing the primary content (the title). Now, they announce "Course: [Title]" or "Video: [Title]" while still correctly reading the child contents.

♿ **Accessibility:**
Significantly improves screen reader navigation by correctly identifying tappable custom cards as buttons and announcing their specific content titles upfront.
