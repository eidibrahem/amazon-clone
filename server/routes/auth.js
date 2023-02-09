const express = require("express");
const Joi = require("joi");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const mongoose = require("mongoose");
const authRouter = express.Router();
const jwt =require("jsonwebtoken");

authRouter.get("/eid", (req, res) => {
  res.json({ mas: "eid exists !" });
});
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.json({ status: false, message: "email is already exists !" });
    }

    const erorr = userValidate(
      req.body.name,
      req.body.email,
      req.body.password
    );
    console.log(erorr);
    if (erorr.error) {
      return res.json({
        status: false,
        message: erorr.error.details[0].message,
      });
    }
    //bcryptjs.hash
    const hashedPassword = await bcryptjs.hash(req.body.password, 8);
    let user = new User({
      name: req.body.name,
      email: req.body.email,
      password: hashedPassword,
    
    });
    user = await user.save();
    res.json({
      status: true,
      message: "accunt created :signin with the same credentiols! ",
      ...user,
    });
  } catch (e) {
    res.json({ status: false, message: e.message });
  }
});
function userValidate(name, email, password) {
  const schema = Joi.object({
    name: Joi.string().trim().required(),
    //  .pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')),
    //
    email: Joi.string().trim().email().required(),
    password: Joi.string().trim().min(8).max(15).required(),
  });
  return schema.validate({
    name: name,

    email: email,
    password: password,
  });
}

//Sign In Rout
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const existingUser = await User.findOne({ email });
    if (!existingUser) {
      return res.json({
        status: false,
        message: " Email or Password is invalid",
      });
    }
    // password comparing
    const isMatch = await bcryptjs.compare(password, existingUser.password);
    if (!isMatch) {
      return res.json({
        status: false,
        message: " Email or Password is invalid",
      });
    }
     
    const token = jwt.sign({id:existingUser._id},"passwordKey");
   // const existingU = await User.findOne({ email }).select('-password');
    res.json({
      status: true,
      message: "Signin with the Email successfully",
      user:{token,
      "_id": existingUser._id,
      "name":existingUser.name,
      "email": existingUser.email,
      "address": existingUser.address,
      "type": existingUser.type,
      "cart":existingUser.cart,
      "__v":existingUser.__v
    },
    });
    
  } catch (e) {
    res.json({ status: false, message: e.message });
  }
});
module.exports = authRouter;
