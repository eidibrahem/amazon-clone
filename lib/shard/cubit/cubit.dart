// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:amazon_clone/features/account/screens/account_screen.dart';
import 'package:amazon_clone/models/cart.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/ratings.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/shard/cubit/stats.dart';
import 'package:amazon_clone/shard/network/end_point.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/pay.dart';
import '../common/widget/widget.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../models/add_product_res.dart';
import '../../models/product.dart';
import '../network/local/cache_helper.dart';
import '../network/remot/dio_helper.dart';

enum Auth { signin, signup }

class AmazonCubit extends Cubit<AmazonStates> {
  AmazonCubit() : super(AmazonIntialState());
  static AmazonCubit get(context) => BlocProvider.of(context);
  Auth? auth = Auth.signup;

  int currentIndex = 0;
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  void changeAuth(Auth? val) {
    auth = val;
    emit(AmazonAuthState());
  }

  IconData suffix = Icons.visibility_outlined;
  bool ispass = true;
  void changePasssVisibility() {
    ispass = !ispass;
    if (ispass) {
      suffix = Icons.visibility_off_outlined;
    } else {
      suffix = Icons.visibility_outlined;
    }
    emit(AmazonChangePasssVisibilityState());
  }

  UserModel? userModel;
  void userRegister({
    required String name,
    required String email,
    required String password,
  }) {
    emit(AmazonSignUpLodingState());

    DioHelper.postData(
      url: SIGNUP,
      data: {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      },
    )?.then((value) {
      userModel = UserModel.fromjson(value!.data);
      emit(AmazonSignUpSucccessState(userModel));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print("eeeeeee ${error.toString()}");
      }
      emit(AmazonSignUpErorrState(error.toString()));
    });
  }

  void userSignIn({
    required String email,
    required String password,
  }) {
    emit(AmazonSignInLodingState());
    DioHelper.postData(
      url: SIGNIN,
      data: {
        "email": emailController.text,
        "password": passwordController.text,
      },
    )?.then((value) {
      userModel = UserModel.fromjson(value!.data);

      emit(AmazonSignInSucccessState(userModel));
    }).onError((error, stackTrace) {
      print("nnnnnnn${error.toString()}");
      emit(AmazonSignInErorrState(error.toString()));
    });
  }

  bool isToken() {
    var token = CacheHelper.getData1(key: 'token');
    var name = CacheHelper.getData1(key: 'name');
    if (token == '' || token == null || token.isEmpty) {
      print("tttttt${token}${name}");
      return false;
    }
    print("token  ${token}");
    return true; // key: 'token'
  }

  String? getToken() {
    String? token = CacheHelper.getData1(key: 'token') ?? '';
    print("token2  ${token}");
    return token; // key: 'token'
  }

  List<Widget> screens = [
    HomeScreen(),
    AccountScreen(),
    CartScreen(),
  ];

  void changCurrentIndexe(int index) {
    currentIndex = index;
    if(index==0){
      fetchDealOfDay();
    }else
    if(index==2){
              getUserData();
              }else if(index==1){
             fetchMyOrders();
              }
    emit(AmazonChangBottomNavState());
  }

  String getName() {
    String name = CacheHelper.getData1(key: 'name') ?? '';
    return name;
  }

  List<Map<String, String>> ImagesCategories = [
    {
      'title': 'Mobiles',
      'image': 'assets/images/mobiles.jpeg',
    },
    {
      'title': 'Essentials',
      'image': 'assets/images/essentials.jpeg',
    },
    {
      'title': 'Appliances',
      'image': 'assets/images/appliances.jpeg',
    },
    {
      'title': 'Books',
      'image': 'assets/images/books.jpeg',
    },
    {
      'title': 'Fashion',
      'image': 'assets/images/fashion.jpeg',
    },
    {
      'title': 'Electronics',
      'image': 'assets/images/electronics.jpeg',
    },
  ];
  List<String> carouselImages = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKXADtd7AJDks-u8dAubfblG32uq3Caqo3Vw&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCi5nl6vzEHaeH797aOSMf6cjB2TRdSIqIaQ&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiePpjrxT5pABHZocV4x0TCU6zi7t6gPrDaw&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR05hWaItcRANv5UnCydfsoMQY2abZ7rGAMDg&usqp=CAU',
    'https://cdn.shopify.com/app-store/listing_images/ccd0c938e4f2ec4e88891f2ad934aba2/desktop_screenshot/CI3llPvt1PkCEAE=.jpeg?height=360&quality=90&width=640'
  ];

  AddProductRes? res;
  List<Product>? categoryProducsList;
  void fetchAllProduct({bool newProduct = false, String? category}) async {
    if (categoryProducsList?.length == 0 ||
        categoryProducsList == null ||
        newProduct) {
      emit(FetchCategoryProducLoudingeccessState());
      categoryProducsList = [];
      var token = CacheHelper.getData1(key: 'token');
      try {
        DioHelper.getData(
            url: FETCHCATEGORYPRODUCTS,
            token: token,
            query: {"category": category})?.then((value) {
          for (int i = 0; i < value!.data.length; i++) {
            if (value.data['$i'] != null) {
              categoryProducsList?.add(
                Product.fromjson(value.data['$i']),
              );
            }
          }
          // test for 1-categoryProducsList?.length
          // 2-value.data.length
          res = AddProductRes.fromjson(value.data);
          emit(FetchCategoryProducsSeccessState(res));
        }).onError((error, stackTrace) {
          print(error.toString());
          emit(FetchCategoryProducsErorrState());
        });
      } catch (e) {
        ShowToast(text: e.toString(), state: ToastStates.ERROR);
      }
    }
  }

//**********************************************//

  List<Product>? searchProducsList=[];
  void fetchSearchProduct({String? search}) async {
    emit(FetchSearchProducLoudingState());
    searchProducsList = [];
    var token = CacheHelper.getData1(key: 'token');
    try {
      DioHelper.getData(
        //:prams -->  search
        url: "${FETCHSEARCHPRODUCTS}/${search}",
        token: token,
      )?.then((value) {
        for (int i = 0; i < value!.data.length; i++) {
          if (value.data['$i'] != null) {
            searchProducsList?.add(
              Product.fromjson(value.data['$i']),
            );
          }
        }
        // test for
        // 1-searchProducsList?.length
        // 2-value.data.length
        res = AddProductRes.fromjson(value.data);
        emit(FetchSearchProducsSeccessState(res));
      }).onError((error, stackTrace) {
        print(error.toString());
        emit(FetchSearchProducsErorrState());
      });
    } catch (e) {
      ShowToast(text: e.toString(), state: ToastStates.ERROR);
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product? product,
    required double rating,
  }) async {
    var token = CacheHelper.getData1(key: 'token');
    var userId = CacheHelper.getData1(key: 'id');
    try {
      emit(AddProducRateLoudingState());

      DioHelper.postData(
              url: RATEPRODUCT,
              data: {
                "id": product!.id,
                "rating": rating,
                "userId": userId,
              },
              token: token)
          ?.then((value) {
        res = AddProductRes.fromjson(value!.data);
//         fetchAllProduct(newProduct: true);
        emit(AddProducRateSccessState());
      }).onError((error, stackTrace) {
        ShowToast(text: error.toString(), state: ToastStates.ERROR);
        print(error.toString());
        emit(AddProducRateErorrState());
      });
    } catch (e) {
      ShowToast(text: e.toString(), state: ToastStates.ERROR);
      emit(AddProducRateErorrState());
    }
  }

  double myRate = 1;
  double findRating({
    required Product? product,
  }) {
    var userId = CacheHelper.getData1(key: 'id');
    for (int i = 0; i < product!.rating.rating!.length; i++) {
      if (product.rating.rating![i].userId == userId) {
        myRate = product.rating.rating![i].rating!.toDouble();
        return product.rating.rating![i].rating!.toDouble();
      }
    }
    return 1;
  }

  Product productDay = Product(
    id: '',
    category: '',
    description: '',
    images: [
     // 'https://res.cloudinary.com/dzkln2dox/image/upload/v1675548080/wireless%20charger%20/x9hftncitivmpfs2hm6b.webp'
    ],
    name: '',
    price: 2,
    quantity: 2,
    rating: RatingProuduct(
      myRating: 5,
      avargeRate: 5,
      rating: [],
    ),
  );
  void fetchDealOfDay() async {
    emit(FetchDealOfDayLoudingState());
    var token = CacheHelper.getData1(key: 'token');
    try {
      DioHelper.getData(
        url: FETCHDEALOFDAY,
        token: token,
      )?.then((value) {
        if (value?.data != null) {
          productDay = Product.fromjson(value?.data);
        }
        res = AddProductRes.fromjson(value!.data);
        emit(FetchDealOfDaySeccessState(res));
      }).onError((error, stackTrace) {
        print(error.toString());
        emit(FetchDealOfDayErorrState());
      });
    } catch (e) {
      ShowToast(text: e.toString(), state: ToastStates.ERROR);
    }
  }

  void addToCart({
    required Product? product,
  }) async {
    var token = CacheHelper.getData1(key: 'token');
    var userId = CacheHelper.getData1(key: 'id');
    if (product?.quantity != 0) {
      try {
        emit(AddToCartLoudingState());

        DioHelper.postData(
          url: ADDTOCART,
          data: {
            "id": product!.id,
            "userId": userId,
          },
          token: token,
        )?.then((value) {
          userModel = UserModel.fromjson(value!.data);
          getSum();
          emit(AddToCartSeccessState());
        }).onError((
          error,
          stackTrace,
        ) {
          ShowToast(text: error.toString(), state: ToastStates.ERROR);
          emit(AddToCartErorrState());
          getSum();
        });
      } catch (e) {
        ShowToast(text: e.toString(), state: ToastStates.ERROR);
        emit(AddToCartErorrState());
        getSum();
      }
    } else {
      ShowToast(
          text: '${product?.name} is out of stock!', state: ToastStates.ERROR);
    }
  }

// to get cart products
  void getUserData({
    bool inStart = false,
  }) async {
    emit(FetchDealOfDayLoudingState());
    try {
      if (inStart || userModel?.data == null) {
        var token = CacheHelper.getData1(key: 'token');
        var userId = CacheHelper.getData1(key: 'id');
        DioHelper.postData(
          url: GETUSERDATA,
          token: token,
          data: {
            "userId": userId,
          },
        )?.then((value) {
          userModel = UserModel.fromjson(value!.data);
          getSum();
          emit(FetchDealOfDayErorrState());
          print("eeeeeeeeeeeeeeeeeeee ${userModel!.data?.name}");
        }).onError((error, stackTrace) {
          print("eeeeeeeeeeeeeeeeeeee ${error.toString()}");
          emit(FetchDealOfDayErorrState());
        });
      }
    } catch (e) {
      getSum();
      ShowToast(text: e.toString(), state: ToastStates.ERROR);
    }
  }

  double sum = 0;
  double getSum() {
    paymentItems = [];
    if (userModel!.data!.cart!.cart!.length.compareTo(0) == 0) {
      sum=0;
      return 0;
    } else {
      try {
        sum = 0;
        for (int i = 0; i < userModel!.data!.cart!.cart!.length; i++) {
          sum = (sum +
              ((userModel!.data!.cart!.cart![i].product!.price)! *
                  (userModel!.data!.cart!.cart![i].quantity!.toInt())));
        }
      } catch (e) {}
      paymentItems.add(PaymentItem(
          amount: sum.toString(),
          label: 'total amount',
          status: PaymentItemStatus.final_price));
      return sum;
    }
  }

  void removeFromCart({
    required Product? product,
  }) async {
    var token = CacheHelper.getData1(key: 'token');
    var userId = CacheHelper.getData1(key: 'id');
    try {
      emit(RemoveFromCartLoudingState());

      DioHelper.postData(
        url: REMOVEFROMCART,
        data: {
          "id": product!.id,
          "userId": userId,
        },
        token: token,
      )?.then((value) {
        userModel = UserModel.fromjson(value!.data);
        getSum();
        emit(RemoveFromCartSeccessState());
        print("sss${userModel!.data!.cart?.toJson()}");
      }).onError((
        error,
        
        stackTrace,
      ) {
        ShowToast(text: error.toString(), state: ToastStates.ERROR);
        getSum();
        emit(RemoveFromCartErorrState());
      });
    } catch (e) {
      getSum();
      ShowToast(text: e.toString(), state: ToastStates.ERROR);
      emit(RemoveFromCartErorrState());
    }
  }

  //for address form
  var flatBuildingController = TextEditingController();
  var areaController = TextEditingController();
  var pincodeController = TextEditingController();
  var cityController = TextEditingController();
  var addressFormKey = GlobalKey<FormState>();
  void onGooglePayResult(res) {
    if (userModel!.data!.address!.isEmpty) {
      // saveUserAddress();
    }
  }

  List<PaymentItem> paymentItems = [];
  String addressToBeUsed = '';

  void paypress() {
    //User address
    String addressToBeUsed = '';
    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;
    if (isForm) {
      if (addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text},${flatBuildingController.text},${areaController.text},${cityController.text} - ${pincodeController.text}';
      } else {
        throw Exception('Plese inter all values ');
      }
    } else if (userModel!.data!.address!.isNotEmpty) {
      addressToBeUsed = userModel!.data!.address!;
    } else {
      ShowToast(text: 'Plese inter address value', state: ToastStates.WARNING);
    }
    //print User address
    print(addressToBeUsed);
    placeOrder(addressToBeUsed);
    saveUserAddress(addressToBeUsed1: addressToBeUsed);
  }

  void saveUserAddress({required String addressToBeUsed1}) async {
    var token = CacheHelper.getData1(key: 'token');
    try {
      emit(SaveUserAddressLoudingState());

      DioHelper.postData(
              url: SAVEUSERADDRESS,
              data: {
                "address": addressToBeUsed1,
              },
              token: token)
          ?.then((value) {
        userModel = UserModel.fromjson(value!.data);
        emit(SaveUserAddressSeccessState());
      }).onError((error, stackTrace) {
        print(error.toString());
        emit(SaveUserAddressErorrState());
      });
    } catch (e) {
      ShowToast(text: e.toString(), state: ToastStates.ERROR);
    }
  }

  void placeOrder(String addressToBeUseds) async {
    emit(PlaceOrderLoudingState());
    var token = CacheHelper.getData1(key: 'token');
    Map<String, dynamic>? cart = userModel!.data!.cart?.toJson();
    print(cart!['cart']);
    try {
      DioHelper.postData(
              url: ORDER,
              data: {
                "cart": cart['cart'],
                "address": addressToBeUseds,
                "totalPrice": sum,
              },
              token: token)
          ?.then((value) {
        fetchMyOrders(newOrder: true);
        userModel!.data!.cart?.cart = <Cart>[];
        sum = 0;
        print(value!.data);
        ShowToast(
            text: 'Your Order Has Been Placed!', state: ToastStates.SUCCESS);
        emit(PlaceOrderSeccessState());
      }).onError((error, stackTrace) {
        print(error.toString());
        ShowToast(text: error.toString(), state: ToastStates.ERROR);
        emit(PlaceOrderErorrState());
      });
    } catch (e) {
      ShowToast(text: e.toString(), state: ToastStates.ERROR);
    }

    //print(productList);
  }

  List<Order>? ordersList = [] ;
  void fetchMyOrders({bool newOrder = false}) async {
    if (ordersList?.length == 0 || ordersList == null || newOrder) {
      emit(FetchMyOrdersLoudingState());
      ordersList = [];
      var token = CacheHelper.getData1(key: 'token');
      try {
        DioHelper.getData(
          url: MYORDER,
          token: token,
        )?.then((value) {
          for (int i = 0; i < value!.data.length; i++) {
            if (value.data['$i'] != null) {
              ordersList?.add(
                Order.fromMap(value.data['$i']),
              );
            }
          }

          // test for
          // 1-ordersList?.length
          // 2-value.data.length
          res = AddProductRes.fromjson(value.data);
          print(ordersList?[1].orders?[0].quantity);
          if (res?.status == false) {
            ShowToast(text: res!.msg.toString(), state: ToastStates.ERROR);
          }
          emit(FetchMyOrdersSeccessState(res));
        }).onError((error, stackTrace) {
          print(error.toString());
          emit(FetchMyOrdersErorrState());
        });
      } catch (e) {
        ShowToast(text: e.toString(), state: ToastStates.ERROR);
        emit(FetchMyOrdersErorrState());
      }
    }
  }
}
