abstract class ApiEndpoints {
  // ── Admin auth ─────────────────────────────────────────
  static const String adminLogin = '/admin/auth/login';
  static const String adminLogout = '/admin/auth/logout';

  // ── Client auth ───────────────────────────────────────
  static const String clientLogin = '/client/auth/login';
  static const String clientVerifyOtp = '/client/auth/verify-otp';
  static const String clientLogout = '/client/auth/logout';

  // ── Team Members auth ───────────────────────────────────────
  static const String teamMembersLogin = '/team/auth/login';
  static const String teamMembersVerifyOtp = '/team/auth/verify-otp';
  static const String teamMembersLogout = '/team/auth/logout';

  // ── Dashboard ──────────────────────────────────────────
  static const String dashboard = '/dashboard';

  // ── Properties ─────────────────────────────────────────
  static const String properties = '/properties';
  static const String clientProperties = '/client/properties';
  static String clientPropertyById(String id) => '/client/properties/$id';

  // ── Tasks ──────────────────────────────────────────────
  static const String tasks = '/tasks';
  static String taskById(String id) => '/tasks/$id';
  static String tasksByProperty(String propertyId) =>
      '/properties/$propertyId/tasks';

  // ── Inventory ──────────────────────────────────────────
  static const String inventory = '/inventory';
  static String inventoryById(String id) => '/inventory/$id';

  // ── Team ───────────────────────────────────────────────
  static const String team = '/team';
  static const String clientTeam = '/client/team';
  static String teamMemberById(String id) => '/team/$id';

  // ── Notifications ──────────────────────────────────────
  static const String notifications = '/notifications';
  static String markNotificationRead(String id) => '/notifications/$id/read';

  // ── Profile ────────────────────────────────────────────
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String changePassword = '/profile/change-password';
  static const String uploadAvatar = '/profile/avatar';

  // ── Settings ───────────────────────────────────────────
  static const String settings = '/settings';
}
