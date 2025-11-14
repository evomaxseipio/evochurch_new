// lib/src/features/auth/models/user_me_response.dart

import 'user_model.dart';

class UserMeResponse {
  final bool success;
  final String message;
  final User? data;

  UserMeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UserMeResponse.fromJson(Map<String, dynamic> json) {
    return UserMeResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? User.fromJson(json['data'] as Map<String, dynamic>)
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

