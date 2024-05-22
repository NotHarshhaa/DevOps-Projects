const AWS = require("aws-sdk");
const uuid = require('uuid');

const validator = require("email-validator");

const get = require(__dirname + "/get.js");
const post = require(__dirname + "/post.js");
const put = require(__dirname + "/put.js");
const del = require(__dirname + "/delete.js");

const saltRounds = 10;

const health = async (req, res) => {
    res.status(200);
    res.send({"Status": 200, "Message": "Server is up and running."});
}

const getUser = async (req, res) => {
   let userId = req.params.userId;
   let auth_header = req.headers.authorization;
   if(!auth_header)
   {
     res.status(401);
     res.send({"Status": 401, "Message": "Please provide an Auth token."});
     return;
   }
   const [user_name, user_pass] = Buffer.from(auth_header.replace('Basic ', ''), 'base64').toString('utf8').replace(':', ',').split(',');
   if(validator.validate(user_name) && user_pass)
   {
         let result = await get.getUserDetails(user_name);
         if(result)
         {
             result = result.dataValues;
              let same = await get.isPasswordSame(user_pass, result);
              if(same === true)
              {
                if(result.id == userId)
                {
                  delete result.password;
                  res.send(result);
                }
                else
                {
                    res.status(403);
                    res.send({"Status": 403, "Message": "You do not have access to view this data."});
                }
              }
              else
              {
                  res.status(401);
                  res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
              }
         }
         else
         {
             res.status(401);
             res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
         }
   }
   else
   {
       res.status(401);
       res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
   }
}

const createUser = async (req, res) => {
   let username = req.body.username;
   let password = req.body.password;
   let first_name = req.body.first_name;
   let last_name = req.body.last_name;
   if(typeof username === "string" && typeof password === "string" && typeof first_name === "string" && typeof last_name === "string" && validator.validate(username))
   {
       let found = false;
       let result = await post.getAllUsers();
       for(let i = 0; i < result.length; i++)
       {
           if(result[i].username === username)
           {
               found = true;
               break;
           }
       }
       if(!found)
       {
           password = await post.hashPassword(password, saltRounds);
           let resp = await post.createNewUser(username, password, first_name, last_name);
           delete resp.dataValues.password;
           res.status(201);
           res.send(resp.dataValues);
       }
       else
       {
         res.status(400);
         res.send({"Status": 400, "Message": "The given Username already exists."});
       }
   }
   else
   {
       res.status(400);
       res.send({"Status": 400, "Message": "Username is not valid or not all the fields given."});
   }
}

const updateUser = async (req, res) => {
  let userId = req.params.userId;
  let password = req.body.password;
  let first_name = req.body.first_name;
  let last_name = req.body.last_name;
  let auth_header = req.headers.authorization;
  let count = Object.keys(req.body).length;

  if(!auth_header)
  {
      res.status(401);
      res.send({"Status": 401, "Message": "Please provide an Auth token."});
      return;
  }

  const [user_name, user_pass] = Buffer.from(auth_header.replace('Basic ', ''), 'base64').toString('utf8').replace(':', ',').split(',');
  if(user_name.trim() == '' && user_pass == '')
  {
      res.status(401);
      res.send({"Status": 401, "Message": "Username or Password is Invalid."});
      return;
  }
  if(typeof password === "string" && typeof first_name === "string" && typeof last_name === "string" && count === 3)
  {
      let response = await get.getUserDetails(user_name);
      if(response)
      {
          response = response.dataValues;
          let same = await get.isPasswordSame(user_pass, response);
          if(same === true)
          {
              if(response.id == userId)
              {
                  password = await post.hashPassword(password, saltRounds);
                  await put.updateUser(password, first_name, last_name, userId);
                  res.status(204);
                  res.send({"Status": 204, "Message": "Updated the user successfully."});
              }
              else
              {
                  res.status(403);
                  res.send({"Status": 403, "Message": "You do not have access to update this user."});
              }
          }
          else
          {
              res.status(401);
              res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
          }
      }
      else
      {
          res.status(401);
          res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
      }
  }
  else
  {
      res.status(400);
      res.send({"Status": 400, "Message": "Request body is invalid."});
  }
}

const getProduct = async (req, res) => {
    let productId = req.params.productId;
    let result = await get.getProductDetails(productId);
    if(result)
    {
        res.status(200);
        res.send(result.dataValues);
    }
    else
    {
        res.status(404);
        res.send({"Status": 404, "Message": "Product with the given Id does not exist."});
    }
}

const createProduct = async (req, res) => {
    let name =  req.body.name;
    let description = req.body.description;
    let sku = req.body.sku;
    let manufacturer = req.body.manufacturer;
    let quantity = req.body.quantity;
    let count = Object.keys(req.body).length;
    let auth_header = req.headers.authorization;

    if(typeof name !== "string" || typeof description !== "string" || typeof sku !== "string" || typeof manufacturer !== "string" || typeof quantity !== "number" || count !== 5)
    {
        res.status(400);
        res.send({"Status": 400, "Message": "Request body is not valid."});
        return;
    }

    sku = sku.trim().toUpperCase();

    if(sku === "")
    {
        res.status(400);
        res.send({"Status": 400, "Message": "SKU is not valid."});
        return;
    }

    if(typeof quantity !== "number" || (quantity - Math.floor(quantity) !== 0))
    {
        res.status(400);
        res.send({"Status": 400, "Message": "Product quantity should be an Integer between 0 and 100."});
        return;
    }

    if(!auth_header)
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Please provide an Auth token."});
        return;
    }

    const [username, password] = Buffer.from(auth_header.replace('Basic ', ''), 'base64').toString('utf8').replace(':', ',').split(',');

    if(validator.validate(username) && password)
    {
        let result = await get.getUserDetails(username);
        if(result)
        {
            result = result.dataValues;
            let same = await get.isPasswordSame(password, result);
            if(same === true)
            {
                let skuExists = await post.skuExists(sku);
                if(skuExists)
                {
                    res.status(400);
                    res.send({"Status": 400, "Message": "The given SKU is already taken."});
                }
                else
                {
                    let resp = await post.createNewProduct(name, description, sku, manufacturer, quantity, result.id, res);
                    res.status(201);
                    res.send(resp.dataValues);
                }
            }
            else
            {
                res.status(401);
                res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
            }
        }
        else
        {
            res.status(401);
            res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
        }
    }
    else
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
    }
}

const updateFullProduct = async (req, res) => {
    let auth_header = req.headers.authorization;
    let productId = req.params.productId;
    let body = req.body;
    let productName = body.name;
    let productDescription = body.description;
    let productSku = body.sku;
    let productManufacturer = body.manufacturer;
    let productQuantity = body.quantity;
    let count = Object.keys(body).length;

    if(typeof productName !== "string" || typeof productDescription !== "string" || typeof productSku != "string" || typeof productManufacturer !== "string" || typeof productQuantity !== "number" || count !== 5)
    {
        res.status(400);
        res.send({"Status": 400, "Message": "Request body is not valid."});
        return;
    }

    body["sku"] = body["sku"].trim().toUpperCase();
    productSku = body.sku;

    if(productSku === "")
    {
        res.status(400);
        res.send({"Status": 400, "Message": "SKU is not valid."});
        return;
    }

    if(typeof productQuantity !== "number" || (productQuantity - Math.floor(productQuantity) !== 0))
    {
        res.status(400);
        res.send({"Status": 400, "Message": "Product quantity should be an Integer between 0 and 100."});
        return;
    }

    if(!auth_header)
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Please provide an Auth token."});
        return;
    }

    const [user_name, user_pass] = Buffer.from(auth_header.replace('Basic ', ''), 'base64').toString('utf8').replace(':', ',').split(',');

    if(user_name.trim() == '' && user_pass == '')
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Invalid."});
        return;
    }
    let response = await get.getUserDetails(user_name);
    if(response)
    {
        response = response.dataValues;
        let same = await get.isPasswordSame(user_pass, response);
        if(same === true)
        {
                let productExist = await del.productExists(productId);
                if(productExist)
                {
                    let userProduct = await del.isUserProduct(productId, response.id);
                    if(userProduct)
                    {
                        let skuExists = await put.skuExists(productSku, productId);
                        if(skuExists)
                        {
                            res.status(400);
                            res.send({"Status": 400, "Message": "The given SKU is already taken."});
                            return;
                        }
                        else
                        {
                            await put.updateProduct(body, productId, res);
                            res.status(204);
                            res.send({"Status": 204, "Message": "Updated the product successfully."});
                        }
                    }
                    else
                    {
                        res.status(403);
                        res.send({"Status": 403, "Message": "User doesn't have access rights to update this product."});
                    }
                }
                else
                {
                    res.status(404);
                    res.send({"Status": 404, "Message": "Product with the given Id does not exist."});
                }
        }
        else
        {
            res.status(401);
            res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
        }
    }
    else
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
    }
}

const updateProduct = async(req, res) => {
    let auth_header = req.headers.authorization;
    let productId = req.params.productId;
    let updateOptions = {"name":"", "description":"", "sku":"", "manufacturer":"", "quantity":""};
    let body = req.body;
    let count = Object.keys(body).length;
    if(count < 1)
    {
        res.status(400);
        res.send({"Status": 400, "Message": "Request body is not valid."});
        return;
    }
    if(body.hasOwnProperty("name"))
    {
        if(typeof body["name"] !== "string")
        {
            res.status(400);
            res.send({"Status": 400, "Message": "name is Invalid."});
            return;
        }
    }
    if(body.hasOwnProperty("description"))
    {
        if(typeof body["description"] !== "string")
        {
            res.status(400);
            res.send({"Status": 400, "Message": "description is Invalid."});
            return;
        }
    }
    if(body.hasOwnProperty("manufacturer"))
    {
        if(typeof body["manufacturer"] !== "string")
        {
            res.status(400);
            res.send({"Status": 400, "Message": "manufacturer is Invalid."});
            return;
        }
    }
    if(body.hasOwnProperty("sku"))
    {
        if(typeof body["sku"] === "string" && body["sku"].trim() !== "")
        {
            body["sku"] = body["sku"].trim().toUpperCase();
        }
        else
        {
            res.status(400);
            res.send({"Status": 400, "Message": "SKU is Invalid."});
            return;
        }
    }
    let sku = body.sku;

    if(body.hasOwnProperty("quantity"))
    {
        if(typeof body["quantity"] !== "number" || (body["quantity"] - Math.floor(body["quantity"]) !== 0))
        {
            res.status(400);
            res.send({"Status": 400, "Message": "Product quantity should be an Integer between 0 and 100."});
            return;
        }
    }

    for(let i in body)
    {
        if(!updateOptions.hasOwnProperty(i))
        {
            res.status(400);
            res.send({"Status": 400, "Message": "Request body consists of unidentified fields."});
            return;
        }
    }

    if(!auth_header)
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Please provide an Auth token."});
        return;
    }

    const [user_name, user_pass] = Buffer.from(auth_header.replace('Basic ', ''), 'base64').toString('utf8').replace(':', ',').split(',');
    if(user_name.trim() == '' && user_pass == '')
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Invalid."});
        return;
    }
    let response = await get.getUserDetails(user_name);
    if(response)
    {
        response = response.dataValues;
        let same = await get.isPasswordSame(user_pass, response);
        if(same === true)
        {
            let productExist = await del.productExists(productId);
            if(productExist)
            {
                let userProduct = await del.isUserProduct(productId, response.id);
                if(userProduct)
                {
                    if(sku)
                    {
                        let skuExists = await put.skuExists(sku, productId);
                        if(skuExists)
                        {
                            res.status(400);
                            res.send({"Status": 400, "Message": "The given SKU is already taken."});
                            return;
                        }
                    }
                    await put.updateProduct(body, productId, res);
                    res.status(204);
                    res.send({"Status": 204, "Message": "Updated the product successfully."});
                }
                else
                {
                    res.status(403);
                    res.send({"Status": 403, "Message": "User doesn't have access rights to update this product."});
                }
            }
            else
            {
                res.status(404);
                res.send({"Status": 404, "Message": "Product with the given Id does not exist."});
            }
        }
        else
        {
            res.status(401);
            res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
        }
    }
    else
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
    }
}

const deleteProduct = async (req, res) => {
    let productId = req.params.productId;
    let auth_header = req.headers.authorization;

    if(!auth_header)
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Please provide an Auth token."});
        return;
    }

    const [user_name, user_pass] = Buffer.from(auth_header.replace('Basic ', ''), 'base64').toString('utf8').replace(':', ',').split(',');
    if(user_name.trim() == '' && user_pass == '')
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Invalid."});
        return;
    }

    let response = await get.getUserDetails(user_name);
    if(response)
    {
        response = response.dataValues;
        let same = await get.isPasswordSame(user_pass, response);
        if(same === true)
        {
            let productExist = await del.productExists(productId);
            if(productExist)
            {
                let userProduct = await del.isUserProduct(productId, response.id);
                if(userProduct)
                {
                    let productImages = await get.getProductImages(productId);
                    for(let image of productImages)
                        await deleteImage(image.s3_bucket_path);
                    await del.deleteProductImages(productId);
                    await del.deleteProduct(productId);
                    res.status(204);
                    res.send({"Status": 204, "Message": "Deleted the product successfully."});
                }
                else
                {
                    res.status(403);
                    res.send({"Status": 403, "Message": "User doesn't have access rights to delete this product."});
                }
            }
            else
            {
                res.status(404);
                res.send({"Status": 404, "Message": "Product with the given Id does not exist."});
            }
        }
        else
        {
            res.status(401);
            res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
        }
    }
    else
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
    }
}

const getProductImages = async (req, res) => {
    let productId = req.params.product_id;
    let auth_header = req.headers.authorization;
    if(!auth_header)
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Please provide an Auth token."});
        return;
    }
    const [username, password] = Buffer.from(auth_header.replace('Basic ', ''), 'base64').toString('utf8').replace(':', ',').split(',');
    if(username.trim() == '' && password == '')
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Invalid."});
        return;
    }
    let response = await get.getUserDetails(username);
    if(response)
    {
        response = response.dataValues;
        let same = await get.isPasswordSame(password, response);
        if(same === true)
        {
            let productExist = await del.productExists(productId);
            if(productExist)
            {
                let userProduct = await del.isUserProduct(productId, response.id);
                if(userProduct)
                {
                    let response = await get.getProductImages(productId);
                    res.status(200);
                    res.send(response);
                }
                else
                {
                    res.status(403);
                    res.send({"Status": 403, "Message": "User doesn't have access rights to view this product images."});
                }
            }
            else
            {
                res.status(404);
                res.send({"Status": 404, "Message": "Product with the given Id does not exist."});
            }
        }
        else
        {
            res.status(401);
            res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
        }
    }
    else
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
    }
}

const getProductImage = async (req, res) => {
    let productId = req.params.product_id;
    let imageId = req.params.image_id;
    let auth_header = req.headers.authorization;
    if(!auth_header)
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Please provide an Auth token."});
        return;
    }
    const [username, password] = Buffer.from(auth_header.replace('Basic ', ''), 'base64').toString('utf8').replace(':', ',').split(',');
    if(username.trim() == '' && password == '')
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Invalid."});
        return;
    }
    let response = await get.getUserDetails(username);
    if(response)
    {
        response = response.dataValues;
        let same = await get.isPasswordSame(password, response);
        if(same === true)
        {
            let productExist = await del.productExists(productId);
            if(productExist)
            {
                let userProduct = await del.isUserProduct(productId, response.id);
                if(userProduct)
                {                    
                    let imageExists = await get.getProductImage(imageId);
                    if(imageExists)
                    {
                        if(productId == imageExists.product_id)
                        {
                            res.status(200);
                            res.send(imageExists);
                        }
                        else 
                        {
                            res.status(404);
                            res.send({"Status": 404, "Message": "Image not found for the given product."});
                        }                        
                    }
                    else 
                    {
                        res.status(404);
                        res.send({"Status": 404, "Message": "Image with the given Id does not exist."});
                    }                    
                }
                else
                {
                    res.status(403);
                    res.send({"Status": 403, "Message": "User doesn't have access to view this product's images."});
                }
            }
            else
            {
                res.status(404);
                res.send({"Status": 404, "Message": "Product with the given Id does not exist."});
            }
        }
        else
        {
            res.status(401);
            res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
        }
    }
    else
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
    }
}

function uploadImage(image)
{
    return new Promise(async (resolve, reject) => {
        AWS.config.update({
            region: process.env.REGION
        });
        const s3 = new AWS.S3();
        const fileContent = Buffer.from(image.data, 'binary');
        const params = {
            Bucket: process.env.S3_BUCKET,
            Key: uuid.v4() + "/" + image.name,
            Body: fileContent
        }
        s3.upload(params, (err, data) => {
            if(err)
            {
                reject(err);
            }
            else 
            {
                resolve(data);
            }
        });
    });    
}

const uploadProductImage = async (req, res) => {
    let productId = req.params.product_id;
    let auth_header = req.headers.authorization;
    if(!auth_header)
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Please provide an Auth token."});
        return;
    }
    const [username, password] = Buffer.from(auth_header.replace('Basic ', ''), 'base64').toString('utf8').replace(':', ',').split(',');
    if(username.trim() == '' && password == '')
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Invalid."});
        return;
    }
    let response = await get.getUserDetails(username);
    if(response)
    {
        response = response.dataValues;
        let same = await get.isPasswordSame(password, response);
        if(same === true)
        {
            let productExist = await del.productExists(productId);
            if(productExist)
            {
                let userProduct = await del.isUserProduct(productId, response.id);
                if(userProduct)
                {
                    if(req.files)
                    {
                        if(req.files.image)
                        {
                            let isObject = function(a) {
                                return (!!a) && (a.constructor === Object);
                            };
                            if(isObject(req.files.image))
                            {
                                if(req.files.image.mimetype !== 'image/jpeg' && req.files.image.mimetype !== 'image/jpg' && req.files.image.mimetype !== 'image/png')
                                {
                                    res.status(400);
                                    res.send({"Status": 400, "Message": "Only the file formats JPG, JPEG and PNG are allowed."});
                                    return;
                                }
                                else
                                {
                                    let data = await uploadImage(req.files.image);
                                    let resp = await post.createNewProductImage(productId, req.files.image.name, data.key);
                                    res.status(201);
                                    res.send(resp.dataValues);
                                }                
                            }
                            else
                            {
                                res.status(400);
                                res.send({"Status": 400, "Message": "Only one Image can be uploaded."});
                                return;
                            }                            
                        }
                        else 
                        {
                            res.status(400);
                            res.send({"Status": 400, "Message": "Please upload at least one image by using image key."});
                        }     
                    }
                    else 
                    {
                        res.status(400);
                        res.send({"Status": 400, "Message": "Please upload at least one image."});
                    }
                }
                else
                {
                    res.status(403);
                    res.send({"Status": 403, "Message": "User doesn't have access to upload an image for this product."});
                }
            }
            else
            {
                res.status(404);
                res.send({"Status": 404, "Message": "Product with the given Id does not exist."});
            }
        }
        else
        {
            res.status(401);
            res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
        }
    }
    else
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
    }
}

function deleteImage(key)
{
    return new Promise(async (resolve, reject) => {
        AWS.config.update({
            region: process.env.REGION
        });
        var s3 = new AWS.S3();
        var params = {  Bucket: process.env.S3_BUCKET, Key: key };

        s3.deleteObject(params, function(err, data) {
        if (err)
        {
            reject(err);            
        }            
        else     
            resolve();
        });
    });
}

const deleteProductImage = async (req, res) => {
    let productId = req.params.product_id;
    let imageId = req.params.image_id;
    let auth_header = req.headers.authorization;
    if(!auth_header)
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Please provide an Auth token."});
        return;
    }
    const [username, password] = Buffer.from(auth_header.replace('Basic ', ''), 'base64').toString('utf8').replace(':', ',').split(',');
    if(username.trim() == '' && password == '')
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Invalid."});
        return;
    }
    let response = await get.getUserDetails(username);
    if(response)
    {
        response = response.dataValues;
        let same = await get.isPasswordSame(password, response);
        if(same === true)
        {
            let productExist = await del.productExists(productId);
            if(productExist)
            {
                let userProduct = await del.isUserProduct(productId, response.id);
                if(userProduct)
                {                    
                    let imageExists = await get.getProductImage(imageId);
                    if(imageExists)
                    {
                        if(productId == imageExists.product_id)
                        {
                            await del.deleteProductImage(imageId);
                            await deleteImage(imageExists.s3_bucket_path);
                            res.sendStatus(204);
                        }
                        else 
                        {
                            res.status(404);
                            res.send({"Status": 404, "Message": "Image not found for the given product."});
                        }                        
                    }
                    else 
                    {
                        res.status(404);
                        res.send({"Status": 404, "Message": "Image with the given Id does not exist."});
                    }                    
                }
                else
                {
                    res.status(403);
                    res.send({"Status": 403, "Message": "User doesn't have access rights to delete this product's images."});
                }
            }
            else
            {
                res.status(404);
                res.send({"Status": 404, "Message": "Product with the given Id does not exist."});
            }
        }
        else
        {
            res.status(401);
            res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
        }
    }
    else
    {
        res.status(401);
        res.send({"Status": 401, "Message": "Username or Password is Incorrect."});
    }
}

module.exports = {
    health,
    getUser,
    createUser,
    updateUser,
    getProduct,
    createProduct,
    updateFullProduct,
    updateProduct,
    deleteProduct,
    getProductImages,
    getProductImage,
    uploadProductImage,
    deleteProductImage
};