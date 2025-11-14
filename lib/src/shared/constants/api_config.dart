// lib/src/shared/constants/api_config.dart

import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static const bool isLocal = true; // Change to false for production

  static String get baseUrl {
    if (isLocal) {
      // On web, use localhost instead of 127.0.0.1 to avoid CORS issues
      // Browser treats localhost and 127.0.0.1 as different origins
      if (kIsWeb) {
        return 'http://localhost:8000';
      }
      return 'http://127.0.0.1:8000';
    } else {
      // Production URL when available
      return 'https://api.evochurch.com';
    }
  }
  
  // Authentication endpoints
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String refreshEndpoint = '/api/auth/refresh';
  static const String meEndpoint = '/api/auth/me';
  static const String changePasswordEndpoint = '/api/auth/change-password';
  static const String resetPasswordEndpoint = '/api/auth/reset-password';
  
  // Members endpoints
  static const String profilesEndpoint = '/api/profiles/';
  
  // Membership endpoints
  static String membershipEndpoint(String memberId) => '/api/profiles/$memberId/membership/';
  static const String memberRolesEndpoint = '/api/members/roles/';
}

