import '../entities/auth_entity.dart';
import '../repositories/i_auth_repository.dart';
import '../../../../core/error/failure.dart';

class AdminLoginUsecase {
  final IAuthRepository _repository;
  const AdminLoginUsecase(this._repository);

  Future<(AuthEntity?, Failure?)> call({
    required String username,
    required String password,
  }) =>
      _repository.adminLogin(username: username, password: password);
}

class SendOtpUsecase {
  final IAuthRepository _repository;
  const SendOtpUsecase(this._repository);

  Future<(bool, Failure?)> call({
    required String phone,
    required AuthRole role,
  }) =>
      _repository.sendOtp(phone: phone, role: role);
}

class VerifyOtpUsecase {
  final IAuthRepository _repository;
  const VerifyOtpUsecase(this._repository);

  Future<(AuthEntity?, Failure?)> call({
    required String phone,
    required String otp,
    required AuthRole role,
  }) =>
      _repository.verifyOtp(phone: phone, otp: otp, role: role);
}

class LogoutUsecase {
  final IAuthRepository _repository;
  const LogoutUsecase(this._repository);

  Future<(bool, Failure?)> call({AuthRole role = AuthRole.client}) =>
      _repository.logout(role: role);
}

class GetProfileUsecase {
  final IAuthRepository _repository;
  const GetProfileUsecase(this._repository);

  Future<(AuthEntity?, Failure?)> call() => _repository.getProfile();
}
