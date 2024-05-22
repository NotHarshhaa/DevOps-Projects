const sequelize = require("sequelize");

const db = require(__dirname + "/../services/service.js");

const ProductImageModel = db.then(db => {
    const Image = db.define("images", {
        image_id: {
            type: sequelize.INTEGER,
            autoIncrement: true,
            primaryKey: true
        },
        product_id: {
            type: sequelize.INTEGER,
            allowNull: false,
            noUpdate: true,
            references: {
                model: 'products',
                key: 'id'
            }
        },
        file_name: {
            type: sequelize.STRING,
            allowNull: false
        },
        s3_bucket_path: {
            type: sequelize.STRING,
            allowNull: false
        }},
        {
        createdAt: 'date_created',
        updatedAt: false
    });

    return Image;
});

module.exports = ProductImageModel;