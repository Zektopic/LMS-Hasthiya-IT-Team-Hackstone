const jwt = require('jsonwebtoken');

function authMiddleware(req, res, next) {
  // Get token from header
  const token = req.header('x-auth-token');

  // Check if not token
  if (!token) {
    return res.status(401).json({ msg: 'No token, authorization denied' });
  }

  // Verify token
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded.user;
    next();
  } catch (err) {
    res.status(401).json({ msg: 'Token is not valid' });
  }
}

function isSuperadmin(req, res, next) {
    if (req.user && req.user.role === 'Superadmin') {
        next();
    } else {
        res.status(403).json({ msg: 'Access denied. Superadmin role required.' });
    }
}

module.exports = { authMiddleware, isSuperadmin };
