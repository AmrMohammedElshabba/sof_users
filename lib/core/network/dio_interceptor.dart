import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'network_info.dart';

class DioInterceptor extends Interceptor {
  final NetworkInfo networkInfo;
  final Dio dio;

  DioInterceptor({required this.networkInfo, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({
      'Accept-Language': 'en',
      'Accept': 'application/json;charset=utf-8',
    });

    // if (kDebugMode) {
    //   print("➡️ [REQUEST]");
    //   print("URL     : ${options.uri}");
    //   print("METHOD  : ${options.method}");
    //   print("QUERY   : ${options.queryParameters}");
    //   print("--------------------------------------------");
    // }

    if (!await networkInfo.isConnected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: "No Internet Connection",
        ),
      );
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // if (kDebugMode) {
    //   print("⬅️ [RESPONSE]");
    //   print("STATUS  : ${response.statusCode}");
    //   print("DATA    : ${response.data}");
    //   print("--------------------------------------------");
    // }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // if (kDebugMode) {
    //   print("❌ [ERROR]");
    //   print("TYPE    : ${err.type}");
    //   print("MESSAGE : ${err.message}");
    //   print("--------------------------------------------");
    // }




    handler.next(err);
  }


}
