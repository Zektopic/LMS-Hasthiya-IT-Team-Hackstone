const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// @desc    Register a new user (for initial Superadmin setup)
// @route   POST /api/auth/register
// @access  Public
exports.register = async (req, res) => {
  const { email, password, role } = req.body;

  try {
    // ⚡ Bolt: Used User.exists() instead of User.findOne() for existence check.
    // This is faster because it only returns a boolean/objectId, saving memory
    // and network bandwidth by not loading the full user document.
    const userExists = await User.exists({ email });

    if (userExists) {
      return res.status(400).json({ msg: 'User already exists' });
    }

    const user = new User({
      email,
      password,
      role: role || 'Superadmin', // Default to Superadmin if not provided
    });

    await user.save();

    const payload = {
      user: {
        id: user.id,
        role: user.role,
      },
    };

    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: '5h' },
      (err, token) => {
        if (err) throw err;
        res.json({ token });
      }
    );
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};

// @desc    Authenticate user & get token
// @route   POST /api/auth/login
// @access  Public
exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    // ⚡ Bolt: Added .lean() to return a plain JS object since we only need
    // the document for read-only comparisons and payload generation.
    const user = await User.findOne({ email }).lean();

    if (!user) {
      return res.status(400).json({ msg: 'Invalid Credentials' });
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ msg: 'Invalid Credentials' });
    }

    const payload = {
      user: {
        // When using .lean(), we must access the raw _id since the virtual id getter is absent
        id: user._id,
        role: user.role,
      },
    };

    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: '5h' },
      (err, token) => {
        if (err) throw err;
        res.json({ token });
      }
    );
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};
