💡 What
- Replaced `GestureDetector` with `Material` and `InkWell` for the reviews summary section and empty review state in both `course_detail_view.dart` and `video_player_view.dart`.
- Converted the "+ X more reviews" static text into a clickable `TextButton`.

🎯 Why
- The previous implementation using `GestureDetector` provided no visual feedback (ripple effect) when users tapped the reviews section.
- The empty state ("No reviews yet") was entirely static and unclickable, preventing users from being the first to review content.
- Using `Material` and `InkWell` (and `TextButton`) natively handles visual touch feedback and improves user interaction clarity.

📸 Before/After
- **Before:** Tapping the review summary or empty review state produced no visual feedback. The "+ X more reviews" was plain text.
- **After:** Tapping the review summary or empty state produces a material ripple effect. The "+ X more reviews" is now a styled `TextButton` with proper focus and hover states.

♿ Accessibility
- `InkWell` and `TextButton` automatically provide standard button semantics for screen readers, unlike the generic `GestureDetector`.
