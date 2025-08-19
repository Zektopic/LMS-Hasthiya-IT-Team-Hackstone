const express = require('express');
const router = express.Router();
const {
  createVideo,
  getAllVideos,
  getVideoById,
  updateVideo,
  deleteVideo,
} = require('../controllers/videoController');
const { authMiddleware, isSuperadmin } = require('../middleware/authMiddleware');
const upload = require('../middleware/upload');

// All routes in this file are protected and require a Superadmin role.
// The authMiddleware verifies the token, and isSuperadmin checks the role.
const superadminAuth = [authMiddleware, isSuperadmin];

// @route    POST api/videos
// @desc     Create a video
// @access   Private (Superadmin)
router.post('/', superadminAuth, (req, res) => {
  // Multer middleware is called here to handle the file upload
  // It will add a `file` object to the request if a file is uploaded.
  // It will also handle any errors related to the upload.
  upload(req, res, (err) => {
    if (err) {
      return res.status(400).json({ msg: err });
    }
    // If upload is successful or no file was uploaded, proceed to controller
    createVideo(req, res);
  });
});


// @route    GET api/videos
// @desc     Get all videos
// @access   Private (Superadmin)
router.get('/', superadminAuth, getAllVideos);

// @route    GET api/videos/:id
// @desc     Get video by ID
// @access   Private (Superadmin)
router.get('/:id', superadminAuth, getVideoById);

// @route    PUT api/videos/:id
// @desc     Update a video
// @access   Private (Superadmin)
router.put('/:id', superadminAuth, updateVideo);

// @route    DELETE api/videos/:id
// @desc     Delete a video
// @access   Private (Superadmin)
router.delete('/:id', superadminAuth, deleteVideo);

module.exports = router;
