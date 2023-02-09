// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_clone/models/order_product.dart';
import 'package:amazon_clone/models/product.dart';

class Order {
     String? id;
     List<OrderProduct>?orders;
      String? address;
       String? userId;
      int? orderdAt;
      int? status; 
      double? totalPrice; 
  Order({
    this.id,
    this.address,
    this.userId,
    this.orderdAt,
    this.status,
    this.orders,
    this.totalPrice
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'address': address,
      'userId': userId,
      'orderdAt': orderdAt,
      'status': status,
      'totalPrice':totalPrice
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    List<OrderProduct>?orders0= <OrderProduct>[];
      map['products'].forEach((v) {
        orders0.add(new OrderProduct.fromJson(v));
      });
    return Order(
      id: map['_id'] != null ? map['_id'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      orderdAt: map['orderdAt'] != null ? map['orderdAt'] as int : null,
      status: map['status'] != null ? map['status'] as int : null,
    //// it will do error if you dont add .toDouble() 
      totalPrice:  map['totalPrice'] != null ? map['totalPrice'].toDouble():0 ,
      orders: orders0
    );
  }

  String toJson() => json.encode(toMap());

     }
