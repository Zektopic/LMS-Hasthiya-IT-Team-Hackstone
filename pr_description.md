💡 What: Added `semanticsLabel` to `CircularProgressIndicator` instances across the app (e.g., 'Loading dashboard', 'Submitting review', etc.).
🎯 Why: Screen readers previously did not announce anything when these loading spinners appeared, causing a disjointed and confusing experience for visually impaired users during async operations.
📸 Before/After: Visuals remain unchanged; loading indicators now include invisible accessibility labels.
♿ Accessibility: Ensures that screen reader users receive immediate auditory feedback when a background or async task is loading, improving overall navigability.
