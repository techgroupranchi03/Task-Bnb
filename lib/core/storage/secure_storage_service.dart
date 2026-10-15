import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class SecureStorageService {
  SecureStorageService._();
  static final SecureStorageService instance = SecureStorageService._();

  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: _androidOptions,
  );

  // ── Token ──────────────────────────────────────────────
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: AppConstants.accessTokenKey, value: token);

  Future<String?> getAccessToken() =>
      _storage.read(key: AppConstants.accessTokenKey);

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: AppConstants.refreshTokenKey, value: token);

  Future<String?> getRefreshToken() =>
      _storage.read(key: AppConstants.refreshTokenKey);

  Future<void> saveUserId(String id) =>
      _storage.write(key: AppConstants.userIdKey, value: id);

  Future<String?> getUserId() =>
      _storage.read(key: AppConstants.userIdKey);

  Future<void> saveUserData(String jsonStr) =>
      _storage.write(key: AppConstants.userDataKey, value: jsonStr);

  Future<String?> getUserData() =>
      _storage.read(key: AppConstants.userDataKey);

  Future<void> saveUserRole(String role) =>
      _storage.write(key: AppConstants.userRoleKey, value: role);

  Future<String?> getUserRole() =>
      _storage.read(key: AppConstants.userRoleKey);

  // ── Generic ────────────────────────────────────────────
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> clearAll() => _storage.deleteAll();
}
