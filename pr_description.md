💡 **What:** Replaced the usage of chained iterable methods like `.take(n)` and `.indexed` inside the `build` methods of `HomeView`, `CourseDetailView`, and `VideoPlayerView` with explicitly bounds-checked `for` loops.

🎯 **Why:** In Dart, calling methods like `.take()` on iterables inside a widget's build method creates intermediate `TakeIterable` objects on every UI frame/rebuild. In list generation logic, this creates entirely unnecessary intermediate allocations that immediately become garbage. By using a standard explicit loop (`for (var i = 0; i < collection.length && i < n; i++)`), we skip these intermediate object allocations completely, avoiding extra work for the garbage collector and maintaining smooth 60fps rendering, especially on lower-end devices.

📊 **Impact:** Reduces object allocation and garbage collection pressure linearly correlated with the frequency of widget rebuilds and list generation occurrences.

🔬 **Measurement:** Verify the codebase compiles and tests pass. Direct GPU/GC measurement in a headless runner is impractical, but the technical reduction of object allocation per-frame is verified via Dart's documentation for lazy iterables.
