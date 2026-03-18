## 2024-05-17 - Flutter Text Input UX
**Learning:** For optimal keyboard UX in Flutter forms, `textInputAction: TextInputAction.next` should be set on intermediate fields, and `TextInputAction.done` with `onSubmitted` should be set on the final field. Appropriate `keyboardType`s should be used as well. This is an excellent pattern for accessibility and general UX.
**Action:** Apply this pattern to all form inputs in Flutter apps.
