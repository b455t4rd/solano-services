const { Pool, types } = require('pg');

// DATE (OID 1082) als reinen String zurückgeben – verhindert UTC-Verschiebung
// durch toISOString() bei europäischen Zeitzonen (z.B. Vienna UTC+1)
types.setTypeParser(1082, val => val);

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'winterdienst',
  user: process.env.DB_USER || process.env.USER,
  password: process.env.DB_PASSWORD || '',
});

pool.on('error', (err) => {
  console.error('Datenbankfehler:', err);
});

module.exports = pool;
