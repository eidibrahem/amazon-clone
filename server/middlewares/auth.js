const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token)
    return res.json({status:false,msg:"no Auth Token"});

    const verified = jwt.verify(token, "passwordKey");
    if (!verified)
    return res.json({starus:false,msg:"Token verifier failed"});

    req.user = verified.id;
    req.token = token;
    next();
  } catch (err) {
    res.json({status:false, msg:err.message})
  }
};

module.exports = auth;
