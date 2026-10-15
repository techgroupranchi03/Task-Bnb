enum AuthRole { client, team, admin }

class AuthEntity {
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

  const AuthEntity({
    required this.id,
    required this.name,
    this.email = '',
    this.phone = '',
    required this.role,
    this.company,
    this.plan,
    this.validFrom,
    this.validTo,
    this.status,
    this.avatarUrl,
  });
}
