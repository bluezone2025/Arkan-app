import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DioHelper {
  static late Dio dio;
  static bool login = false;
  static String auth = '';

  static init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    login = preferences.getBool('login') ?? false;
    auth = preferences.getString('token') ?? '';
    dio = Dio(
      BaseOptions(
        baseUrl: "https://arkan-q8.com/api/V1/",
        receiveDataWhenStatusError: true,
          connectTimeout: const Duration(minutes: 1), // 60 seconds
          receiveTimeout: const Duration(minutes: 1) // 60 seconds
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getBool('login')?? false){
      dio.options.headers ={"auth-token": preferences.getString('token') ?? '','Content-Language': preferences.getString('language') ?? 'en'};
    }
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<dynamic, dynamic> data,
    String? token,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getBool('login')?? false){
      dio.options.headers ={"auth-token": preferences.getString('token') ?? ''};
    }
    debugPrint(data.toString());
    return dio.post(
      url,
      queryParameters: query,
      data: data,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            print("status code here${status}");
            return status! < 500;
          }),
    );
  }

  static Future<Response> postDataImage({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getBool('login')?? false){
      dio.options.headers ={"auth-token": preferences.getString('token') ?? ''};
    }
    debugPrint(data.toString());
    var formData = FormData.fromMap(data);
    return dio.post(
      url,
      queryParameters: query,
      data: formData,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            print("status code here${status}");
            return status! < 500;
          }),
    );
  }
}


