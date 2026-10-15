import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/models/auth_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/storage/secure_storage_service.dart';

// ── Auth State ─────────────────────────────────────────────────────────────
class AuthState {
  final bool isLoading;
  final bool isInitialising;
  final AuthEntity? user;
  final Failure? failure;
  final bool isAuthenticated;

  final AuthRole selectedRole;
  final bool isOtpSent;
  final String phone;
  final int resendCountdown;

  const AuthState({
    this.isLoading = false,
    this.isInitialising = true,
    this.user,
    this.failure,
    this.isAuthenticated = false,
    this.selectedRole = AuthRole.client,
    this.isOtpSent = false,
    this.phone = '',
    this.resendCountdown = 60,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isInitialising,
    AuthEntity? user,
    Failure? failure,
    bool? isAuthenticated,
    AuthRole? selectedRole,
    bool? isOtpSent,
    String? phone,
    int? resendCountdown,
  }) =>
      AuthState(
        isLoading: isLoading ?? this.isLoading,
        isInitialising: isInitialising ?? this.isInitialising,
        user: user ?? this.user,
        failure: failure ?? this.failure,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        selectedRole: selectedRole ?? this.selectedRole,
        isOtpSent: isOtpSent ?? this.isOtpSent,
        phone: phone ?? this.phone,
        resendCountdown: resendCountdown ?? this.resendCountdown,
      );
}

// ── Auth Notifier ──────────────────────────────────────────────────────────
class AuthNotifier extends StateNotifier<AuthState> {
  late final AdminLoginUsecase _adminLoginUsecase;
  late final SendOtpUsecase _sendOtpUsecase;
  late final VerifyOtpUsecase _verifyOtpUsecase;
  late final LogoutUsecase _logoutUsecase;
  Timer? _timer;

  AuthNotifier() : super(const AuthState(isInitialising: true)) {
    final repo = AuthRepositoryImpl();
    _adminLoginUsecase = AdminLoginUsecase(repo);
    _sendOtpUsecase = SendOtpUsecase(repo);
    _verifyOtpUsecase = VerifyOtpUsecase(repo);
    _logoutUsecase = LogoutUsecase(repo);
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final storage = SecureStorageService.instance;
      final token = await storage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final userDataJson = await storage.getUserData();
        final roleStr = await storage.getUserRole();
        AuthEntity? userEntity;
        if (userDataJson != null && userDataJson.isNotEmpty) {
          try {
            final map = jsonDecode(userDataJson) as Map<String, dynamic>;
            userEntity = AuthModel.fromJson(map).toEntity();
          } catch (_) {}
        }
        AuthRole restoredRole = AuthRole.client;
        if (roleStr != null && roleStr.isNotEmpty) {
          restoredRole = AuthRole.values.firstWhere(
            (r) => r.name == roleStr,
            orElse: () => AuthRole.client,
          );
        }
        state = state.copyWith(
          isAuthenticated: true,
          isInitialising: false,
          user: userEntity,
          selectedRole: restoredRole,
        );
        return;
      }
    } catch (_) {}
    state = state.copyWith(
      isAuthenticated: false,
      isInitialising: false,
    );
  }

  void setRole(AuthRole role) {
    _cancelTimer();
    state = AuthState(
      selectedRole: role,
      isAuthenticated: state.isAuthenticated,
      isInitialising: false,
      user: state.user,
      isLoading: false,
      failure: null,
      isOtpSent: false,
      phone: '',
      resendCountdown: 60,
    );
  }

  void resetOtp() {
    _cancelTimer();
    state = AuthState(
      selectedRole: state.selectedRole,
      isAuthenticated: state.isAuthenticated,
      isInitialising: false,
      user: state.user,
      isLoading: false,
      failure: null,
      isOtpSent: false,
      phone: state.phone,
      resendCountdown: 60,
    );
  }

  void clearFailure() {
    state = AuthState(
      selectedRole: state.selectedRole,
      isAuthenticated: state.isAuthenticated,
      isInitialising: false,
      user: state.user,
      isLoading: state.isLoading,
      failure: null,
      isOtpSent: state.isOtpSent,
      phone: state.phone,
      resendCountdown: state.resendCountdown,
    );
  }

  Future<bool> sendOtp(String phone) async {
    state = AuthState(
      selectedRole: state.selectedRole,
      isAuthenticated: state.isAuthenticated,
      isInitialising: false,
      user: state.user,
      isLoading: true,
      failure: null,
      isOtpSent: state.isOtpSent,
      phone: phone,
      resendCountdown: state.resendCountdown,
    );
    final (success, failure) = await _sendOtpUsecase(
      phone: phone,
      role: state.selectedRole,
    );
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
      return false;
    }
    state = state.copyWith(
      isLoading: false,
      isOtpSent: true,
      phone: phone,
      resendCountdown: 60,
    );
    _startCountdown();
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    state = AuthState(
      selectedRole: state.selectedRole,
      isAuthenticated: state.isAuthenticated,
      isInitialising: false,
      user: state.user,
      isLoading: true,
      failure: null,
      isOtpSent: state.isOtpSent,
      phone: state.phone,
      resendCountdown: state.resendCountdown,
    );
    final (entity, failure) = await _verifyOtpUsecase(
      phone: state.phone,
      otp: otp,
      role: state.selectedRole,
    );
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
      return false;
    }
    _cancelTimer();
    state = state.copyWith(
      isLoading: false,
      user: entity,
      isAuthenticated: true,
    );
    return true;
  }

  Future<bool> resendOtp() async {
    if (state.resendCountdown > 0 || state.phone.isEmpty) return false;
    return sendOtp(state.phone);
  }

  Future<bool> adminLogin({
    required String username,
    required String password,
  }) async {
    state = AuthState(
      selectedRole: state.selectedRole,
      isAuthenticated: state.isAuthenticated,
      isInitialising: false,
      user: state.user,
      isLoading: true,
      failure: null,
      isOtpSent: state.isOtpSent,
      phone: state.phone,
      resendCountdown: state.resendCountdown,
    );
    final (entity, failure) = await _adminLoginUsecase(
      username: username,
      password: password,
    );
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
      return false;
    }
    state = state.copyWith(
      isLoading: false,
      user: entity,
      isAuthenticated: true,
    );
    return true;
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _logoutUsecase(role: state.selectedRole);
    _cancelTimer();
    state = const AuthState(isInitialising: false);
  }

  void _startCountdown() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCountdown <= 1) {
        timer.cancel();
        state = state.copyWith(resendCountdown: 0);
      } else {
        state = state.copyWith(resendCountdown: state.resendCountdown - 1);
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}

// ── Providers ─────────────────────────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

