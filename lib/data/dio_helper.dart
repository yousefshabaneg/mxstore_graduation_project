import 'package:dio/dio.dart';

import '../shared/resources/constants_manager.dart';
import 'dio_exception.dart';

class DioHelper {
  static late Dio dio;
  static init() {
    BaseOptions options = BaseOptions(
      baseUrl: ConstantsManager.BaseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 10000,
      receiveTimeout: 30000,
    );
    dio = Dio(options);
  }

  static Map<String, dynamic> getHeaders(token) => {
        'Authorization': token != null ? "Bearer $token" : '',
      };

  static Future<dynamic> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = getHeaders(token);
    try {
      Response response = await dio.get(url, queryParameters: query);
      await Future.delayed(const Duration(seconds: 1));
      return response.data;
    } on DioError catch (ex) {
      throw DioExceptions.fromDioError(ex).toString();
    }
  }

  static Future<dynamic> postData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = getHeaders(token);
    try {
      await Future.delayed(const Duration(seconds: 2));
      Response response =
          await dio.post(url, queryParameters: query, data: data);
      return response.data;
    } on DioError catch (ex) {
      throw DioExceptions.fromDioError(ex).toString();
    }
  }

  static Future<dynamic> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = getHeaders(token);
    try {
      await Future.delayed(const Duration(seconds: 2));
      Response response = await dio.put(
        url,
        data: data,
      );
      return response.data;
    } on DioError catch (ex) {
      throw DioExceptions.fromDioError(ex).toString();
    }
  }

  static Future<dynamic> deleteData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = getHeaders(token);
    try {
      await Future.delayed(const Duration(seconds: 2));
      Response response = await dio.delete(
        url,
      );
      return response.data;
    } on DioError catch (ex) {
      throw DioExceptions.fromDioError(ex).toString();
    }
  }
}
