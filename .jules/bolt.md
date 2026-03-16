## 2024-05-17 - Missing Mongoose Indexes
**Learning:** The models in `lms-backend` (`User.js` and `Video.js`) have fields that are frequently queried or sorted by (e.g., `email` in User via `findOne`, `createdAt` in Video via `find().sort()`), but they lack explicit database indexes. While Mongoose creates indexes for `unique: true` fields like `email`, adding an explicit index on fields used for sorting, such as `createdAt` in `Video.js`, is a crucial performance optimization. Without it, MongoDB has to scan all documents and perform an in-memory sort, which scales poorly and becomes a bottleneck as the dataset grows.
**Action:** I will add an index to the `createdAt` field in the `Video` model to optimize the `getAllVideos` query which sorts by `createdAt: -1`.

## 2024-05-18 - Mongoose Read-Only Queries
**Learning:** For read-only API endpoints in the `lms-backend` (e.g., `getAllVideos`), returning full Mongoose documents adds significant memory and CPU overhead because Mongoose instantiates large objects with internal state, getters/setters, and change tracking.
**Action:** Always append `.lean()` to Mongoose queries (`find`, `findOne`, `findById`) when the retrieved data is only going to be serialized to JSON and sent to the client, as it returns plain JavaScript objects much faster.

## 2024-05-19 - Mongoose Redundant Queries (Read-before-Write)
**Learning:** In the `lms-backend`, performing a `findById` to check for existence followed by a `findByIdAndUpdate` or `findByIdAndDelete` is an anti-pattern that doubles the number of database roundtrips. Mongoose's `findByIdAndUpdate`/`findByIdAndDelete` methods return `null` if the document is not found, making the initial `findById` completely redundant. Additionally, `.lean()` can be applied to these update/delete operations if the returned document is only going to be serialized to JSON, saving significant memory.
**Action:** Consolidate `findById` + `findByIdAndUpdate`/`findByIdAndDelete` into a single atomic operation and attach `.lean()` whenever the returned document does not need to be saved again or its virtuals accessed. Use `Model.exists()` instead of `Model.findOne()` when only checking for existence (e.g. during user registration).

## 2024-05-20 - Synchronous JWT Verification
**Learning:** In the `lms-backend`, `jwt.verify` was being used synchronously in `authMiddleware.js`. Synchronous execution of CPU-bound cryptographic operations blocks the Node.js single-threaded event loop, preventing the server from handling other incoming requests simultaneously and reducing overall throughput and responsiveness under high concurrency.
**Action:** Always use the asynchronous callback version of `jwt.verify` (and similar CPU-intensive functions like `bcrypt.compare` or `jwt.sign`) in Node.js backends to avoid blocking the event loop.
