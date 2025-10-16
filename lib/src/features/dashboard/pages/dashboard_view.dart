// ============================================
// 4. DASHBOARD VIEW (SIN AdminScaffold)
// lib/src/features/dashboard/pages/dashboard_view.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/upcoming_events_card.dart';
import '../widgets/financial_chart_card.dart';
import '../widgets/donation_breakdown_card.dart';

class DashboardView extends HookConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 768;
        final isTablet = width >= 768 && width < 1024;
        final isDesktop = width >= 1024;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Grid
              _buildStatsGrid(isMobile, isTablet, isDesktop),

              const SizedBox(height: 32),

              // Charts Row
              _buildChartsRow(isMobile, isTablet, isDesktop),

              const SizedBox(height: 32),

              // Bottom Grid
              _buildBottomGrid(isMobile, isTablet, isDesktop),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(bool isMobile, bool isTablet, bool isDesktop) {
    int crossAxisCount = isMobile
        ? 1
        : isTablet
            ? 2
            : 4;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: isMobile ? 1.4 : 1.7,
      children: const [
        StatCard(
          title: 'Total Members',
          value: '1,248',
          icon: Icons.people,
          color: Color(0xFF667eea),
          trend: '+12.5%',
          footer: '+150 this month',
        ),
        StatCard(
          title: 'Weekly Attendance',
          value: '892',
          icon: Icons.person_add_alt,
          color: Color(0xFF38ef7d),
          trend: '+8.2%',
          footer: '71% of members',
        ),
        StatCard(
          title: 'Monthly Income',
          value: '\$27,450',
          icon: Icons.attach_money,
          color: Color(0xFFfee140),
          trend: '+23.1%',
          footer: 'Goal: \$25,000',
        ),
        StatCard(
          title: 'Events This Week',
          value: '8',
          icon: Icons.event,
          color: Color(0xFF00f2fe),
          trend: 'This Week',
          footer: '3 events today',
        ),
      ],
    );
  }

  Widget _buildChartsRow(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile || isTablet) {
      return const Column(
        children: [
          FinancialChartCard(),
          SizedBox(height: 20),
          DonationBreakdownCard(),
        ],
      );
    }

    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: FinancialChartCard(),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: DonationBreakdownCard(),
        ),
      ],
    );
  }

  Widget _buildBottomGrid(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile || isTablet) {
      return const Column(
        children: [
          QuickActionsCard(),
          SizedBox(height: 20),
          RecentActivityCard(),
          SizedBox(height: 20),
          UpcomingEventsCard(),
        ],
      );
    }

    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: QuickActionsCard()),
        SizedBox(width: 20),
        Expanded(child: RecentActivityCard()),
        SizedBox(width: 20),
        Expanded(child: UpcomingEventsCard()),
      ],
    );
  }
}
