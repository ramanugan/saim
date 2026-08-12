class Role {
  final int id;
  final String name;
  final String? description;

  Role({
    required this.id,
    required this.name,
    this.description,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class UserProfile {
  final String id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final Role? role;
  final bool isActive;

  UserProfile({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.isActive = true,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['roles'] != null ? Role.fromJson(json['roles']) : null,
      isActive: json['is_active'] ?? true,
    );
  }

  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    if (first.isEmpty && last.isEmpty) return 'Usuario sin nombre';
    return '$first $last'.trim();
  }

  String get initials {
    final first = (firstName != null && firstName!.isNotEmpty) ? firstName![0] : '';
    final last = (lastName != null && lastName!.isNotEmpty) ? lastName![0] : '';
    final computed = '$first$last'.toUpperCase();
    return computed.isEmpty ? 'U' : computed;
  }
}
