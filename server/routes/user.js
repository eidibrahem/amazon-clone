const express = require("express");
const auth = require("../middlewares/auth");
const userRouter = express.Router();
const User = require("../models/user");
const { Product } = require("../models/product");
const Order = require("../models/order");
userRouter.post("/api/add-to-cart", async (req, res) => {
  try {
    const { id, userId } = req.body;
    var product = await Product.findById(id);
    let user = await User.findById(userId);

    if (user.cart.length == 0) {
      user.cart.push({
        product,
        quantity: 1,
      });
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }
      if (isProductFound) {
        let producttt = user.cart.find((productt) =>
          productt.product._id.equals(product._id)
        );
        producttt.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 });
      }
    }
    user = await user.save();
    res.json({
      status: true,
      message: "Signin with the Email successfully",
      user: {
        token: user.token,
        _id: user._id,
        name: user.name,
        email: user.email,
        address: user.address,
        type: user.type,
        cart: user.cart,
        __v: user.__v,
      },
    });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
userRouter.post("/api/get-user-data", async (req, res) => {
  try {
    const { userId } = req.body;
    let user = await User.findById(userId);
    res.json({
      status: true,
      message: "Signin with the Email successfully",
      user: {
        token: user.token,
        _id: user._id,
        name: user.name,
        email: user.email,
        address: user.address,
        type: user.type,
        cart: user.cart,
        __v: user.__v,
      },
    });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
userRouter.post("/api/remove-from-cart", async (req, res) => {
  try {
    const { id, userId } = req.body;
    var product = await Product.findById(id);
    let user = await User.findById(userId);
    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        if (user.cart[i].quantity == 1) {
          user.cart.splice(i, 1);
        } else {
          user.cart[i].quantity -= 1;
        }
      }
    }
    user = await user.save();
    res.json({
      status: true,
      message: "Signin with the Email successfully",
      user: {
        token: user.token,
        _id: user._id,
        name: user.name,
        email: user.email,
        address: user.address,
        type: user.type,
        cart: user.cart,
        __v: user.__v,
      },
    });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
userRouter.post("/api/save-user-address", auth, async (req, res) => {
  try {
    const { address } = req.body;
    var user = await User.findById(req.user);
    user.address = address;
    user = await user.save();
    res.json({
      status: true,
      message: "Signin with the Email successfully",
      user: {
        token: user.token,
        _id: user._id,
        name: user.name,
        email: user.email,
        address: user.address,
        type: user.type,
        cart: user.cart,
        __v: user.__v,
      },
    });
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});

userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address } = req.body;
    let products = [];
    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i]['product']['id']);
      console.log(cart[i]['quantity']);
      if (product.quantity >= cart[i]['quantity']) {
        product.quantity -= cart[i]['quantity'];
        products.push({ product, quantity: cart[i]['quantity'] });
        product.save();
      } else {
        return res.json({ msg: `${product.name} is out of stock! ` });
      }
    }
    let user = await User.findById(req.user);
    user.cart = [];
    user = await user.save();
    let order = new Order({
      products,
      totalPrice,
      address,
      userId: req.user,
      orderdAt: new Date().getTime(),
    })
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.json({ status: false, msg: e.message });
  }
});
userRouter.get("/api/orders/me", auth, async (req, res) => {
  try {
    let order = await Order.find({ userId: req.user });
    res.json({ status: true, msg: "get orders", ...order });
  }
  catch (e) {
    res.json({ status: false, msg: e.message });
  }
});

module.exports = userRouter;
//"api/orders/me"