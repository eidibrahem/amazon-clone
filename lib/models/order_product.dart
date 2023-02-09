import 'package:amazon_clone/models/product.dart';


class OrderProduct{
  Product? product;
	int? quantity;
  OrderProduct({this.product, this.quantity,});
  	OrderProduct.fromJson(Map<String, dynamic> json) {
		product = json['product'] != null ? new Product.fromjson(json['product']) : null;
		quantity = json['quantity'];
	}
  Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.product != null) {
      data['product'] = this.product!.toMap();
    }
		data['quantity'] = this.quantity;
		return data;
	}
}