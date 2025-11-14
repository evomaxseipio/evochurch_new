// lib/src/features/auth/services/auth_service.dart

import 'dart:async';
import '../../../shared/services/http_client.dart';
import '../../../shared/services/token_storage.dart';
import '../../../shared/constants/api_config.dart';
import '../models/user_model.dart';
import '../models/login_response.dart';
import '../models/user_me_response.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiClient _client;
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();
  User? _currentUser;

  AuthService(this._client) {
    _initializeUser();
  }

  // Obtener usuario actual
  User? get currentUser => _currentUser;

  // Stream de cambios de autenticación
  Stream<User?> get authStateChanges => _authStateController.stream;

  // Metadata del usuario (para compatibilidad)
  Map<String, dynamic>? get userMetaData => _currentUser?.userMetadata;

  // Inicializar usuario desde token guardado
  Future<void> _initializeUser() async {
    final hasTokens = await TokenStorage.hasTokens();
    if (hasTokens) {
      try {
        await getCurrentUser();
      } catch (e) {
        // Si falla, limpiar tokens
        await TokenStorage.clearTokens();
        _currentUser = null;
        _authStateController.add(null);
      }
    } else {
      _currentUser = null;
      _authStateController.add(null);
    }
  }

  // Login con email y password
  Future<LoginResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        ApiConfig.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        if (loginResponse.success && loginResponse.data != null) {
          final loginData = loginResponse.data!;

          // Guardar tokens y church_id
          await TokenStorage.saveTokens(
            accessToken: loginData.accessToken,
            refreshToken: loginData.refreshToken,
            userId: loginData.userId,
            churchId: loginData.churchId,
          );

          // Obtener información del usuario
          await getCurrentUser();

          return loginResponse;
        } else {
          throw Exception(loginResponse.message);
        }
      } else {
        throw Exception('Error al iniciar sesión: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data['detail'] != null) {
          throw Exception(data['detail'].toString());
        }
        throw Exception('Error al iniciar sesión: ${e.response!.statusCode}');
      }
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  // Obtener usuario actual
  Future<User?> getCurrentUser() async {
    try {
      final response = await _client.get(ApiConfig.meEndpoint);

      if (response.statusCode == 200) {
        final userMeResponse = UserMeResponse.fromJson(response.data);

        if (userMeResponse.success && userMeResponse.data != null) {
          _currentUser = userMeResponse.data;
          _authStateController.add(_currentUser);
          return _currentUser;
        }
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token inválido, limpiar y retornar null
        await TokenStorage.clearTokens();
        _currentUser = null;
        _authStateController.add(null);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await _client.post(
        ApiConfig.refreshEndpoint,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['success'] == true) {
          final tokenData = data['data'] as Map<String, dynamic>;
          final newAccessToken = tokenData['access_token'] as String;
          await TokenStorage.saveAccessToken(newAccessToken);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await TokenStorage.clearTokens();
    _currentUser = null;
    _authStateController.add(null);
  }

  // Sign in with Google (no disponible en la API actual)
  Future<void> signInWithGoogle() async {
    throw UnimplementedError('OAuth no está disponible en la API actual');
  }

  // Dispose del stream controller
  void dispose() {
    _authStateController.close();
  }
}
