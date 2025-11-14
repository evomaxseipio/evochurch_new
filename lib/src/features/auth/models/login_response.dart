// lib/src/features/auth/models/login_response.dart

class LoginData {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final bool mustChangePassword;
  final String userId;
  final int? churchId;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    this.tokenType = 'bearer',
    this.mustChangePassword = false,
    this.churchId,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String? ?? 'bearer',
      mustChangePassword: json['must_change_password'] as bool? ?? false,
      userId: json['user_id'] as String,
      churchId: json['church_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'must_change_password': mustChangePassword,
      'user_id': userId,
      if (churchId != null) 'church_id': churchId,
    };
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final LoginData? data;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

