// lib/src/features/auth/models/user_model.dart

class AppUser {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final Map<String, dynamic>? metadata;

  AppUser({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.metadata,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'metadata': metadata,
    };
  }

  String? get churchId => metadata?['church_id'];
  String? get profileId => metadata?['profile_id'];
  String? get role => metadata?['role'];
}
