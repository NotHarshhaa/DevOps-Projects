const User = require(__dirname + "/../models/User.js");
const Product = require(__dirname + "/../models/Product.js");
const ProductImage = require(__dirname + "/../models/ProductImage.js");
const bcrypt = require("bcryptjs");

exports.getUserDetails = function(user_name){
    return new Promise(async (resolve, reject) => {
        const userModel = await User;
        userModel.findOne({
            where: {
                username : user_name
            }
        }).then(res => {
            resolve(res);
        }).catch((error) => {
            reject(console.error('Failed to retrieve data : ', error));
        });
    });
};

exports.isPasswordSame = function(user_pass, result){
    return new Promise((resolve, reject) => {
        bcrypt.compare(user_pass, result.password, function(err, same){
            if(err)
            {
                reject(err);
            }
            else
            {
                resolve(same);
            }
        });
    });
};

exports.getProductDetails = function(productId){
    return new Promise(async (resolve, reject) => {
        const productModel = await Product;
        productModel.findOne({
            where: {
                id : productId
            }
        }).then(res => {
            resolve(res);
        }).catch((error) => {
            reject(console.error('Failed to retrieve data : ', error));
        });
    });
};

exports.getProductImages = function(productId){
    return new Promise(async (resolve, reject) => {
        const productImageModel = await ProductImage;
        productImageModel.findAll({
            where: {
                product_id : productId
            }
        }).then(res => {
            resolve(res);
        }).catch((error) => {
            reject(console.error('Failed to retrieve data : ', error));
        });
    });
};

exports.getProductImage = function(imageId){
    return new Promise(async (resolve, reject) => {
        const productImageModel = await ProductImage;
        productImageModel.findOne({
            where: {
                image_id : imageId
            }
        }).then(res => {
            resolve(res);
        }).catch((error) => {
            reject(console.error('Failed to retrieve data : ', error));
        });
    });
};