// ============================================
// 3. ROUTES WITH SHELLROUTE - app_route_config.dart
// lib/src/routes/app_route_config.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/pages/login_view.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/dashboard/pages/dashboard_view.dart';
import '../features/members/pages/member_list.dart';
import '../features/members/pages/profile_view.dart';
import '../features/members/providers/members_provider.dart';
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
      // Login route (without layout)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),

      // Shell route (with persistent layout)
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
            redirect: (context, state) {
              // Check if there's a selected member before showing the page
              // This is done in the redirect to avoid construction issues
              return null; // Allow navigation, Consumer will handle the null case
            },
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: Consumer(
                  builder: (context, ref, child) {
                    final selectedMember = ref.watch(selectedMemberProvider);
                    if (selectedMember == null) {
                      // If no member is selected, show message and button to go back
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person_off, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                'No member selected',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please select a member from the list to view their profile.',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () => context.go('/members'),
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Back to Members'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ProfileView(member: selectedMember);
                  },
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
});

// Temporary page for unimplemented routes
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
