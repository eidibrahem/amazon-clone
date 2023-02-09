class AddProductRes{
     bool? status;
     String? msg;
     AddProductRes(this.status,this.msg);
     AddProductRes.fromjson(Map<String, dynamic> json,){
    status = json['status']??'';
    msg = json['msg']??'';
    }

     }
