class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final int? trustScore;
  final bool? isTrusted;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.trustScore,
    this.isTrusted,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      trustScore: json['trustScore'],
      isTrusted: json['isTrusted'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'trustScore': trustScore,
        'isTrusted': isTrusted,
      };

  bool get isAuthority => role == 'AUTHORITY' || role == 'ADMIN';
}
