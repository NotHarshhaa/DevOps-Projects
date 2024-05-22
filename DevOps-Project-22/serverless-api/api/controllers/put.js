const User = require(__dirname + "/../models/User.js");
const Product = require(__dirname + "/../models/Product.js");
const Op = require('sequelize').Op;

exports.updateUser = function(password, first_name, last_name, userId) {
    return new Promise(async (resolve, reject) => {
        const userModel = await User;
        userModel.update(
            {
                password: password,
                first_name: first_name,
                last_name: last_name
            },
            { where: { id: userId } }
        ).then(res => {
                resolve(res);
            }).catch((error) => {
            reject(console.error('Failed to update the user : ', error));
        });
    });
};

exports.skuExists = function(sku, id)
{
    return new Promise(async (resolve, reject) => {
        const productModel = await Product;
        productModel.findOne(
            {
                where:
                    {
                        sku: sku,
                        id: {[Op.ne]: id}
                    }
            }
        ).then(res => {
            resolve(res);
        }).catch((error) => {
            reject(console.error('Failed to search for sku : ', error));
        });
    });
};

exports.updateProduct = function(updateSchema, productId, res) {
    return new Promise(async (resolve, reject) => {
        const productModel = await Product;
        productModel.update(
            updateSchema,
            { where: { id: productId } }
        ).then(res => {
            resolve(res);
        }).catch((error) => {
            res.status(400);
            res.send({"Status": 400, "Message": "Request body fields / quantity is invalid."});
        });
    });
};