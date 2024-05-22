const sequelize = require("sequelize");

const db = require(__dirname + "/../services/service.js");

const ProductModel = db.then(db => {
    const Product = db.define("products", {
        id: {
            type: sequelize.INTEGER,
            autoIncrement: true,
            primaryKey: true
        },
        name: {
            type: sequelize.STRING,
            allowNull: false
        },
        description: {
            type: sequelize.STRING,
            allowNull: false
        },
        sku: {
            type: sequelize.STRING,
            allowNull: false
        },
        manufacturer: {
            type: sequelize.STRING,
            allowNull: false
        },
        quantity: {
            type: sequelize.INTEGER,
            allowNull: false,
            validate: {
                min: 0,
                max: 100
            }
        },
        owner_user_id: {
            type: sequelize.INTEGER,
            allowNull: false,
            noUpdate: true,
            references: {
                model: 'users',
                key: 'id'
            }
        }
    },
    {
        createdAt: 'date_added',
        updatedAt: 'date_last_updated'
    });

    return Product;
});

module.exports = ProductModel;