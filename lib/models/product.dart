import 'package:amazon_clone/models/ratings.dart';

class Product {
  String? name;
  String? description;
  double? price;
  double? quantity;
  String? category;
  List<String>? images;
  String? id = '';
  RatingProuduct rating =
      RatingProuduct(rating: <Rating>[], avargeRate: 2, myRating: 2);
  Map<String, dynamic>? toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'images': images,
      'id': id,
      'rating': rating
    };
  }

  Product(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.quantity,
      this.price,
      this.category,
      required this.rating});
  Product.fromjson(
    Map<String, dynamic> json,
  ) {
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    //// it will do error if you dont add .toDouble()
    price = json['price']?.toDouble() ?? 0.0;
    //// it will do error if you dont add .toDouble()
    quantity = json['quantity']?.toDouble() ?? 0.0;
    category = json['category'] ?? '';
    id = json['_id'] ?? 'user';

    images = List<String>.from(json['images']);
    try {
      rating = RatingProuduct.fromJson({"rating": json['rating']});
    } catch (e) {
      RatingProuduct rat =
          RatingProuduct(rating: [], avargeRate: 2, myRating: 2);
      rating = rat;
    }
  }
}
