function getByEmail(email, callback) {
    const { Pool } = require('pg');

    const pool = new Pool({
      connectionString: configuration.conString
    });

    const query = 'SELECT id, nickname, email FROM users WHERE email = $1';

    pool.query(query, [email], function (err, result) {
      if (err || result.rows.length === 0) {
        return callback(err || null);
      }

      const user = result.rows[0];
      callback(null, {
        user_id: user.id.toString(),
        nickname: user.nickname,
        email: user.email,
      });
    });
  }
