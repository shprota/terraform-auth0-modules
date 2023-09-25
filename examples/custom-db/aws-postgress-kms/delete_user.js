function remove(id, callback) {
    const { Pool } = require('pg');

    const pool = new Pool({
      connectionString: configuration.conString
    });

    pool.connect(function (err, client, done) {
      if (err) return callback(err);

      const query = 'DELETE FROM users WHERE id = $1';
      client.query(query, [id], function (err) {
        done(); // Release the client back to the pool

        return callback(err);
      });
    });
  }
