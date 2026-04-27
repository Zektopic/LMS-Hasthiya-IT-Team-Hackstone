💡 What: Wrapped the custom search bar (`InkWell`) in `HomeView` with a `Semantics` widget.
🎯 Why: To ensure screen readers announce the pseudo-search bar correctly as an interactive button.
📸 Before/After: Visuals remain unchanged, but the accessibility tree now properly exposes the button.
♿ Accessibility: Added `Semantics(button: true, label: 'Search courses, videos...', excludeSemantics: true)`.
