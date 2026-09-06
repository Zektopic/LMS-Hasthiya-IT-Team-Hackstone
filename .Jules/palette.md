## 2024-08-23 - Add Semantics Label to CircularProgressIndicator
**Learning:** Screen readers do not announce anything when a native `CircularProgressIndicator` appears, which creates a frustrating experience during async loading states. Adding a `semanticsLabel` ensures visually impaired users are aware of the loading state.
**Action:** Always add a descriptive `semanticsLabel` (e.g., 'Loading dashboard', 'Submitting review') to `CircularProgressIndicator` when it is used to indicate async operations.
