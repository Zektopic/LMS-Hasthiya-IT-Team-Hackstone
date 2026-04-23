💡 What: Replaced iterable methods (`.take()`, `.indexed`) with explicit, bounds-checked `for` loops inside widget `build` methods across the app (`course_detail_view.dart`, `video_player_view.dart`, `home_view.dart`, `profile_view.dart`).

🎯 Why: In Flutter, chained iterable methods allocate intermediate objects (`TakeIterable`, `IndexedIterable`) and closures on every rebuild. When placed in frequently rebuilt `build` methods, this causes unnecessary garbage collection pressure and can lead to UI stuttering.

📊 Impact: Reduces intermediate object allocation during UI rebuilds, specifically preventing O(N) allocation of iterable instances during list generation, decreasing GC pressure.

🔬 Measurement: `flutter analyze` runs clean and `flutter test` passes successfully, verifying that all logic remains exactly identical.
