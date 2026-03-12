const mongoose = require('mongoose');

const VideoSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    required: true,
    trim: true,
  },
  videoUrl: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
    index: -1, // ⚡ Bolt: Added descending index to optimize sorting in getAllVideos
  },
});

module.exports = mongoose.model('Video', VideoSchema);
