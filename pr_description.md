💡 **What:**
Replaced `.map().toList()` chains with Dart collection `for` loops when parsing Firestore query snapshots into models (e.g., `Course.fromFirestore` and `Video.fromFirestore`) within `CourseService`, `VideoService`, and `Course` models.

🎯 **Why:**
Using `.map().toList()` on iterables like `snapshot.docs` creates an intermediate `MappedIterable` and a closure object. This allocates unnecessary memory objects that are immediately discarded after `.toList()` is called, which places unnecessary pressure on the garbage collector. This can lead to dropped frames during UI updates or background operations, especially on large lists.

📊 **Impact:**
Reduces heap allocation and memory pressure. Avoiding the intermediate allocations provides a performance improvement to list parsing, and translates directly to smoother scrolling and snappier UI when fetching recommended courses and videos.

🔬 **Measurement:**
This can be verified by profiling memory allocations in the Dart DevTools during list data fetching (e.g., loading recommended courses in `HomeView`). The number of allocated `MappedIterable` instances will be observably reduced.
