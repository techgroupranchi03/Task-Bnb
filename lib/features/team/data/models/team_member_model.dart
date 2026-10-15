import '../../domain/entities/team_member_entity.dart';

class TeamMemberModel {
  final int id;
  final int clientId;
  final String name;
  final String role;
  final String phone;
  final String status;
  final int isActive;
  final String? lastLogin;
  final String createdAt;

  const TeamMemberModel({
    required this.id,
    required this.clientId,
    required this.name,
    required this.role,
    required this.phone,
    required this.status,
    required this.isActive,
    this.lastLogin,
    required this.createdAt,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] as int? ?? 0,
      clientId: json['client_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      status: json['status'] as String? ?? 'inactive',
      isActive: json['is_active'] as int? ?? 0,
      lastLogin: json['last_login'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  TeamMemberEntity toEntity() => TeamMemberEntity(
        id: id,
        name: name,
        role: role,
        phone: phone,
        status: status,
        isActive: isActive == 1,
        lastLogin: lastLogin,
      );
}
