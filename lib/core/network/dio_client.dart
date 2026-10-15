import 'package:dio/dio.dart';
import '../../app/config/app_config.dart';
import '../constants/app_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/error_interceptor.dart';

class DioClient {
  DioClient._();
  static DioClient? _instance;
  static DioClient get instance => _instance ??= DioClient._();

  late Dio _dio;
  Dio get dio => _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.baseUrl,
        connectTimeout:
            Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout:
            Duration(milliseconds: AppConstants.receiveTimeout),
        sendTimeout: Duration(milliseconds: AppConstants.sendTimeout),
        followRedirects: true,
        maxRedirects: 5,
        validateStatus: (status) {
          return status != null && status < 400;
        },
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      ErrorInterceptor(),
      if (AppConfig.instance.enableLogging) LoggingInterceptor(),
    ]);
  }

  // ── Convenience helpers ────────────────────────────────
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path,
          queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.post<T>(path,
          data: data, queryParameters: queryParameters, options: options);

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.put<T>(path, data: data, options: options);

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.patch<T>(path, data: data, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.delete<T>(path, data: data, options: options);
}
