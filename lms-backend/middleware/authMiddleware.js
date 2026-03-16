const jwt = require('jsonwebtoken');

function authMiddleware(req, res, next) {
  // Get token from header
  const token = req.header('x-auth-token');

  // Check if not token
  if (!token) {
    return res.status(401).json({ msg: 'No token, authorization denied' });
  }

  // Verify token
  // ⚡ Bolt: Using asynchronous jwt.verify with a callback instead of the synchronous version
  // to avoid blocking the Node.js event loop during CPU-intensive cryptographic operations,
  // thereby improving throughput and responsiveness under high concurrency.
  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      console.error(err.message);
      return res.status(401).json({ msg: 'Token is not valid' });
    }
    req.user = decoded.user;
    next();
  });
}

function isSuperadmin(req, res, next) {
    if (req.user && req.user.role === 'Superadmin') {
        next();
    } else {
        res.status(403).json({ msg: 'Access denied. Superadmin role required.' });
    }
}

module.exports = { authMiddleware, isSuperadmin };
