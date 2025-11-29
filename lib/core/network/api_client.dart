import 'package:dio/dio.dart';
import '../errors/failure.dart';
import 'network_info.dart';
import 'dio_interceptor.dart';
import 'package:sof_users/core/utilities/endpoints.dart';

class ApiClient {
  final Dio dio;
  final NetworkInfo networkInfo;
  final int maxRetries;

  ApiClient({
    required this.networkInfo,
    this.maxRetries = 3,
  }) : dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.baseURL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  ) {
    dio.interceptors.add(DioInterceptor(networkInfo: networkInfo, dio: dio));
  }

  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return _performRequest<T>(
            () => dio.get(path, queryParameters: queryParameters));
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) async {
    return _performRequest<T>(() => dio.post(path, data: data));
  }

  Future<Response<T>> _performRequest<T>(
      Future<Response<T>> Function() requestFn) async {
    if (!await networkInfo.isConnected) {
      throw Failure("🌐 No internet connection.");
    }

    int attempt = 0;

    while (true) {
      try {
        return await requestFn();
      } on DioException catch (e) {
        attempt++;

        // Retry logic only for connection-related errors
        if ((e.type == DioExceptionType.unknown ||
            e.type == DioExceptionType.connectionTimeout) &&
            attempt <= maxRetries) {
          final delay = Duration(seconds: 2 * attempt); // exponential backoff
          await Future.delayed(delay);
          continue;
        }

        throw _mapDioErrorToFailure(e);
      }
    }
  }

  Failure _mapDioErrorToFailure(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return Failure("⏳ Connection timeout.");
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return Failure("📩 Receive timeout.");
    } else if (error.type == DioExceptionType.badResponse) {
      return Failure("❌ Bad response", statusCode: error.response?.statusCode);
    } else {
      return Failure("⚠️ No Internet Connection");
    }
  }
}
