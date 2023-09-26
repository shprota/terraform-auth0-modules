function changePassword(email, newPassword, callback) {
    const { Pool } = require('pg');
    const aws = require('aws-sdk');

    const pool = new Pool({
      connectionString: configuration.conString
    });

    async function encrypt(buffer) {
        const kms = new aws.KMS({
            accessKeyId: configuration.accessKeyId,
            secretAccessKey: configuration.secretAccessKey,
            region: configuration.region
        });
        try {
            const params = {
                    KeyId: configuration.kmsKeyId,
                    Plaintext: buffer// The data to encrypt.
            };

            const encryptResult = await kms.encrypt(params).promise();

            if (encryptResult && encryptResult.CiphertextBlob) {
                const encryptedData = encryptResult.CiphertextBlob.toString('base64');

                pool.connect(function (err, client, done) {
                    if (err) return callback(err);

                    const query = 'UPDATE users SET password = $1 WHERE email = $2';
                    client.query(query, [encryptedData, email], function (err, result) {
                        done(); // Release the client back to the pool
                        if (err) {
                            return callback(err, false);
                        }
                        // Check if any rows were updated
                        const rowsUpdated = result ? result.rowCount : 0;
                        return callback(null, rowsUpdated > 0);
                    });
                  });
                return encryptedData;
            } else {
                console.error('Encryption result is missing CiphertextBlob:', encryptResult);
                throw new Error('Encryption result is missing CiphertextBlob');
            }
        } catch (error) {
          console.error('Error encrypting data:', error);
          throw error;
        }
    }
    encrypt(newPassword);
}
