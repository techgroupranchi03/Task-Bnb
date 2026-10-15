import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';
import '../../utils/app_logger.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage = SecureStorageService.instance;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // If error happens on logout path, clear storage and resolve gracefully
    if (err.requestOptions.path.contains('/logout')) {
      await _storage.clearAll();
      handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          statusCode: 200,
          data: {'success': true, 'message': 'Logged out successfully'},
        ),
      );
      return;
    }

    if (err.response?.statusCode == 401) {
      AppLogger.instance.warning('401 received — attempting token refresh');

      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) {
        await _clearAndReject(err, handler);
        return;
      }

      try {
        final dio = Dio();
        final response = await dio.post(
          '${err.requestOptions.baseUrl}/auth/refresh',
          data: {'refresh_token': refreshToken},
        );

        final newAccessToken = response.data['access_token'] as String?;
        final newRefreshToken = response.data['refresh_token'] as String?;

        if (newAccessToken == null) {
          await _clearAndReject(err, handler);
          return;
        }

        await _storage.saveAccessToken(newAccessToken);
        if (newRefreshToken != null) {
          await _storage.saveRefreshToken(newRefreshToken);
        }

        final clonedRequest = err.requestOptions;
        clonedRequest.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await dio.fetch(clonedRequest);
        handler.resolve(retryResponse);
      } catch (_) {
        await _clearAndReject(err, handler);
      }
      return;
    }
    handler.next(err);
  }

  Future<void> _clearAndReject(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    await _storage.clearAll();
    handler.reject(err);
  }
}
