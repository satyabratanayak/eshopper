const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");

productRouter.get("/api/products/", auth, async (req, res) => {
  try {
    const products = await Product.find({ category: req.query.category });
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

productRouter.get("/api/productall/", auth, async (req, res) => {
  try {
    const products = await Product.find();
    console.log('products', products);
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// create a get request to search products and get them
// /api/products/search/i
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });

    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// create a post request route to rate the product.
productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);

    for (let i = 0; i < product.ratings.length; i++) {
      if (product.ratings[i].userId == req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }

    const ratingSchema = {
      userId: req.user,
      rating,
    };

    product.ratings.push(ratingSchema);
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


productRouter.get("/api/deal-of-day", auth, async (req, res) => {
  try {
    let products = await Product.find({});

    products = products.filter((product) => {
      if (!product.mrp || !product.price) return false;
      const discountPercent = 100 - ((product.price / product.mrp) * 100);
      return discountPercent >= 30;
    });

    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


module.exports = productRouter;
