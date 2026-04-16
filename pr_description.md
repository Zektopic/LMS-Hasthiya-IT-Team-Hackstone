💡 What
Added `textInputAction: TextInputAction.search` and an `onSubmitted` handler to the search `TextField` in `ExploreView`.

🎯 Why
By default, standard `TextField` widgets do not automatically dismiss the virtual keyboard upon submission. When a user searched for courses or videos, the keyboard remained open, obscuring the results and requiring a manual swipe to dismiss. This change ensures the correct "Search" key is shown on the keyboard and automatically dismisses it upon submission.

📸 Before/After
*   **Before:** Pressing Enter/Return on the keyboard triggered the search logic, but the keyboard remained on screen.
*   **After:** The keyboard displays a Search icon on the action button, and tapping it immediately executes the search and collapses the keyboard, revealing the content.

♿ Accessibility
Improves keyboard interaction logic and ensures standard mobile OS behavior is respected.
