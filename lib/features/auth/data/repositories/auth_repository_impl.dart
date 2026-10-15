import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource _remote;
  final SecureStorageService _storage;

  AuthRepositoryImpl({
    AuthRemoteDataSource? remote,
    SecureStorageService? storage,
  })  : _remote = remote ?? AuthRemoteDataSource(),
        _storage = storage ?? SecureStorageService.instance;

  @override
  Future<(AuthEntity?, Failure?)> adminLogin({
    required String username,
    required String password,
  }) async {
    try {
      final model = await _remote.adminLogin(
        username: username,
        password: password,
      );
      if (model.accessToken != null) {
        await _storage.saveAccessToken(model.accessToken!);
      }
      if (model.refreshToken != null) {
        await _storage.saveRefreshToken(model.refreshToken!);
      }
      await _storage.saveUserId(model.id);
      await _storage.saveUserData(jsonEncode(model.toJson()));
      await _storage.saveUserRole(AuthRole.admin.name);
      return (model.toEntity(), null);
    } catch (e, s) {
      return (null, _handleException(e, s, 'AuthRepository.adminLogin'));
    }
  }

  @override
  Future<(bool, Failure?)> sendOtp({
    required String phone,
    required AuthRole role,
  }) async {
    try {
      if (role == AuthRole.client) {
        await _remote.sendClientOtp(phone: phone);
      } else if (role == AuthRole.team) {
        await _remote.sendTeamOtp(phone: phone);
      }
      return (true, null);
    } catch (e, s) {
      return (false, _handleException(e, s, 'AuthRepository.sendOtp'));
    }
  }

  @override
  Future<(AuthEntity?, Failure?)> verifyOtp({
    required String phone,
    required String otp,
    required AuthRole role,
  }) async {
    try {
      final model = role == AuthRole.client
          ? await _remote.verifyClientOtp(phone: phone, otp: otp)
          : await _remote.verifyTeamOtp(phone: phone, otp: otp);

      if (model.accessToken != null) {
        await _storage.saveAccessToken(model.accessToken!);
      }
      if (model.refreshToken != null) {
        await _storage.saveRefreshToken(model.refreshToken!);
      }
      await _storage.saveUserId(model.id);
      await _storage.saveUserData(jsonEncode(model.toJson()));
      await _storage.saveUserRole(role.name);
      return (model.toEntity(), null);
    } catch (e, s) {
      return (null, _handleException(e, s, 'AuthRepository.verifyOtp'));
    }
  }

  @override
  Future<(bool, Failure?)> logout({AuthRole role = AuthRole.client}) async {
    try {
      final token = await _storage.getAccessToken();
      final endpoint = role == AuthRole.admin
          ? ApiEndpoints.adminLogout
          : role == AuthRole.team
              ? ApiEndpoints.teamMembersLogout
              : ApiEndpoints.clientLogout;
      await _remote.logout(endpoint, token: token);
      await _storage.clearAll();
      return (true, null);
    } catch (_) {
      await _storage.clearAll();
      return (true, null);
    }
  }

  @override
  Future<(AuthEntity?, Failure?)> getProfile() async {
    try {
      return (null, const UnknownFailure(message: 'Profile endpoint pending'));
    } catch (e, s) {
      return (null, _handleException(e, s, 'AuthRepository.getProfile'));
    }
  }

  @override
  Future<(bool, Failure?)> refreshToken() async {
    return (false, const UnauthorizedFailure());
  }

  Failure _handleException(dynamic e, StackTrace s, String contextName) {
    AppLogger.instance.error(contextName, e, s);

    if (e is AppException) {
      return _mapException(e);
    }

    if (e is DioException) {
      if (e.error is AppException) {
        return _mapException(e.error as AppException);
      }

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'] as String? ??
            data['error'] as String? ??
            data['msg'] as String?;
        if (message != null && message.isNotEmpty) {
          return UnknownFailure(message: message);
        }
      }

      if (e.message != null && e.message!.isNotEmpty) {
        return UnknownFailure(message: e.message!);
      }
    }

    return UnknownFailure(message: e.toString());
  }

  Failure _mapException(AppException e) {
    if (e is NetworkException) return NetworkFailure(message: e.message);
    if (e is TimeoutException) return TimeoutFailure(message: e.message);
    if (e is UnauthorizedException) return UnauthorizedFailure(message: e.message);
    if (e is ForbiddenException) return ForbiddenFailure(message: e.message);
    if (e is NotFoundException) return NotFoundFailure(message: e.message);
    if (e is ValidationException) {
      return ValidationFailure(message: e.message, errors: e.errors);
    }
    if (e is ServerException) return ServerFailure(message: e.message);
    return UnknownFailure(message: e.message);
  }
}
