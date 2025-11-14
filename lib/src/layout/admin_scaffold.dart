// ============================================
// 1. LAYOUT RESPONSIVO - admin_scaffold.dart
// lib/src/layout/admin_scaffold.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:evochurch_new/src/layout/side_menu.dart';

// Provider para controlar el estado del drawer
final drawerOpenProvider = StateProvider<bool>((ref) => false);

// Provider para controlar el estado colapsado del sidebar en desktop
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);

class AdminScaffold extends HookConsumerWidget {
  final Widget body;

  const AdminScaffold({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());

    // Watch providers at the top level to avoid issues
    final isCollapsed = ref.watch(sidebarCollapsedProvider);

    // Breakpoints responsivos
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;
    final isTablet = width >= 768 && width < 1024;
    final isMobile = width < 768;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: (isMobile || isTablet)
          ? Drawer(
              width: isMobile ? 280 : 320, // Ancho máximo: 280px mobile, 320px tablet
              child: const SideMenu(),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar animado solo en desktop
            if (isDesktop)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isCollapsed ? 70 : 260,
                child: SideMenu(isCollapsed: isCollapsed),
              ),

            // Main Content
            Expanded(
              child: Column(
                children: [
                  // Top Bar
                  _buildTopBar(context, scaffoldKey, isDesktop, ref),

                  // Body Content
                  Expanded(
                    child: body,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, bool isDesktop, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: isMobile
          ? _buildMobileTopBar(context, scaffoldKey)
          : _buildDesktopTopBar(context, scaffoldKey, isDesktop, ref),
    );
  }

  Widget _buildMobileTopBar(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        Expanded(
          child: Text(
            'EvoChurch',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),
            Positioned(
              top: 8,
              right: 8,
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
      ],
    );
  }

  Widget _buildDesktopTopBar(BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, bool isDesktop, WidgetRef ref) {
    final isCollapsed = ref.watch(sidebarCollapsedProvider);

    return Row(
      children: [
        // Botón toggle para sidebar en desktop
        if (isDesktop)
          IconButton(
            icon: Icon(isCollapsed ? Icons.menu : Icons.menu_open),
            onPressed: () {
              ref.read(sidebarCollapsedProvider.notifier).state =
                  !isCollapsed;
            },
          )
        else if (!isDesktop)
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning, Pastor John! 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Here\'s what\'s happening with your church today',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Search (oculto en tablets pequeños)
        if (MediaQuery.of(context).size.width > 900)
          Container(
            width: 280,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon:
                    Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),

        const SizedBox(width: 12),

        // Notifications
        Stack(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.notifications_none, size: 20),
            ),
            Positioned(
              top: 8,
              right: 8,
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
      ],
    );
  }
}
