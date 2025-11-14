import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'src/routes/app_route_config.dart';
import 'src/shared/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Suppress RawKeyboard assertion errors on Windows (Flutter framework bug)
  // This is a known issue with Alt key events on Windows
  FlutterError.onError = (FlutterErrorDetails details) {
    // Suppress specific RawKeyboard assertion errors
    if (details.exception.toString().contains('RawKeyDownEvent') &&
        details.exception.toString().contains('_keysPressed.isNotEmpty')) {
      // Silently ignore this specific error
      if (kDebugMode) {
        debugPrint('Suppressed RawKeyboard error: ${details.exception}');
      }
      return;
    }
    // For all other errors, use default handling
    FlutterError.presentError(details);
  };

  // Ya no necesitamos inicializar Supabase
  // Los tokens se cargarán automáticamente desde SharedPreferences

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'EvoChurch',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF667eea),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF667eea),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1a202c),
      ),
      routerConfig: router,
    );
  }
}
