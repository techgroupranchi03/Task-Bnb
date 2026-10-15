class TeamMemberEntity {
  final int id;
  final String name;
  final String role;
  final String phone;
  final String status;
  final bool isActive;
  final String? lastLogin;

  const TeamMemberEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.status,
    required this.isActive,
    this.lastLogin,
  });
}
