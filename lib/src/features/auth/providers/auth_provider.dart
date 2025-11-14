// lib/src/features/auth/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/api_client_provider.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

// Provider para preservar el email del login entre reconstrucciones
final loginEmailProvider = StateProvider<String>((ref) => 'mseipio.evotechrd@gmail.com');

// Provider del servicio
final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthService(client);
});

// Stream del usuario actual
final authUserProvider = StreamProvider<User?>((ref) {
  final service = ref.watch(authServiceProvider);
  return service.authStateChanges;
});

// Notifier de autenticación
class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final service = ref.watch(authServiceProvider);
    return service.currentUser;
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(authServiceProvider);
      final response = await service.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.success && response.data != null) {
        // El servicio ya guardó los tokens y obtuvo el usuario
        return service.currentUser;
      } else {
        throw Exception(response.message);
      }
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(authServiceProvider);
      await service.signInWithGoogle();
      return service.currentUser;
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(authServiceProvider);
      await service.signOut();
      return null;
    });
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  () => AuthNotifier(),
);
