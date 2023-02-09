import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(
      //    String url ="https://drive.google.com/uc?export=download&id=1Xwy4OzKp6IGj27u-y0EZ3LSd-qNR5cTb";
      //https://drive.google.com/file/d/1Xwy4OzKp6IGj27u-y0EZ3LSd-qNR5cTb/view?usp=sharing
      BaseOptions(
        baseUrl: 'http://192.168.1.4:8000/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response?>? getData({
    required String url,
    Map<String, dynamic>? query,
    String lan = 'ar',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lan,
      'Content-Type': 'application/json',
      'x-auth-token': token ?? ''
    };
    print("0000${url}");
    return await dio?.get(
      url,
      queryParameters: query,
    );
  }
  static Future<Response?>? postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? data,
    String lan = 'en',
    String? token,
  }) async {
dio!.options.headers = {'lang': lan, 'Content-Type': 'application/json',
"x-auth-token":token 
};
    return dio?.post(
      url,
      queryParameters: query,
      data: data,
    );
  }
/*   static Future<Response?>? postData({
    required String url,
    Map<String, dynamic>? query, 
    required Map<String, dynamic>? data,
    String lan = 'en',
    String? token,
  }) async {
     dio!.options.headers = {
     // 'lang': lan,
      'Content-Type': 'application/json; charset=UTF-8',
     // 'Authorizatio': token
    };
    return dio?.post(
      url,
      queryParameters:query ,
      data:data,
    );
  } */

  static Dio? dioh;
  static inith() {
    dioh = Dio(
      //    String url ="https://drive.google.com/uc?export=download&id=1Xwy4OzKp6IGj27u-y0EZ3LSd-qNR5cTb";
      //https://drive.google.com/file/d/1Xwy4OzKp6IGj27u-y0EZ3LSd-qNR5cTb/view?usp=sharing
      BaseOptions(
        baseUrl: 'https://newsapi.org/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  //static Dio? dio ;
  // static init()
  // {
  //   dio =Dio(
  //    String url ="https://drive.google.com/uc?export=download&id=1Xwy4OzKp6IGj27u-y0EZ3LSd-qNR5cTb";
  //https://drive.google.com/file/d/1Xwy4OzKp6IGj27u-y0EZ3LSd-qNR5cTb/view?usp=sharing
  //     BaseOptions(
  //     baseUrl:'https://drive.google.com/' ,
  //     receiveDataWhenStatusError: true ,

  //   ),

  // );
  // }
//static Future<Response?>? getData ({
  // required String url ,
  // required Map <String,dynamic>? query  ,

  // })async
  // {
  //return await  dio?.get( url,queryParameters: query , );

  //}

}
