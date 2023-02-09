import '../../models/add_product_res.dart';
import '../../models/user.dart';

abstract class AmazonStates {}

class   AmazonIntialState extends AmazonStates {}

class AmazonChangBottomNavState extends AmazonStates {}
class AmazonAuthState extends AmazonStates {}
class AmazonChangePasssVisibilityState extends AmazonStates {}
//signUp
class AmazonSignUpLodingState extends AmazonStates {}
class AmazonSignUpSucccessState extends AmazonStates{
  final UserModel? userMoDel;
 AmazonSignUpSucccessState(this.userMoDel);
}
class AmazonSignUpErorrState extends AmazonStates {
  final String error;
  AmazonSignUpErorrState(this.error);
}
//SignIn 
class AmazonSignInLodingState extends AmazonStates {}
class AmazonSignInSucccessState extends AmazonStates{
  final UserModel? userMoDel;
 AmazonSignInSucccessState(this.userMoDel);
}
class AmazonSignInErorrState extends AmazonStates {
  final String error;
  AmazonSignInErorrState(this.error);
}
//....
class FetchCategoryProducLoudingeccessState extends AmazonStates {
  
}
class FetchCategoryProducsSeccessState extends AmazonStates {
  
AddProductRes? res;
FetchCategoryProducsSeccessState(this.res);
}
class FetchCategoryProducsErorrState extends AmazonStates {}

class FetchSearchProducsSeccessState extends AmazonStates {
  
AddProductRes? res;
FetchSearchProducsSeccessState(this.res);
}
class FetchSearchProducsErorrState extends AmazonStates {}
class FetchSearchProducLoudingState extends AmazonStates {
  
}//AddProducLoudingState
class AddProducRateLoudingState extends AmazonStates {
}
class AddProducRateErorrState extends AmazonStates {}
class AddProducRateSccessState extends AmazonStates {
  
}
class  FetchDealOfDaySeccessState extends AmazonStates {
  
AddProductRes? res;
 FetchDealOfDaySeccessState(this.res);
}
class  FetchDealOfDayErorrState extends AmazonStates {}
class FetchDealOfDayLoudingState extends AmazonStates {
  
}
class  AddToCartSeccessState extends AmazonStates {

}
class  AddToCartErorrState extends AmazonStates {}
class AddToCartLoudingState extends AmazonStates {
  
}
class  RemoveFromCartSeccessState extends AmazonStates {

}
class  RemoveFromCartErorrState extends AmazonStates {}
class RemoveFromCartLoudingState extends AmazonStates {
  
}
class  SaveUserAddressSeccessState extends AmazonStates {

}
class   SaveUserAddressErorrState extends AmazonStates {}
class  SaveUserAddressLoudingState extends AmazonStates {
  
}
class  PlaceOrderSeccessState extends AmazonStates {

}
class   PlaceOrderErorrState extends AmazonStates {}
class  PlaceOrderLoudingState extends AmazonStates {
  
}
class FetchMyOrdersLoudingState extends AmazonStates {
  
}
class FetchMyOrdersSeccessState extends AmazonStates {
  
AddProductRes? res;
FetchMyOrdersSeccessState(this.res);
}
class FetchMyOrdersErorrState extends AmazonStates {}

/*fetchDealOfDay  addToCart
    rating = json['rating'] != null
        ? List<Rating>.from(
            json["rating"]?.map(
              (x) => Rating.fromjson(x),
            ),
          )
        : null;
       var userId = CacheHelper.getData1(key: 'id');
    double total = 0;
   List<Rating> rating1= json['rating'] != null
        ? List<Rating>.from(
            json["rating"]?.map(
              (x) => Rating.fromjson(x),
            ),
          )
        : [];
    for (int i = 0; i < rating1.length; i++) {
      total += rating1[i].rating!;
      if (rating1[i].userId == userId) {
        myRat = rating1[i].rating;
      }
    }
    if (total != 0) {
      avargeRate = total / rating!.length;
      
    }else{
     avargeRate=4; 
    }
    
  }    rating= (json['rating']!=null? List<Rating>.from(json["rating"]?.map((x)=>Rating.fromjson(x),),):null)!;

  */