## 2024-08-18 - [Add Semantic Button traits]
**Learning:** Adding explicit semantic wrappers with `button: true` to custom interactive components that utilize `InkWell` internally improves how screen readers identify and present these components to users. Without this, standard buttons might not be announced with the proper traits.
**Action:** When building custom interactive components and nesting `InkWell` deep within other widgets like layout wrappers or containers without default semantics, always make sure to apply the appropriate `Semantics` wrappers. Ensure to manage states such as disabled (`enabled: !isDisabled`).
## 2026-08-27 - Explicit focus and hover states
**Learning:** InkWell widgets placed on top of custom dark or glassmorphic backgrounds lose their default focus and hover visibility, making keyboard navigation and mouse interactions inaccessible.
**Action:** Explicitly define `focusColor` and `hoverColor` (e.g., `Colors.white.withValues(alpha: 0.1)`) on `InkWell` widgets within custom interactive components to ensure keyboard focus indicators and mouse hover states remain visible against custom backgrounds.
## 2024-06-25 - Focus and hover colors for Glass widgets
**Learning:** Glassmorphism UI elements using `Colors.white.withValues(alpha: opacity)` for their background can mask default `InkWell` keyboard focus and mouse hover states.
**Action:** Always explicitly define `focusColor` and `hoverColor` (e.g. `Colors.white.withValues(alpha: 0.1)`) on `InkWell` components used within glassmorphism widgets to maintain accessibility for keyboard and mouse users.

## 2024-09-02 - Add Semantic Button traits to custom filter pills
**Learning:** Filter chips built with AnimatedContainer and GestureDetector lack standard button semantics and keyboard focus states, making them inaccessible.
**Action:** Replace GestureDetector with InkWell inside a Semantics(button: true) wrapper to explicitly add button traits, and define hoverColor/focusColor to ensure keyboard accessibility.
## 2024-05-15 - [Keyboard Navigation in Flutter Forms]
**Learning:** Found that basic `TextField`s in Flutter do not automatically provide a great keyboard UX out of the box. Specifically, users need `textInputAction: TextInputAction.next` on intermediate fields to jump to the next one quickly, and `textInputAction: TextInputAction.done` with `onSubmitted` on the final field to let them submit directly from the keyboard instead of requiring a tap on the submit button. `keyboardType` should also be set correctly (like `TextInputType.emailAddress`) so the OS can display the optimal virtual keyboard (e.g. showing `@` prominently).
**Action:** Always verify keyboard navigation and add `textInputAction` and `onSubmitted` handlers to any form in a Flutter application for a smoother typing experience, particularly on mobile devices.
## 2026-03-14 - [Interactive List Items with InkWell]
**Learning:** In Flutter, static `Container` widgets used as list items lack visual tap feedback and implicit button accessibility semantics. A pattern was observed where actionable lesson items appeared static when tapped.
**Action:** Always wrap actionable list items in `Material` and `InkWell` (with `onTap` defined). This automatically adds the standard ripple visual feedback and exposes the element to screen readers as a semantic button without requiring manual ARIA-like attributes.
## 2026-03-16 - [Group Information in Cards for Accessibility]
**Learning:** Found that visual cards displaying statistics or ratings (like a star icon next to a number) are read separately by screen readers, leading to a disjointed user experience (e.g. reading 'star' then '4.8').
**Action:** Use `Semantics` with `excludeSemantics: true` around the grouped widgets, and provide a single, clean `label` (e.g. 'Rating: 4.8 stars') to ensure screen readers announce the combined information cohesively.
## 2026-03-25 - Interactive Components Tap Feedback
**Learning:** When replacing `GestureDetector` with `Material` and `InkWell` for visual tap feedback inside `GlassCard` components, applying padding globally inside the `InkWell` can break edge-to-edge layouts (like cover images/thumbnails).
**Action:** Always maintain the exact padding structure of the original component. Shift padding selectively to inner children only where needed, ensuring elements designed to be flush with the card's border retain their styling.
## 2024-05-30 - Replace GestureDetector with Material+InkWell for Interactive Elements
**Learning:** Using `GestureDetector` for interactive widgets like cards, chips, and navigation items fails to provide visual tap feedback and misses out on implicit accessibility semantics (like screen readers identifying the element as a button).
**Action:** When wrapping a widget to make it interactive, prefer using `Material` combined with `InkWell` inside the container to automatically provide visual ripple effects and implicit semantic button traits.
## 2026-03-29 - [Form Accessibility and Feedback]
**Learning:** Found that when buttons submit forms using `GlassButton` or similar custom buttons, if they only change opacity to indicate an inactive/loading state, it may be insufficient for accessibility and clear user feedback, especially without an ARIA label or `Semantics` equivalent in Flutter.
**Action:** Always ensure buttons used for async actions show a visible loading state (like `CircularProgressIndicator`) and have explicit `Semantics` or descriptive labels to indicate their current state (e.g., 'Loading, please wait') to screen readers.

## 2026-09-06 - Add tooltip to PopupMenuButton
**Learning:** Icon-only interactive elements like `PopupMenuButton` default to generic screen reader announcements (e.g. 'Show menu'). This can be confusing for users relying on accessibility tools or needing context on desktop via hover states.
**Action:** Always provide a descriptive `tooltip` attribute (e.g. `tooltip: 'Sort reviews'`) to `PopupMenuButton` and similar icon-only widgets to ensure screen readers announce the element's specific purpose clearly.
