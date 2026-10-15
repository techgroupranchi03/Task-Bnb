import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/auth_model.dart';

class AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSource({DioClient? client})
      : _client = client ?? DioClient.instance;

  // ── Admin ──────────────────────────────────────────────
  Future<AuthModel> adminLogin({
    required String username,
    required String password,
  }) async {
    final response = await _client.post(
      ApiEndpoints.adminLogin,
      data: {'username': username, 'password': password},
    );
    final data = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};
    return AuthModel.fromJson(data['data'] ?? data);
  }

  // ── Client ─────────────────────────────────────────────
  Future<void> sendClientOtp({required String phone}) async {
    await _client.post(
      ApiEndpoints.clientLogin,
      data: {'phone': phone},
    );
  }

  Future<AuthModel> verifyClientOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await _client.post(
      ApiEndpoints.clientVerifyOtp,
      data: {'phone': phone, 'otp': otp},
    );
    final data = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};
    return AuthModel.fromJson(data['data'] ?? data);
  }

  // ── Team ───────────────────────────────────────────────
  Future<void> sendTeamOtp({required String phone}) async {
    await _client.post(
      ApiEndpoints.teamMembersLogin,
      data: {'phone': phone},
    );
  }

  Future<AuthModel> verifyTeamOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await _client.post(
      ApiEndpoints.teamMembersVerifyOtp,
      data: {'phone': phone, 'otp': otp},
    );
    final data = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};
    return AuthModel.fromJson(data['data'] ?? data);
  }

  // ── Logout ─────────────────────────────────────────────
  Future<void> logout(String logoutEndpoint, {String? token}) async {
    await _client.post(
      logoutEndpoint,
      data: token != null && token.isNotEmpty ? {'token': token} : null,
    );
  }
}
