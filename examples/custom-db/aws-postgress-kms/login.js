function login(email, password, callback) {
    const aws = require('aws-sdk');
    const postgres = require('pg');

    const pool = new Pool({
      connectionString: configuration.conString
    });

    pool.connect(function (err, client, done) {
      if (err) return callback(err);

      const query = 'SELECT id, nickname, email, password FROM users WHERE email = $1';
      client.query(query, [email], function (err, result) {
        // Release the client back to the pool
        done();

        if (err || result.rows.length === 0) {
          return callback(err || new WrongUsernameOrPasswordError(email));
        }

        const user = result.rows[0];
        decrypt(user,password);
      });
    });

    async function decrypt(user,i_password) {
      const kms = new aws.KMS({
        accessKeyId: configuration.accessKeyId,
        secretAccessKey: configuration.secretAccessKey,
        region: configuration.region
      });
      try {
          const params = {
            CiphertextBlob: Buffer.from(user.password, 'base64'),
          };
          const { Plaintext } = await kms.decrypt(params).promise();
          openedData = Plaintext.toString();

          if (openedData !== i_password) {
            return callback(new WrongUsernameOrPasswordError(email));
          } else {
              return callback(null, {
                user_id: user.id,
                nickname: user.nickname,
                email: user.email
              });
          }
      } catch (error) {
        console.error('Error decrypting data:', error);
        throw error;
      }
    }
}
