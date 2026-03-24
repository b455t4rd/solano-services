const pool = require('../db');

async function logEvent({ level = 'info', aktion, ausgeloest_von = null, details = null, ip = null }) {
  try {
    await pool.query(
      'INSERT INTO system_logs (level, aktion, ausgeloest_von, details, ip) VALUES ($1,$2,$3,$4,$5)',
      [level, aktion, ausgeloest_von, details ? JSON.stringify(details) : null, ip]
    );
  } catch (e) {
    console.error('[logger] Fehler beim Schreiben:', e.message);
  }
}

module.exports = { logEvent };
