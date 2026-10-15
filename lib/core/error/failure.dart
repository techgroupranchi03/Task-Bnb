import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(
      {super.message = 'Request timed out. Please try again.'});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(
      {super.message = 'Session expired. Please log in again.'});
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure(
      {super.message = 'You do not have permission to perform this action.'});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Resource not found.'});
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;
  const ValidationFailure({
    super.message = 'Validation failed.',
    this.errors,
  });

  @override
  List<Object?> get props => [message, errors];
}

class ServerFailure extends Failure {
  const ServerFailure(
      {super.message = 'Server error. Please try again later.'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Local storage error.'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unexpected error occurred.'});
}
