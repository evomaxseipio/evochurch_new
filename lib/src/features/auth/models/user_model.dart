// lib/src/features/auth/models/user_model.dart

class User {
  final String id;
  final String email;
  final bool isActive;
  final bool isVerified;
  final bool mustChangePassword;
  final String oauthProvider;
  final DateTime createdAt;
  final ProfileBasic? profile;

  User({
    required this.id,
    required this.email,
    required this.isActive,
    required this.isVerified,
    required this.mustChangePassword,
    required this.oauthProvider,
    required this.createdAt,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      mustChangePassword: json['must_change_password'] as bool? ?? false,
      oauthProvider: json['oauth_provider'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      profile: json['profile'] != null
          ? ProfileBasic.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'is_active': isActive,
      'is_verified': isVerified,
      'must_change_password': mustChangePassword,
      'oauth_provider': oauthProvider,
      'created_at': createdAt.toIso8601String(),
      'profile': profile?.toJson(),
    };
  }

  // Helper getters para compatibilidad
  String? get fullName {
    if (profile?.firstName != null && profile?.lastName != null) {
      return '${profile!.firstName} ${profile!.lastName}';
    }
    return profile?.firstName ?? profile?.lastName;
  }

  String? get avatarUrl => profile?.profilePictureUrl;
  
  Map<String, dynamic>? get userMetadata {
    if (profile == null) return null;
    return {
      'first_name': profile!.firstName,
      'last_name': profile!.lastName,
      'role': profile!.role,
      'profile_picture_url': profile!.profilePictureUrl,
    };
  }
}

class ProfileBasic {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? nickName;
  final String role;
  final String? profilePictureUrl;

  ProfileBasic({
    required this.id,
    this.firstName,
    this.lastName,
    this.nickName,
    required this.role,
    this.profilePictureUrl,
  });

  factory ProfileBasic.fromJson(Map<String, dynamic> json) {
    return ProfileBasic(
      id: json['id'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      nickName: json['nick_name'] as String?,
      role: json['role'] as String,
      profilePictureUrl: json['profile_picture_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'nick_name': nickName,
      'role': role,
      'profile_picture_url': profilePictureUrl,
    };
  }
}
