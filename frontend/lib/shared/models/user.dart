class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final int trustScore;
  final int reportsSubmitted;
  final int reportsConfirmed;
  final String? avatarUrl;
  final String? location;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.trustScore,
    required this.reportsSubmitted,
    required this.reportsConfirmed,
    this.avatarUrl,
    this.location,
    required this.createdAt,
  });

  bool get isTrusted => trustScore >= 75;

  String get roleDisplay {
    switch (role.toUpperCase()) {
      case 'CITIZEN':
        return 'Citizen';
      case 'AUTHORITY':
        return 'Authority';
      case 'ADMIN':
        return 'Admin';
      default:
        return role;
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'CITIZEN',
      trustScore: json['trustScore'] ?? 50,
      reportsSubmitted: json['reportsSubmitted'] ?? 0,
      reportsConfirmed: json['reportsConfirmed'] ?? 0,
      avatarUrl: json['avatarUrl'],
      location: json['location'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'trustScore': trustScore,
      'reportsSubmitted': reportsSubmitted,
      'reportsConfirmed': reportsConfirmed,
      'avatarUrl': avatarUrl,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    int? trustScore,
    int? reportsSubmitted,
    int? reportsConfirmed,
    String? avatarUrl,
    String? location,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      trustScore: trustScore ?? this.trustScore,
      reportsSubmitted: reportsSubmitted ?? this.reportsSubmitted,
      reportsConfirmed: reportsConfirmed ?? this.reportsConfirmed,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}