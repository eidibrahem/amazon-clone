const express = require("express");
const authRouter=require("./routes/auth");
const mongoose = require('mongoose');
const adminRouter=require("./routes/admin");
const productRouter=require("./routes/product");
const userRouter=require("./routes/user");
mongoose.connect('mongodb+srv://eid:password1234@cluster0.k9mpifn.mongodb.net/?retryWrites=true&w=majority').then(()=>console.log('connected !'))
.catch((e)=>console.log('connected failed!' + e));
const employeeSchema = new mongoose.Schema({
  name:String,
  age: { type: Number, min: 18, max: 65 },
  department:[String],
  date:{type:Date ,default:Date.now},
  living:  Boolean ,

});

const Employee =mongoose.model("Employee",employeeSchema);
const eid=new Employee({
    name:'eid',
    age:24, 
    department:['it','cs'],
    living:  true,
  
});

async function createEmployee(){
    const cEmployee=new Employee({
       
        name:'mahmuod 577',
        age:19, 
        department:['it','cs'],
        living:  true,
      
    }); 
const resulte = await cEmployee.save();
console.log(resulte + 'created');  
}

//createEmployee();

//mongodb+srv://eid:password1234@cluster0.k9mpifn.mongodb.net/?retryWrites=true&w=majority


 const app = express();
app.use(express.json()); 

const Port =8000;


app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);
app.get('/apis',(req,res)=>{
res.send({eie:"day"})
}) 
app.listen(8000 ,() => {
  console.log("conected to port " + Port);
});
//192.168.56.1 10.0.2.2:8000
