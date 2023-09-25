function verify(email, callback) {
  const { Pool } = require('pg');

  const pool = new Pool({
    connectionString: configuration.conString 
  });

  pool.connect(function (err, client, done) {
    if (err) return callback(err);

    const query = 'UPDATE users SET email_verified = true WHERE email_verified = false AND email = $1';
    client.query(query, [email], function (err, result) {
      done(); // Release the client back to the pool

      if (err) {
        return callback(err, false);
      }

      // Check if any rows were updated
      const rowsUpdated = result ? result.rowCount : 0;
      return callback(null, rowsUpdated > 0);
    });
  });
}