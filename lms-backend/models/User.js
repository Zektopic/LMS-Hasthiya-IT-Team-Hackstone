const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const UserSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true,
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
    validate: {
      validator: function (v) {
        // Only validate password if it's new or being modified
        if (!this.isModified('password')) {
          return true;
        }
        // Enforce: min 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 special character.
        // Allowing all characters but requiring at least one of each category.
        return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&./#()\[\]{}\-_=+^|~:;,<>\\]).{8,}$/.test(
          v
        );
      },
      message: (props) =>
        'Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character.',
    },
  },
  role: {
    type: String,
    enum: ['Superadmin'],
    default: 'Superadmin',
  },
});

// Hash password before saving
UserSchema.pre('save', async function (next) {
  if (!this.isModified('password')) {
    return next();
  }

  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (err) {
    next(err);
  }
});

module.exports = mongoose.model('User', UserSchema);
