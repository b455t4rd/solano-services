const pool = require('./db');
pool.query("SELECT * FROM projekt_auftraege WHERE status='abgeschlossen' ORDER BY id DESC LIMIT 2")
    .then(r => {
        console.log(JSON.stringify(r.rows, null, 2));
        process.exit(0);
    }).catch(e => console.error(e));
