// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/common/widget/widget.dart';
import 'package:amazon_clone/features/admin/screens/analyticsScreen/analytics_screen.dart';
import 'package:amazon_clone/features/admin/screens/ordersScreeen/orders_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/sales.dart';
import 'package:amazon_clone/models/sales.dart';
import 'package:amazon_clone/shard/admin_cubit/states.dart';
import 'package:amazon_clone/shard/network/end_point.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/account/screens/account_screen.dart';
import '../../features/admin/screens/posts_screen.dart';
import '../../models/add_product_res.dart';
import '../network/local/cache_helper.dart';
import '../network/remot/dio_helper.dart';

class AdminCubit extends Cubit<AdminStates> {
  AdminCubit() : super(AdminIntialState());
  static AdminCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    PostsScreen(),
    AnalyticsScreen(),
    OrdersScreen(),
  ];

  int currentIndex = 0;
  void changCurrentIndexe(int index) {
    currentIndex = index;
    emit(NavState());
  }

  List<String> productsCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
    "Electronics",
  ];
  String? categoriesValue = 'Mobiles';
  void changCatValue(String? value) {
    categoriesValue = value;
    emit(ChangCatValue());
  }

  List<File> Images = [];

  Future<List<File>> pickImages() async {
    List<File> Images = [];
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (files != null && files.files.isNotEmpty) {
        for (int i = 0; i < files.files.length; i++) {
          Images.add(File(files.files[i].path!));
        }
      }
    } catch (e) {
      debugPrint(" eeee${e.toString()}");
    }
    return Images;
  }

  void slectImages() async {
    await pickImages().then((value) {
      Images = value;
      emit(SlectImagesSeccessState());
    }).catchError((error) {
      debugPrint("iiiii${error.toString()}");
      emit(SlectImagesErrorState());
    });
  }

  AddProductRes? res;
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String? category,
  }) async {
    var token = CacheHelper.getData1(key: 'token');
    try {
      emit(AddProducLoudingState());
      final cloudInary = CloudinaryPublic('dzkln2dox', 'ly4chguw');
      List<String> imagesUrl = [];
      for (int i = 0; i < Images.length; i++) {
        CloudinaryResponse res = await cloudInary.uploadFile(
          CloudinaryFile.fromFile(Images[i].path, folder: name),
        );
        imagesUrl.add(res.secureUrl);
      }
      print(imagesUrl[0]);

      DioHelper.postData(
              url: ADDPRODUCT,
              data: {
                "name": name,
                "description": description,
                "images": imagesUrl,
                "quantity": quantity,
                "price": price,
                "category": categoriesValue,
              },
              token: token)
          ?.then((value) {
        res = AddProductRes.fromjson(value!.data);
        Images = [];
        fetchAllProduct(newProduct: true);
        emit(AddProductSeccessState(res));
      }).onError((error, stackTrace) {
        print(error.toString());
        emit(AddProductErrorState());
      });
    } catch (e) {
      ShowToast(text: e.toString(), state: ToastStates.ERROR);
    }
  }

  List<Product>? productList;
  void fetchAllProduct({bool newProduct = false}) async {
    if (productList?.length == 0 || productList == null || newProduct) {
      emit(FetchAllProducsLoudingState());
      productList = [];
      var token = CacheHelper.getData1(key: 'token');
      try {
        DioHelper.getData(url: FETCHALLPRODUCTS, token: token)?.then((value) {
          for (int i = 0; i < value!.data.length; i++) {
            if (value.data['$i'] != null)
              productList?.add(
                Product.fromjson(value.data['$i']),
              );
          }
          print("5555${value.data.length}ooo${productList?.length}");
          res = AddProductRes.fromjson(value.data);
          print(productList?[1].images);

          emit(FetchAllProducsSeccessState(res));
        }).onError((error, stackTrace) {
          print(error.toString());
          emit(AddProductErrorState());
        });
      } catch (e) {
        ShowToast(text: e.toString(), state: ToastStates.ERROR);
      }

      //print(productList);

    }
  }

  void deletProduct({String? id, required int? index}) async {
    var token = CacheHelper.getData1(key: 'token');
    try {
      DioHelper.postData(url: DELETPRODUCT, data: {"id": id}, token: token)
          ?.then((value) {
        res = AddProductRes.fromjson(value!.data);
        productList!.removeAt(index!.toInt());

        emit(DeletProductSeccessState());
      }).onError((error, stackTrace) {
        print(error.toString());
        emit(AddProductErrorState());
      });
    } catch (e) {
      ShowToast(text: e.toString(), state: ToastStates.ERROR);
    }
  }

  List<Order>? ordersList = [];
  void fetchAllOrders() async {
    if (ordersList?.length == 0 || ordersList == null) {
      emit(FetchAllOrdersLoudingState());
      ordersList = [];
      var token = CacheHelper.getData1(key: 'token');
      try {
        DioHelper.getData(url: FETCHALLORDERS, token: token)?.then((value) {
          for (int i = 0; i < value!.data.length; i++) {
            if (value.data['$i'] != null) {
              ordersList?.add(
                Order.fromMap(value.data['$i']),
              );
            }
          }
          print("5555${value.data.length}ooo${ordersList?.length}");
          res = AddProductRes.fromjson(value.data);
          print(ordersList?[1].orders?[0].quantity);
          if (res?.status == false) {
            ShowToast(text: res!.msg.toString(), state: ToastStates.ERROR);
          }
          emit(FetchAllOrdersSeccessState(res));
        }).onError((error, stackTrace) {
          print(error.toString());
          emit(FetchAllOrderstErrorState());
        });
      } catch (e) {
        ShowToast(text: e.toString(), state: ToastStates.ERROR);
        emit(FetchAllOrderstErrorState());
      }

      //print(productList);

    }
  }

  void changeOrderStatus({
    String? id,
    int? status = 1,
    required int? index,
  }) async {
    var token = CacheHelper.getData1(key: 'token');
    emit(ChangeOrdersStatusLoudingState());
    try {
      DioHelper.postData(
              url: CHANGEORDERSTATUS,
              data: {"id": id, "status": status},
              token: token)
          ?.then((value) {
        res = AddProductRes.fromjson(value!.data);

        emit(ChangeOrdersStatusSeccessState(res));
        if (res!.status == false) {
          ShowToast(text: res!.msg.toString(), state: ToastStates.ERROR);
        } else {
          ordersList?[index!.toInt()].status = status;
        }
      }).onError((error, stackTrace) {
        print(error.toString());
        ShowToast(text: error.toString(), state: ToastStates.ERROR);
        emit(AddProductErrorState());
      });
    } catch (e) {
      emit(AddProductErrorState());
      ShowToast(text: e.toString(), state: ToastStates.ERROR);
    }
  }

  int totalEarning = 0;
  List<Sales>? sales=[] ; 
  void getEarnings() async {
    if (sales!.length == 0 || sales == null) {
      emit(GetEarningsLoudingState());
      var token = CacheHelper.getData1(key: 'token');
      try {
        DioHelper.getData(url: GETANALYTICS, token: token)?.then((value) {
          totalEarning = value!.data['earnings']['totalEarning'];
          sales = [
            Sales(label: 'Mobile', earning: value.data['earnings']['mobileEarnings']),
            Sales( label: 'Essentials', earning: value.data['earnings']['essentialsEarnings']),
            Sales(label: 'Appliances', earning: value.data['earnings']['appliancesEarnings']),
            Sales(label: 'Books', earning: value.data['earnings']['booksEarnings']),
            Sales(label: 'Fashion', earning: value.data['earnings']['fashionEarnings']),
            Sales(label: 'Electronics', earning: value.data['earnings']['electronicsEarnings']),
          ];
            print("5555${value.data.length}ooo${sales?.length}");
          res = AddProductRes.fromjson(value.data);
          if (res?.status == false) {
            ShowToast(text: res!.msg.toString(), state: ToastStates.ERROR);
          }
          emit(GetEarningsSeccessState(res));
        }).onError((error, stackTrace) {
          print(error.toString());
          emit(GetEarningsErrorState());
        });
      } catch (e) {
        ShowToast(text: e.toString(), state: ToastStates.ERROR);
        emit(GetEarningsErrorState());
      }

      //print(productList);

    }
  }
}
