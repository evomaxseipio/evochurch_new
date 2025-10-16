// lib/src/features/members/widgets/member_stats_cards.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/member_model.dart';

class MemberStatsCards extends ConsumerWidget {
  final AsyncValue<List<Member>> membersAsync;

  const MemberStatsCards({
    super.key,
    required this.membersAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return membersAsync.when(
      data: (members) => _buildStatsGrid(members),
      loading: () => _buildLoadingGrid(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatsGrid(List<Member> members) {
    final stats = _calculateStats(members);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width < 768
            ? 2
            : width < 1024
                ? 3
                : 4;
        final childAspectRatio = width < 768 ? 1.5 : 2.6;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
          children: [
            _StatCard(
              title: 'Total Members',
              value: stats['total'].toString(),
              icon: Icons.people,
              color: const Color(0xFF667eea),
              trend: '+12.5%',
              footer: 'All members',
            ),
            _StatCard(
              title: 'Active',
              value: stats['active'].toString(),
              icon: Icons.person_add_alt,
              color: const Color(0xFF38ef7d),
              trend: '+8.2%',
              footer: 'Currently active',
            ),
            _StatCard(
              title: 'Inactive',
              value: stats['inactive'].toString(),
              icon: Icons.person_off,
              color: const Color(0xFFf5576c),
              trend: '-2.1%',
              footer: 'Not active',
            ),
            _StatCard(
              title: 'New This Month',
              value: stats['newThisMonth'].toString(),
              icon: Icons.new_releases,
              color: const Color(0xFF00f2fe),
              trend: 'This Month',
              footer: 'Recently joined',
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width < 768
            ? 2
            : width < 1024
                ? 3
                : 4;
        final childAspectRatio = width < 768 ? 1.5 : 2.6;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
          children: List.generate(4, (index) => const _LoadingCard()),
        );
      },
    );
  }

  Map<String, int> _calculateStats(List<Member> members) {
    final totalMembers = members.length;
    final activeMembers = members.where((m) => m.isActive == true).length;
    final inactiveMembers = members.where((m) => m.isActive == false).length;

    // TODO: Implement proper logic to check members created this month
    final newThisMonth = 0;

    return {
      'total': totalMembers,
      'active': activeMembers,
      'inactive': inactiveMembers,
      'newThisMonth': newThisMonth,
    };
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final String footer;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_upward,
                          size: 12, color: Colors.green.shade600),
                      const SizedBox(width: 2),
                      Text(
                        trend,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
