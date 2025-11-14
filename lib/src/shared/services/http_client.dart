// lib/src/shared/services/http_client.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../constants/api_config.dart';
import 'token_storage.dart';
import 'logger_service.dart';

class ApiClient {
  late final Dio _dio;
  bool _isRefreshing = false;

  ApiClient() {
    final baseUrl = ApiConfig.baseUrl;
    
    // Log configuration for debugging
    if (kIsWeb) {
      LoggerService.info('🌐 Web platform detected. Base URL: $baseUrl');
      LoggerService.info('🌐 Make sure your backend server is running and accessible at: $baseUrl');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Interceptor para agregar Bearer token automáticamente
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          final fullUrl = '${options.baseUrl}${options.path}';
          LoggerService.info('🌐 API Request: ${options.method} $fullUrl');
          if (kIsWeb) {
            LoggerService.info('🌐 Request Headers: ${options.headers}');
          }
          if (options.queryParameters.isNotEmpty) {
            LoggerService.debug('Query Params: ${options.queryParameters}');
          }
          if (options.data != null) {
            LoggerService.debug('Request Body: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          LoggerService.info('API Response: ${response.statusCode} ${response.requestOptions.path}');

          // Validate response data
          if (response.data == null) {
            LoggerService.warning('Response data is null for ${response.requestOptions.path}');
          } else if (response.data is String && (response.data as String).isEmpty) {
            LoggerService.error('Response body is empty string for ${response.requestOptions.path}');
            // Convert empty string to error
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
                error: 'Server returned empty response',
              ),
            );
          }

          return handler.next(response);
        },
        onError: (error, handler) async {
          LoggerService.error(
            'API Error: ${error.response?.statusCode} ${error.requestOptions.path}',
            error,
          );
          LoggerService.debug('Error Type: ${error.type}');
          LoggerService.debug('Error Message: ${error.message}');

          // Log response data if available
          if (error.response?.data != null) {
            LoggerService.debug('Error Response Data: ${error.response?.data}');
          }

          // Log CORS/connection errors with helpful message
          if (error.type == DioExceptionType.connectionError) {
            final requestUrl = '${error.requestOptions.baseUrl}${error.requestOptions.path}';
            LoggerService.warning(
              '⚠️ Connection error detected!\n'
              '   Request URL: $requestUrl\n'
              '   Base URL: ${error.requestOptions.baseUrl}\n'
              '   Error: ${error.message}\n'
              '\n'
              'Possible causes:\n'
              '1. Backend server is not running at ${error.requestOptions.baseUrl}\n'
              '2. CORS not properly configured (check backend allows your origin)\n'
              '3. Firewall/proxy blocking the connection\n'
              '4. Wrong port or URL\n'
              '\n'
              'To fix:\n'
              '1. Verify backend is running: curl ${error.requestOptions.baseUrl}/api/auth/login\n'
              '2. Check browser console for CORS errors\n'
              '3. Verify CORS allows: ${kIsWeb ? "http://localhost:<flutter_port>" : "your-app-origin"}',
            );
          }

          // Si el token expiró (401), intentar refresh
          // No hacer refresh si ya estamos refrescando o si es la petición de refresh misma
          if (error.response?.statusCode == 401 &&
              !_isRefreshing &&
              !error.requestOptions.path.contains('/auth/refresh')) {
            try {
              _isRefreshing = true;
              final refreshed = await _refreshToken();
              _isRefreshing = false;

              if (refreshed) {
                // Reintentar la petición original con el nuevo token
                final opts = error.requestOptions;
                final token = await TokenStorage.getAccessToken();
                opts.headers['Authorization'] = 'Bearer $token';
                final response = await _dio.fetch(opts);
                return handler.resolve(response);
              }
            } catch (e) {
              _isRefreshing = false;
              // Si falla el refresh, limpiar tokens y retornar el error
              await TokenStorage.clearTokens();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      // Crear un Dio instance sin interceptores para evitar loops
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await refreshDio.post(
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

  // GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

