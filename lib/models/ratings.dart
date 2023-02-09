import '../shard/network/local/cache_helper.dart';

class RatingProuduct {
  List<Rating>? rating = <Rating>[];
  double myRating =1;
  double avargeRate=1;
  RatingProuduct({this.rating,required this.myRating,required this.avargeRate});

  RatingProuduct.fromJson(Map<String, dynamic> json) {
    if (json['rating'] != null) {
     var userId = CacheHelper.getData1(key: 'id');
      rating = <Rating>[];
      double total =0 ;
      for(int i =0;i<json['rating'].length;i++)
      { 
        rating!.add(new Rating.fromJson(json['rating'][i]));
        
        total+=json['rating'][i]['rating'];
      }
      avargeRate =total==0?2:total/json['rating'].length;
      
    }
    else{
      myRating=2;
     avargeRate=2;
    }
    print (myRating);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rating != null) {
      data['rating'] = this.rating!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rating {
  String? userId;
  int? rating;
  String? sId;

  Rating({this.userId, this.rating, this.sId});

  Rating.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    rating = json['rating'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['rating'] = this.rating;
    data['_id'] = this.sId;
    return data;
  }
}
