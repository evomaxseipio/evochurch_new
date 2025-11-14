// lib/src/features/members/widgets/member_stats_cards.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/utils/responsive_utils.dart';
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
        final crossAxisCount = ResponsiveUtils.getGridColumns(context);
        final isMobile = ResponsiveUtils.isMobile(context);
        final isTablet = ResponsiveUtils.isTablet(context);
        final childAspectRatio = isMobile ? 1.4 : isTablet ? 1.9 : 2.3;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
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
        final crossAxisCount = ResponsiveUtils.getGridColumns(context);
        final isMobile = ResponsiveUtils.isMobile(context);
        final isTablet = ResponsiveUtils.isTablet(context);
        final childAspectRatio = isMobile ? 1.4 : isTablet ? 1.9 : 2.3;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
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
    const newThisMonth = 0;

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
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.05),
              color.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 10 : isTablet ? 12 : 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: isMobile ? 32 : isTablet ? 36 : 40,
                    height: isMobile ? 32 : isTablet ? 36 : 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: isMobile ? 16 : isTablet ? 18 : 20,
                    ),
                  ),
                  if (trend.isNotEmpty && trend != 'This Month')
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 5 : 6,
                        vertical: isMobile ? 2 : 3,
                      ),
                      decoration: BoxDecoration(
                        color: trend.startsWith('+')
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            trend.startsWith('+') ? Icons.arrow_upward : Icons.arrow_downward,
                            size: isMobile ? 9 : 10,
                            color: trend.startsWith('+')
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                          SizedBox(width: 2),
                          Text(
                            trend,
                            style: TextStyle(
                              fontSize: isMobile ? 8 : 9,
                              fontWeight: FontWeight.w600,
                              color: trend.startsWith('+')
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (trend == 'This Month')
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 5 : 6,
                        vertical: isMobile ? 2 : 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'New',
                        style: TextStyle(
                          fontSize: isMobile ? 8 : 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: isMobile ? 8 : 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 10 : isTablet ? 11 : 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: isMobile ? 4 : 6),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 20 : isTablet ? 24 : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                    height: 1.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : isTablet ? 14 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: isMobile ? 36 : isTablet ? 40 : 44,
                    height: isMobile ? 36 : isTablet ? 40 : 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    width: isMobile ? 40 : isTablet ? 45 : 50,
                    height: isMobile ? 18 : isTablet ? 20 : 22,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 10 : 12),
              Container(
                width: isMobile ? 70 : isTablet ? 80 : 90,
                height: isMobile ? 11 : isTablet ? 12 : 13,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              SizedBox(height: isMobile ? 6 : 8),
              Container(
                width: isMobile ? 50 : isTablet ? 60 : 70,
                height: isMobile ? 22 : isTablet ? 26 : 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
