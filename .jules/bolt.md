## 2024-05-17 - Missing Mongoose Indexes
**Learning:** The models in `lms-backend` (`User.js` and `Video.js`) have fields that are frequently queried or sorted by (e.g., `email` in User via `findOne`, `createdAt` in Video via `find().sort()`), but they lack explicit database indexes. While Mongoose creates indexes for `unique: true` fields like `email`, adding an explicit index on fields used for sorting, such as `createdAt` in `Video.js`, is a crucial performance optimization. Without it, MongoDB has to scan all documents and perform an in-memory sort, which scales poorly and becomes a bottleneck as the dataset grows.
**Action:** I will add an index to the `createdAt` field in the `Video` model to optimize the `getAllVideos` query which sorts by `createdAt: -1`.

## 2024-05-18 - Mongoose Read-Only Queries
**Learning:** For read-only API endpoints in the `lms-backend` (e.g., `getAllVideos`), returning full Mongoose documents adds significant memory and CPU overhead because Mongoose instantiates large objects with internal state, getters/setters, and change tracking.
**Action:** Always append `.lean()` to Mongoose queries (`find`, `findOne`, `findById`) when the retrieved data is only going to be serialized to JSON and sent to the client, as it returns plain JavaScript objects much faster.
