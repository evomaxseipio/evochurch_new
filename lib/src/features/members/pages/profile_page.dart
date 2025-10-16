import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 768;

      // Safely access theme and other inherited widgets
      final theme = Theme.of(context);
      final textTheme = theme.textTheme;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(context, isMobile, ref, textTheme),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(
      BuildContext context, bool isMobile, WidgetRef ref, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Members',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your church members and their information',
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (!isMobile) _buildDesktopActions(context, ref),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          _buildMobileActions(context, ref),
        ],
      ],
    );
  }

  _buildDesktopActions(BuildContext context, WidgetRef ref) {
    return const SizedBox();
  }

  _buildMobileActions(BuildContext context, WidgetRef ref) {
    return const SizedBox();
  }
}
