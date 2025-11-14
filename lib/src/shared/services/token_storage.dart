// lib/src/shared/services/token_storage.dart

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _churchIdKey = 'church_id';

  // Guardar access token
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  // Obtener access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Guardar refresh token
  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  // Obtener refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Guardar user ID
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  // Obtener user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Guardar church ID
  static Future<void> saveChurchId(int churchId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_churchIdKey, churchId);
  }

  // Obtener church ID
  static Future<int?> getChurchId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_churchIdKey);
  }

  // Guardar ambos tokens y user ID
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
    int? churchId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final futures = [
      prefs.setString(_accessTokenKey, accessToken),
      prefs.setString(_refreshTokenKey, refreshToken),
      prefs.setString(_userIdKey, userId),
    ];
    if (churchId != null) {
      futures.add(prefs.setInt(_churchIdKey, churchId));
    }
    await Future.wait(futures);
  }

  // Limpiar todos los tokens (logout)
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_accessTokenKey),
      prefs.remove(_refreshTokenKey),
      prefs.remove(_userIdKey),
      prefs.remove(_churchIdKey),
    ]);
  }

  // Verificar si hay tokens guardados
  static Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}

