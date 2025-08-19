const Video = require('../models/Video');
const fs = require('fs');
const path = require('path');

// @desc    Create a new video
// @route   POST /api/videos
// @access  Private (Superadmin)
exports.createVideo = async (req, res) => {
  const { title, description } = req.body;

  if (!req.file) {
    return res.status(400).json({ msg: 'Please upload a video file' });
  }

  const videoUrl = req.file.path;

  try {
    const newVideo = new Video({
      title,
      description,
      videoUrl,
    });

    const video = await newVideo.save();
    res.json(video);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// @desc    Get all videos
// @route   GET /api/videos
// @access  Private (Superadmin)
exports.getAllVideos = async (req, res) => {
  try {
    const videos = await Video.find().sort({ createdAt: -1 });
    res.json(videos);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// @desc    Get single video by ID
// @route   GET /api/videos/:id
// @access  Private (Superadmin)
exports.getVideoById = async (req, res) => {
  try {
    const video = await Video.findById(req.params.id);
    if (!video) {
      return res.status(404).json({ msg: 'Video not found' });
    }
    res.json(video);
  } catch (err) {
    console.error(err.message);
    if (err.kind === 'ObjectId') {
        return res.status(404).json({ msg: 'Video not found' });
    }
    res.status(500).send('Server Error');
  }
};

// @desc    Update a video's metadata
// @route   PUT /api/videos/:id
// @access  Private (Superadmin)
exports.updateVideo = async (req, res) => {
    const { title, description } = req.body;

    // Build video object
    const videoFields = {};
    if (title) videoFields.title = title;
    if (description) videoFields.description = description;

    try {
        let video = await Video.findById(req.params.id);

        if (!video) {
            return res.status(404).json({ msg: 'Video not found' });
        }

        video = await Video.findByIdAndUpdate(
            req.params.id,
            { $set: videoFields },
            { new: true }
        );

        res.json(video);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
};

// @desc    Delete a video
// @route   DELETE /api/videos/:id
// @access  Private (Superadmin)
exports.deleteVideo = async (req, res) => {
    try {
        const video = await Video.findById(req.params.id);

        if (!video) {
            return res.status(404).json({ msg: 'Video not found' });
        }

        // Remove the file from the uploads folder
        fs.unlink(video.videoUrl, (err) => {
            if (err) {
                console.error('Error deleting video file:', err);
                // We can still proceed to delete the DB record, but log the file error
            }
        });

        await Video.findByIdAndDelete(req.params.id);

        res.json({ msg: 'Video removed' });
    } catch (err) {
        console.error(err.message);
        if (err.kind === 'ObjectId') {
            return res.status(404).json({ msg: 'Video not found' });
        }
        res.status(500).send('Server Error');
    }
};
