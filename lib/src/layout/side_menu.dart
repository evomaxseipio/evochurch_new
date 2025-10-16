// ============================================
// 2. SIDE MENU MEJORADO - side_menu.dart
// lib/src/layout/side_menu.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

// Provider para trackear la ruta actual
final currentRouteProvider = StateProvider<String>((ref) => '/');

class SideMenu extends HookConsumerWidget {
  final bool isCollapsed;

  const SideMenu({super.key, this.isCollapsed = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = ref.watch(currentRouteProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(
              vertical: isCollapsed ? 16 : 24,
              horizontal: isCollapsed ? 12 : 24,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      const Icon(Icons.church, color: Colors.white, size: 20),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'EvoChurch',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Management',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(isCollapsed ? 8 : 12),
              children: [
                _buildNavItem(
                  context,
                  ref,
                  icon: Icons.home,
                  label: 'Dashboard',
                  route: '/',
                  isActive: currentRoute == '/',
                ),
                _buildNavItem(
                  context,
                  ref,
                  icon: Icons.people,
                  label: 'Members',
                  route: '/members',
                  badge: isCollapsed ? null : '1,248',
                  isActive: currentRoute == '/members',
                ),
                _buildNavItem(
                  context,
                  ref,
                  icon: Icons.attach_money,
                  label: 'Finances',
                  route: '/finances',
                  isActive: currentRoute == '/finances',
                ),
                _buildNavItem(
                  context,
                  ref,
                  icon: Icons.event,
                  label: 'Events',
                  route: '/events',
                  badge: isCollapsed ? null : '12',
                  isActive: currentRoute == '/events',
                ),
                _buildNavItem(
                  context,
                  ref,
                  icon: Icons.favorite,
                  label: 'Donations',
                  route: '/donations',
                  isActive: currentRoute == '/donations',
                ),
                _buildNavItem(
                  context,
                  ref,
                  icon: Icons.bar_chart,
                  label: 'Reports',
                  route: '/reports',
                  isActive: currentRoute == '/reports',
                ),
                _buildNavItem(
                  context,
                  ref,
                  icon: Icons.settings,
                  label: 'Settings',
                  route: '/settings',
                  isActive: currentRoute == '/settings',
                ),
              ],
            ),
          ),

          // User Profile at bottom
          Container(
            padding: EdgeInsets.symmetric(
              vertical: isCollapsed ? 12 : 16,
              horizontal: isCollapsed ? 12 : 16,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: isCollapsed
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF667eea),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'PJ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        icon: Icon(Icons.logout,
                            color: Colors.grey.shade600, size: 20),
                        onPressed: () {
                          // TODO: Implement logout
                          context.go('/login');
                        },
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF667eea),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'PJ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Pastor John',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout,
                            color: Colors.grey.shade600, size: 20),
                        onPressed: () {
                          // TODO: Implement logout
                          context.go('/login');
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String label,
    required String route,
    String? badge,
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(currentRouteProvider.notifier).state = route;
            context.go(route);

            // Cerrar drawer en móvil
            if (MediaQuery.of(context).size.width < 768) {
              Navigator.of(context).pop();
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 12 : 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF667eea) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: isCollapsed
                ? Center(
                    child: Stack(
                      children: [
                        Icon(
                          icon,
                          size: 20,
                          color: isActive ? Colors.white : Colors.grey.shade700,
                        ),
                        if (badge != null)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: isActive ? Colors.white : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                isActive ? Colors.white : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? Colors.white
                                  : const Color(0xFF667eea),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
