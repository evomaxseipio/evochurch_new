// lib/src/features/auth/pages/login_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener el email preservado del provider
    final savedEmail = ref.watch(loginEmailProvider);
    final emailController = useTextEditingController(text: savedEmail);
    final passwordController = useTextEditingController(text: 'TempPass123!');
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isPasswordVisible = useState(false);
    final hasLoginError = useState(false);

    // Sincronizar el email con el provider cuando el usuario escribe
    useEffect(() {
      void listener() {
        ref.read(loginEmailProvider.notifier).state = emailController.text;
      }
      emailController.addListener(listener);
      return () => emailController.removeListener(listener);
    }, [emailController]);

    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            // Login exitoso - limpiar el email guardado
            ref.read(loginEmailProvider.notifier).state = '';
            context.go('/');
          }
        },
        error: (error, stack) {
          // Solo limpiar la contraseña por seguridad, mantener el email
          passwordController.clear();
          hasLoginError.value = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        },
      );
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.church,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'EvoChurch',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Church Management System',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(),
                      errorBorder: hasLoginError.value 
                          ? const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            )
                          : null,
                      focusedErrorBorder: hasLoginError.value
                          ? const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 2),
                            )
                          : null,
                      helperText: hasLoginError.value 
                          ? 'Email preserved - please check your password'
                          : null,
                      helperStyle: TextStyle(
                        color: hasLoginError.value ? Colors.orange : null,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      // Reset error state when user starts typing
                      if (hasLoginError.value) {
                        hasLoginError.value = false;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          isPasswordVisible.value = !isPasswordVisible.value;
                        },
                      ),
                    ),
                    obscureText: !isPasswordVisible.value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: authState.isLoading
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              ref.read(authProvider.notifier).signIn(
                                    emailController.text.trim(),
                                    passwordController.text,
                                  );
                            }
                          },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Login'),
                  ),
                  // OAuth buttons removed - not available in current API
                  // const SizedBox(height: 16),
                  // const Row(
                  //   children: [
                  //     Expanded(child: Divider()),
                  //     Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 16),
                  //       child: Text('OR'),
                  //     ),
                  //     Expanded(child: Divider()),
                  //   ],
                  // ),
                  // const SizedBox(height: 16),
                  // OutlinedButton.icon(
                  //   onPressed: authState.isLoading
                  //       ? null
                  //       : () {
                  //           ref.read(authProvider.notifier).signInWithGoogle();
                  //         },
                  //   icon: const Icon(Icons.g_mobiledata),
                  //   label: const Text('Sign in with Google'),
                  //   style: OutlinedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // OutlinedButton.icon(
                  //   onPressed: authState.isLoading
                  //       ? null
                  //       : () {
                  //           // ref.read(authProvider.notifier).signInWithApple();
                  //         },
                  //   icon: const Icon(Icons.apple),
                  //   label: const Text('Sign in with Apple'),
                  //   style: OutlinedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
