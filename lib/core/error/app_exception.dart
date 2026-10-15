import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection.'});
}

class TimeoutException extends AppException {
  const TimeoutException(
      {super.message = 'Request timed out. Please try again.'});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(
      {super.message = 'Session expired. Please log in again.',
      super.statusCode = 401});
}

class ForbiddenException extends AppException {
  const ForbiddenException(
      {super.message = 'You do not have permission to perform this action.',
      super.statusCode = 403});
}

class NotFoundException extends AppException {
  const NotFoundException(
      {super.message = 'Resource not found.', super.statusCode = 404});
}

class ValidationException extends AppException {
  final Map<String, List<String>>? errors;
  const ValidationException({
    super.message = 'Validation failed.',
    super.statusCode = 422,
    this.errors,
  });

  @override
  List<Object?> get props => [message, statusCode, errors];
}

class ServerException extends AppException {
  const ServerException(
      {super.message = 'Server error. Please try again later.',
      super.statusCode = 500});
}

class CacheException extends AppException {
  const CacheException(
      {super.message = 'Local storage error.'});
}

class UnknownException extends AppException {
  const UnknownException(
      {super.message = 'An unexpected error occurred.'});
}
