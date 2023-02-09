// ignore_for_file: unnecessary_this
import 'cart.dart';

class UserModel {
  bool? status;
  String? message = 'null';
  UserDataModel? data;
  UserModel(this.status,this.data,this.message);
  UserModel cobyWith({
    bool? status,
    String? message,
    UserDataModel? data,
  }) {
    return UserModel(status??this.status, data??this.data,message??this.message);
  }
  UserModel.fromjson(Map<String, dynamic?>? json) {
    status = json!['status'];
    message = json['message'];
    data = (json['user'] != null ? UserDataModel.fromjson(json['user']) : null);
  }

}

class UserDataModel {
  String? id;
  String? email;
  String? name;
  String? password;
  String? address;
  String type = 'user';
  String? token;
  Cartproducts? cart =Cartproducts() ;

  UserDataModel(this.id, this.email, this.name, this.password, this.type,
      this.token, this.address, this.cart);
  UserDataModel.fromjson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    email = json['email'] ?? '';
    name = json['name'] ?? '';
    address = json['address'] ?? '';
    password = json['password'] ?? '';
    type = json['type'] ?? 'user';
    token = json['token'] ?? '';
    cart = Cartproducts.fromJson({"cart":json['cart']});
  }
  Map<String, dynamic> toMap() {
    // ignore: prefer_collection_literals, unnecessary_new
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['token'] = this.token;
    data['_id'] = this.id;
    data['type'] = this.type;
    data['cart'] = this.cart;
    return data;
  }

  UserDataModel cobyWith({
    String? id,
    String? email,
    String? name,
    String? password,
    String? address,
    String? type,
    String? token,
    Cartproducts? cart,
  }) {
    return UserDataModel(id??this.id,email ??this.email, name??this.name,password ??this.password,
       type??this.type,token??this.token,address??this.address, cart??this.cart,);
  }
}
