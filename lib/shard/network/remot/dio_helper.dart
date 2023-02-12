import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl:
            'http://192.168.1.4:8000/', //Use 10.0.2.2 for default AVD and 10.0.3.2 for Genymotion
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
    required Map<String, dynamic>? data, //body
    String lan = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lan,
      'Content-Type': 'application/json',
      "x-auth-token": token
    };
    return dio?.post(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
