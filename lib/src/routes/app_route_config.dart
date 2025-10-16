// ============================================
// 3. ROUTES CON SHELLROUTE - app_route_config.dart
// lib/src/routes/app_route_config.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import '../features/auth/pages/login_view.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/dashboard/pages/dashboard_view.dart';
import '../features/members/pages/member_list.dart';
import '../layout/admin_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      // Login route (sin layout)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),

      // Shell route (con layout persistente)
      ShellRoute(
        builder: (context, state, child) {
          return AdminScaffold(body: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardView(),
            ),
          ),
          GoRoute(
            path: '/members',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MemberList(),
            ),
          ),
          GoRoute(
            path: '/finances',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlaceholderPage(title: 'Finances'),
            ),
          ),
          GoRoute(
            path: '/events',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlaceholderPage(title: 'Events'),
            ),
          ),
          GoRoute(
            path: '/donations',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlaceholderPage(title: 'Donations'),
            ),
          ),
          GoRoute(
            path: '/reports',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlaceholderPage(title: 'Reports'),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlaceholderPage(title: 'Settings'),
            ),
          ),
          GoRoute(
            path: '/members/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlaceholderPage(title: 'Profile'),
            ),
          ),
        ],
      ),
    ],
  );
});

// Página temporal para rutas sin implementar
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '$title - Coming Soon',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey.shade700,
                ),
          ),
        ],
      ),
    );
  }
}
