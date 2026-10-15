import '../entities/auth_entity.dart';
import '../../../../core/error/failure.dart';

abstract class IAuthRepository {
  Future<(AuthEntity?, Failure?)> adminLogin({
    required String username,
    required String password,
  });

  Future<(bool, Failure?)> sendOtp({
    required String phone,
    required AuthRole role,
  });

  Future<(AuthEntity?, Failure?)> verifyOtp({
    required String phone,
    required String otp,
    required AuthRole role,
  });

  Future<(bool, Failure?)> logout({AuthRole role = AuthRole.client});

  Future<(AuthEntity?, Failure?)> getProfile();

  Future<(bool, Failure?)> refreshToken();
}
