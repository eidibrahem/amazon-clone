const mongoose = require('mongoose');
const Joi =require('joi');
const { productSchema } = require('./product');
const userSchema = mongoose.Schema({
    name:{
        type:String,
        required:true,
        trim:true
    },
    email:{
        type:String,
        required:true,
        trim:true,
        validite :{
            validitor:(value)=>{
                const re =
                /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
              return  value.match(re);
            },
            message :'Please inter valid email address'
        }
    },
    password :{
        type:String,
        required:true,
        trim:true,
        validite :{
            validitor:(value)=>{
                 return  value.length>6;
            },
            message :'Please inter valid password > 6 '
        }
    },
    address:{
        type:String,
        default:'',
    },
    type:{
        type:String,
        default:"user",
    },
    cart:[
        {
            product:productSchema,
            quantity:{
                type:Number,
                required:true,
            }, 
        }
    ]
})
function userValidate (name,email,password)
{
  const schema = Joi.object({
    

        name: Joi.string().required(),
      //  .pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')),
       // .pattern(new RegExp('^[a-zA-Z0-9]{3,30}$'))
       email: Joi.string().trim().email()
       .required(),
        password: Joi.string().required(),
      
  })
   ;
   return schema.validate({ 
    name:   name , 

    email: email ,
    password: password ,
  });
}

const User =mongoose.model("User",userSchema);
module.exports= User;
