const express = require("express");
const productRouter = express.Router();
const {Product} = require("../models/product");
const auth = require("../middlewares/auth");
productRouter.get("/api/products",auth, async (req, res) => {
  try {
    var products = await Product.find({ category: req.query.category });
    //res.json({...products });
    res.json({ status: true, msg: "get pros", ...products });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
productRouter.get("/api/products/search/:name",auth, async (req, res) => {
  try {
    var products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });
    //res.json({...products });
    res.json({ status: true, msg: "search pros", ...products });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});

productRouter.post("/api/rate-product",auth, async (req, res) => {
  try {
    const { id, rating, userId } = req.body;
    var product = await Product.findById(id);
    for (let i = 0; i < product.rating.length; i++) {
      if (product.rating[i].userId == userId) {
        product.rating.splice(i, 1);
        break;
      }
    }
    const ratingSchema = {
      userId: userId,
      rating: rating,
    };
    product.rating.push(ratingSchema);
    product = await product.save();
    res.json({ status: true, msg: "search pros", ...product });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
productRouter.get("/api/deal-of-day",auth, async (req, res) => {
  try {
    var products = await Product.find({});
    products= products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;
      for (let i = 0; i <a.rating.length; i++) {
          aSum+=a.rating[i].rating
      }
      for (let i = 0; i <b.rating.length; i++) {
        bSum+=b.rating[i].rating
    }
    return aSum<bSum ?1:-1;
    });
    res.json({ status: true, msg: "deal of day", ...products[0]._doc });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
module.exports = productRouter;
