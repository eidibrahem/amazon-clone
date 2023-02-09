const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin"); //not rout yet
const { Product } = require("../models/product");
const Order = require("../models/order");
adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    console.log("eiddddddd");
    const { name, description, images, quantity, price, category } = req.body;
    const userId = 'igg';
    const ratingn = 4;
    const ratingSchema = {
      userId: userId,
      rating: ratingn
    }

    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category,
      ratingSchema,
    });
    product.rating.push(ratingSchema);
    product = await product.save();

    res.json({
      status: true,
      msg: "Product added successfully",
      product,
    });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
adminRouter.get("/admin/get-products", admin, async (req, res) => {
  try {
    const { price, quantity, password } = req.body;
    var products = await Product.find({});

    //res.json({...products });
    res.json({ status: true, msg: "get pros", ...products });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
adminRouter.post("/admin/delet-product", admin, async (req, res) => {
  try {
    const { id } = req.body;
    var product = await Product.findByIdAndDelete(id);
    res.json({ status: true, msg: "deleted successfully", ...product.doc, });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});

adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    let order = await Order.find({});
    res.json({ status: true, msg: "get orders", ...order });
  }
  catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
adminRouter.post("/admin/change-orders-status", admin, async (req, res) => {
  try {
    const { id ,status} = req.body;
    var order = await Order.findById(id);
    order.status=status;
    order = await order.save();
    res.json({ status: true, msg: "updated successfully",  ...order });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {
    let order = await Order.find({});
    let totalEarning =0;
    for(let i=0;i<order.length;i++)
    {
      for(let j=0;j<order[i].products.length;j++)
      {totalEarning+= order[i].products[j].quantity *order[i].products[j].product.price;
       
      }

    }
    let  mobileEarnings=  await fetchCategoryWiseProduct('Mobiles');
    let essentialsEarnings=  await fetchCategoryWiseProduct('Essentials');
    let  appliancesEarnings=  await fetchCategoryWiseProduct('Appliances');
    let   booksEarnings=  await fetchCategoryWiseProduct('Books');
    let  fashionEarnings=  await fetchCategoryWiseProduct('Fashion');
    let  electronicsEarnings=  await fetchCategoryWiseProduct('Electronics');
    let earnings ={
      totalEarning,
      mobileEarnings,
      essentialsEarnings,
       appliancesEarnings,
      booksEarnings,
      fashionEarnings,
      electronicsEarnings,
    }
    res.json({ status: true, msg: "get orders", earnings });
  }
  catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
async function fetchCategoryWiseProduct(category) {
  let earnings =0;
  let  categoryOrders= await Order.find({
    "products.product.category":category,
  });
  
  for(let i=0;i<categoryOrders.length;i++)
  {
    for(let j=0;j<categoryOrders[i].products.length;j++)
    {
      if(categoryOrders[i].products[j].product.category==category )
      earnings+= categoryOrders[i].products[j].quantity *categoryOrders[i].products[j].product.price;
     
    }

  }
  return earnings;
}

module.exports = adminRouter;
