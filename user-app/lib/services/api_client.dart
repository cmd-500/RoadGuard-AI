import 'package:dio/dio.dart';
import '../core/constants.dart';
import 'storage_service.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});
  @override
  String toString() => message;
}

class ApiClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  static Dio get instance {
    if (_dio.interceptors.isEmpty) _attachInterceptors();
    return _dio;
  }

  static void _attachInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getToken();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (error, handler) {
        final message = error.response?.data is Map
            ? (error.response?.data['message'] ?? 'Something went wrong')
            : 'Could not reach the server';
        handler.reject(DioException(
          requestOptions: error.requestOptions,
          error: ApiException(message, statusCode: error.response?.statusCode),
          response: error.response,
          type: error.type,
        ));
      },
    ));
  }
}
