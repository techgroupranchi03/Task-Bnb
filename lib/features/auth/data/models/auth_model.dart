import '../../domain/entities/auth_entity.dart';

class AuthModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? company;
  final String? plan;
  final String? validFrom;
  final String? validTo;
  final String? status;
  final String? avatarUrl;
  final String? accessToken;
  final String? refreshToken;

  const AuthModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.company,
    this.plan,
    this.validFrom,
    this.validTo,
    this.status,
    this.avatarUrl,
    this.accessToken,
    this.refreshToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'] as String? ??
        json['access_token'] as String? ??
        json['accessToken'] as String?;

    final refreshToken = json['refresh_token'] as String? ??
        json['refreshToken'] as String?;

    final userObj = (json['client'] ??
            json['user'] ??
            json['admin'] ??
            json['team'] ??
            json['team_member'] ??
            json) as Map<String, dynamic>;

    return AuthModel(
      id: userObj['id']?.toString() ?? userObj['_id']?.toString() ?? '',
      name: userObj['name'] as String? ?? '',
      email: userObj['email'] as String? ?? '',
      phone: userObj['phone'] as String? ?? '',
      role: userObj['role'] as String? ?? json['role'] as String? ?? 'client',
      company: userObj['company'] as String?,
      plan: userObj['plan'] as String?,
      validFrom: userObj['valid_from'] as String? ?? userObj['validFrom'] as String?,
      validTo: userObj['valid_to'] as String? ?? userObj['validTo'] as String?,
      status: userObj['status'] as String?,
      avatarUrl: userObj['avatar_url'] as String? ?? userObj['avatarUrl'] as String?,
      accessToken: token,
      refreshToken: refreshToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'company': company,
      'plan': plan,
      'valid_from': validFrom,
      'valid_to': validTo,
      'status': status,
      'avatar_url': avatarUrl,
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  AuthEntity toEntity() => AuthEntity(
        id: id,
        name: name,
        email: email,
        phone: phone,
        role: role,
        company: company,
        plan: plan,
        validFrom: validFrom,
        validTo: validTo,
        status: status,
        avatarUrl: avatarUrl,
      );
}
