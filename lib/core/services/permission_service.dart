enum UserRole { admin, client, teamMember, propertyManager }

class AppUser {
  final String id;
  final String name;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.name,
    required this.role,
  });
}

class PermissionService {
  PermissionService._();

  // ── Tasks ──────────────────────────────────────────────
  static bool canCreateTask(AppUser user) =>
      user.role == UserRole.admin ||
      user.role == UserRole.propertyManager ||
      user.role == UserRole.client;

  static bool canEditTask(AppUser user) =>
      user.role == UserRole.admin ||
      user.role == UserRole.propertyManager;

  static bool canDeleteTask(AppUser user) =>
      user.role == UserRole.admin;

  static bool canAssignTask(AppUser user) =>
      user.role == UserRole.admin ||
      user.role == UserRole.propertyManager;

  // ── Properties ─────────────────────────────────────────
  static bool canCreateProperty(AppUser user) =>
      user.role == UserRole.admin;

  static bool canEditProperty(AppUser user) =>
      user.role == UserRole.admin ||
      user.role == UserRole.propertyManager;

  static bool canDeleteProperty(AppUser user) =>
      user.role == UserRole.admin;

  // ── Inventory ──────────────────────────────────────────
  static bool canManageInventory(AppUser user) =>
      user.role == UserRole.admin ||
      user.role == UserRole.propertyManager;

  // ── Team ───────────────────────────────────────────────
  static bool canManageTeam(AppUser user) =>
      user.role == UserRole.admin;

  static bool canInviteTeamMember(AppUser user) =>
      user.role == UserRole.admin ||
      user.role == UserRole.propertyManager;

  // ── Settings ───────────────────────────────────────────
  static bool canAccessSettings(AppUser user) =>
      user.role == UserRole.admin;

  // ── Helpers ────────────────────────────────────────────
  static bool isAdmin(AppUser user) => user.role == UserRole.admin;
  static bool isClient(AppUser user) => user.role == UserRole.client;
  static bool isTeamMember(AppUser user) =>
      user.role == UserRole.teamMember;
  static bool isPropertyManager(AppUser user) =>
      user.role == UserRole.propertyManager;
}
