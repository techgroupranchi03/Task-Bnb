import 'package:dio/dio.dart';
import '../../utils/app_logger.dart';
import '../../error/app_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.instance.error(
      '[ErrorInterceptor] ${err.type}: ${err.message}',
      err,
      err.stackTrace,
    );

    final exception = _mapError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
        response: err.response,
      ),
    );
  }

  AppException _mapError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        return _mapStatusCode(err.response?.statusCode, err.response?.data);
      default:
        return const UnknownException();
    }
  }

  AppException _mapStatusCode(int? statusCode, dynamic data) {
    final message = _extractMessage(data);
    switch (statusCode) {
      case 400:
        return ValidationException(message: message ?? 'Bad request.');
      case 401:
        return UnauthorizedException(message: message ?? 'Unauthorized.');
      case 403:
        return ForbiddenException(message: message ?? 'Forbidden.');
      case 404:
        return NotFoundException(message: message ?? 'Resource not found.');
      case 422:
        final errors = _extractValidationErrors(data);
        return ValidationException(
          message: message ?? 'Validation failed.',
          errors: errors,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(message: message ?? 'Server error. Please try again later.');
      default:
        return UnknownException(message: message ?? 'An unexpected error occurred.');
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String? ??
          data['detail'] as String?;
    }
    return null;
  }

  Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> && data['errors'] is Map) {
      final raw = data['errors'] as Map<String, dynamic>;
      return raw.map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => e.toString()).toList(),
        ),
      );
    }
    return null;
  }
}
