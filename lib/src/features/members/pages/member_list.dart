// lib/src/features/members/pages/member_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/members_provider.dart';
import '../widgets/member_list_desktop.dart';
import '../widgets/member_list_mobile.dart';
import '../widgets/member_stats_cards.dart';
import '../widgets/member_search_bar.dart';
import 'add_members.dart';

class MemberList extends HookConsumerWidget {
  const MemberList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(membersProvider);
    final searchQuery = useState('');

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isMobile, ref),
              const SizedBox(height: 32),

              MemberStatsCards(membersAsync: membersAsync),
              const SizedBox(height: 32),

              MemberSearchBar(searchQuery: searchQuery),
              const SizedBox(height: 24),

              // Separación: Desktop usa DataTable, Mobile usa ListView
              isMobile
                  ? MemberListMobile(
                      membersAsync: membersAsync,
                      searchQuery: searchQuery,
                    )
                  : MemberListDesktop(
                      membersAsync: membersAsync,
                      searchQuery: searchQuery,
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, WidgetRef ref) {
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your church members and their information',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

  Widget _buildDesktopActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () => callAddEmployeeModal(context, ref),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Member'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF667eea),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Export functionality
          },
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Export'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileActions(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => callAddEmployeeModal(context, ref),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add Member'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF667eea),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
