const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'solano-winterdienst-geheim';

function authMiddleware(req, res, next) {
  const auth = req.headers.authorization;
  if (!auth || !auth.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Nicht angemeldet' });
  }
  try {
    req.user = jwt.verify(auth.slice(7), JWT_SECRET);
    next();
  } catch {
    res.status(401).json({ error: 'Sitzung abgelaufen – bitte neu anmelden' });
  }
}

// Admin UND Chef: Zugriff auf Verwaltungsfunktionen
function managerMiddleware(req, res, next) {
  authMiddleware(req, res, () => {
    if (!req.user.ist_admin && !req.user.ist_chef) {
      return res.status(403).json({ error: 'Kein Zugriff (Admin oder Chef erforderlich)' });
    }
    next();
  });
}

// Nur Admin: für sensible Funktionen (Push-Log, etc.)
function adminMiddleware(req, res, next) {
  authMiddleware(req, res, () => {
    if (!req.user.ist_admin) {
      return res.status(403).json({ error: 'Kein Zugriff (Admin erforderlich)' });
    }
    next();
  });
}

module.exports = { authMiddleware, adminMiddleware, managerMiddleware, JWT_SECRET };
