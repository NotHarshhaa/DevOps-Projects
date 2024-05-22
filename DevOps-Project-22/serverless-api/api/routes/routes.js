const express = require('express');
const router = express.Router();

const { 
    health, 
    getUser, 
    getProduct, 
    getProductImages, 
    getProductImage, 
    createUser, 
    createProduct, 
    uploadProductImage,
    updateUser, 
    updateFullProduct, 
    updateProduct, 
    deleteProduct, 
    deleteProductImage 
} = require('../controllers/controller');

router.get("/healthz", health);

router.get("/user/:userId", getUser);

router.get("/product/:productId", getProduct);

router.get("/product/:product_id/image", getProductImages);

router.get("/product/:product_id/image/:image_id", getProductImage);

router.post("/user", createUser);

router.post("/product", createProduct);

router.post("/product/:product_id/image", uploadProductImage);

router.put("/user/:userId", updateUser);

router.put("/product/:productId", updateFullProduct);

router.patch("/product/:productId", updateProduct);

router.delete("/product/:productId", deleteProduct);

router.delete("/product/:product_id/image/:image_id", deleteProductImage);

router.all("/healthz", (req, res) => { res.sendStatus(405); });

router.all("/user", (req, res) => { res.sendStatus(405); });

router.all("/user/:userId", (req, res) => { res.sendStatus(405); });

router.all("/product", (req, res) => { res.sendStatus(405); });

router.all("/product/:productId", (req, res) => { res.sendStatus(405); });

router.all("/product/:product_id/image", (req, res) => { res.sendStatus(405); });

router.all("/product/:product_id/image/:image_id", (req, res) => { res.sendStatus(405); });

router.all("*", (req, res) => { res.sendStatus(404); })

module.exports = router;