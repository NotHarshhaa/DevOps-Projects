require('dotenv').config();
const db = require(__dirname + "/api/services/service.js");
const bodyParser = require("body-parser");
const express = require("express");
const upload = require("express-fileupload");
const serverless = require("serverless-http");
const app = express();
const router = require(__dirname + "/api/routes/routes.js");

app.use(bodyParser.json());

app.use(upload());

app.use('/', router);

db.then(db => {
    db.sync().then(() => {
        console.log('Tables are created successfully!');
    }).catch((error) => {
        console.log('Unable to create tables : ', error);
    });
    return db;
});

if(process.env.ENVIRONMENT == "lambda")
{
    module.exports.handler = serverless(app);
}
else 
{
    app.listen(3000, () => {
        console.log("Server started on port:3000");
    });
}