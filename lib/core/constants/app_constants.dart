abstract class AppConstants {
  // ── API ────────────────────────────────────────────────
  static const int connectTimeout = 30000; // ms
  static const int receiveTimeout = 30000; // ms
  static const int sendTimeout = 30000; // ms

  // ── Pagination ─────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int defaultPage = 1;

  // ── Cache ──────────────────────────────────────────────
  static const int cacheMaxAge = 3600; // seconds

  // ── Token & Auth Keys ─────────────────────────────────
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userDataKey = 'user_data';
  static const String userRoleKey = 'user_role';

  // ── Pref Keys ──────────────────────────────────────────
  static const String themeKey = 'app_theme';
  static const String onboardingDoneKey = 'onboarding_complete';
  static const String localeKey = 'locale';

  // ── Misc ───────────────────────────────────────────────
  static const String appName = 'Task Bnb';
  static const String supportEmail = 'support@taskbnb.com';
}
