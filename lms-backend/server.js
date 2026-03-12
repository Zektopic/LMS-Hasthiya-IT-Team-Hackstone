const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
const path = require('path');
const logger = require('./utils/logger');

// Load env vars
dotenv.config();

const app = express();

// Connect to Database
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.DATABASE_URL);
    logger.info('MongoDB Connected...');
  } catch (err) {
    logger.error(err.message);
    // Exit process with failure
    process.exit(1);
  }
};

connectDB();

// Init Middleware
app.use(cors());
app.use(express.json());

// Define Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/videos', require('./routes/videoRoutes'));

// Serve uploaded files statically
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));


// Define a simple root route for testing
app.get('/', (req, res) => res.send('LMS Backend API is running...'));


const PORT = process.env.PORT || 5000;

app.listen(PORT, () => logger.info(`Server started on port ${PORT}`));
