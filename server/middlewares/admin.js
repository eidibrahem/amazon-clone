const jwt =require("jsonwebtoken");

const User = require("../models/user");
const { use } = require("../routes/auth");

const admin= async(req,res,next)=>{
    try{
        const token =req.header("x-auth-token");
        if(!token)
        return res.json({status:false,msg:"no Auth Token"});
     const verfied =jwt.verify(token,"passwordKey");
     if(!verfied)
     return res.json({starus:false,msg:"Token verifier failed"});
     const user= await User.findById(verfied.id);
     if(user.type=='user'||user.type=='seller')
     return res.json({status:false,msg :'you are not an admin'});
     req.user=verfied.id;
     req.token = token ;
     next();
    }
    catch(err){
        res.json({status:false, msg:err.message})
    }
    
}
module.exports= admin;