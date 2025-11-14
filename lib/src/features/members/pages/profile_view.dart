import 'package:evochurch_new/src/features/members/models/member_model.dart';
import 'package:evochurch_new/src/shared/constants/sizedbox.dart';
import 'package:evochurch_new/src/shared/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'member_maintance.dart';
import 'membership_page.dart';

class ProfileView extends HookConsumerWidget {
  final Member? member;

  const ProfileView({this.member, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenuItem = useState('Profile');
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final isMobile = Responsive.isMobile(context);
    final isHovered = useState<String?>(null);

    void selectMenuItem(String item) {
      selectedMenuItem.value = item;
      if (isMobile) {
        scaffoldKey.currentState?.closeDrawer();
      }
    }

    Widget getContent() {
      switch (selectedMenuItem.value) {
        case 'Profile':
          return MemberMaintance(member: member);
        case 'Membership':
          return const MembershipPage();
        case 'Finances':
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Finances section coming soon',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        case 'Delete Account':
          return _buildDeleteAccountContent(context, selectedMenuItem);
        default:
          return Container();
      }
    }

    Widget buildProfileHeader() {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar con animación
            Hero(
              tag: 'profile_${member?.memberId ?? 'default'}',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 47,
                    backgroundColor:
                        Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    child: Text(
                      _getInitials(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Nombre del miembro
            Text(
              member != null
                  ? '${member!.firstName} ${member!.lastName}'
                  : 'Member Profile',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            if (member?.membershipRole != null) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  member!.membershipRole,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    Widget buildSidebar() {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            EvoBox.h16,
            // Header del perfil
            buildProfileHeader(),

            const SizedBox(height: 24),

            // Título de navegación
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Navigation',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.6),
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Menú items - CORREGIDO: Usar Expanded en lugar de Flexible
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAnimatedMenuItem(
                      context: context,
                      title: 'Profile',
                      icon: Icons.person_outline,
                      selectedIcon: Icons.person,
                      selectedItem: selectedMenuItem.value,
                      isHovered: isHovered,
                      onTap: () => selectMenuItem('Profile'),
                    ),
                    const SizedBox(height: 8),
                    _buildAnimatedMenuItem(
                      context: context,
                      title: 'Membership',
                      icon: Icons.group_outlined,
                      selectedIcon: Icons.group,
                      selectedItem: selectedMenuItem.value,
                      isHovered: isHovered,
                      onTap: () => selectMenuItem('Membership'),
                    ),
                    const SizedBox(height: 8),
                    _buildAnimatedMenuItem(
                      context: context,
                      title: 'Finances',
                      icon: Icons.account_balance_wallet_outlined,
                      selectedIcon: Icons.account_balance_wallet,
                      selectedItem: selectedMenuItem.value,
                      isHovered: isHovered,
                      onTap: () => selectMenuItem('Finances'),
                    ),

                    const SizedBox(height: 32),

                    // Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildAnimatedMenuItem(
                      context: context,
                      title: 'Delete Account',
                      icon: Icons.delete_outline,
                      selectedIcon: Icons.delete,
                      selectedItem: selectedMenuItem.value,
                      isHovered: isHovered,
                      isDestructive: true,
                      onTap: () => selectMenuItem('Delete Account'),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'EvoChurch v1.0',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.4),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    Widget buildMobileLayout() {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(selectedMenuItem.value),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          elevation: 0,
        ),
        drawer: Drawer(
          child: buildSidebar(),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey(selectedMenuItem.value),
            child: getContent(),
          ),
        ),
      );
    }

    Widget buildDesktopLayout() {
      return Scaffold(
        body: 
        
        Row(
          children: [
            // Sidebar
            SizedBox(
              width: 280,
              child: buildSidebar(),
            ),

            // Main Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.05, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey(selectedMenuItem.value),
                  child: getContent(),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return isMobile ? buildMobileLayout() : buildDesktopLayout();
  }

  String _getInitials() {
    if (member == null) return 'MP';
    final first = member!.firstName.isNotEmpty ? member!.firstName[0] : '';
    final last = member!.lastName.isNotEmpty ? member!.lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  Widget _buildAnimatedMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required IconData selectedIcon,
    required String selectedItem,
    required ValueNotifier<String?> isHovered,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final isSelected = title == selectedItem;
    final isHovering = isHovered.value == title;

    return MouseRegion(
      onEnter: (_) => isHovered.value = title,
      onExit: (_) => isHovered.value = null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDestructive
                  ? Colors.red.withValues(alpha: 0.1)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.12))
              : isHovering
                  ? (isDestructive
                      ? Colors.red.withValues(alpha: 0.05)
                      : Theme.of(context).primaryColor.withValues(alpha: 0.05))
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDestructive
                    ? Colors.red.withValues(alpha: 0.3)
                    : Theme.of(context).primaryColor.withValues(alpha: 0.3))
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isSelected ? selectedIcon : icon,
                      color: isDestructive
                          ? Colors.red
                          : isSelected || isHovering
                              ? Theme.of(context).primaryColor
                              : Theme.of(context)
                                  .iconTheme
                                  .color
                                  ?.withValues(alpha: 0.6),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isDestructive
                            ? Colors.red
                            : isSelected
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (isSelected)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDestructive
                            ? Colors.red
                            : Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountContent(
      BuildContext context, ValueNotifier<String> selectedMenuItem) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 48,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Delete Account',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'This action cannot be undone. All data associated with this member will be permanently deleted.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Navegar de vuelta al perfil
                          selectedMenuItem.value = 'Profile';
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showDeleteConfirmationDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you absolutely sure you want to delete this account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Aquí iría la lógica real para eliminar la cuenta
                _performAccountDeletion();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _performAccountDeletion() {
    // TODO: Implementar la lógica real de eliminación de cuenta
    // Esto podría incluir llamadas a APIs, actualizaciones de base de datos, etc.
    debugPrint('Account deletion logic would go here');
  }
}
