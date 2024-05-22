const sequelize = require("sequelize");
const AWS = require("aws-sdk");

// var credentials = new AWS.SharedIniFileCredentials({profile: 'new_neo'});
// AWS.config.credentials = credentials;
AWS.config.update({
    region: process.env.REGION
});
const secretsmanager = new AWS.SecretsManager();
async function getDatabaseCredentials(secretId) {
    try {
        const data = await secretsmanager.getSecretValue({ SecretId: secretId }).promise();
        return JSON.parse(data.SecretString);
    } catch (err) {
        console.error('Error retrieving secret:', err);
        throw err;
    }
}

async function connectDB() {
    const credentials = await getDatabaseCredentials(process.env.SECRET_ID);
    // console.log(credentials)
    const db = new sequelize(
        process.env.DATABASE,
        credentials.username,
        credentials.password,
        {
            host: process.env.HOST,
            dialect: 'mysql',
            timezone: '-05:00'
        }
    );

    await db.authenticate().then(() => {
        console.log('Connection has been established successfully.');
    }).catch((error) => {
        console.log('Unable to connect to the database: ', error);
    });

    return db;
}

module.exports = connectDB();