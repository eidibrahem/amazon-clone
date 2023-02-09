import 'package:amazon_clone/models/product.dart';

class Cartproducts {
	List<Cart>? cart =<Cart>[];

	Cartproducts({this.cart});

	Cartproducts.fromJson(Map<String, dynamic> json) {
		
    if (json['cart'] != null) {
      cart = <Cart>[];
      json['cart'].forEach((v) {
        cart?.add(new Cart.fromJson(v));
      });
    }
		else{
      cart = <Cart>[];
    }
	}
/*  

 Articles.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    } */

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.cart != null) {
      data['cart'] = this.cart!.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class Cart {
	Product? product;
	int? quantity;
	String? sId;

	Cart({this.product, this.quantity, this.sId});

	Cart.fromJson(Map<String, dynamic> json) {
		product = json['product'] != null ? new Product.fromjson(json['product']) : null;
		quantity = json['quantity'];
		sId = json['_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.product != null) {
      data['product'] = this.product!.toMap();
    }
		data['quantity'] = this.quantity;
		data['_id'] = this.sId;
		return data;
	}
}