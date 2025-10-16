// ============================================
// 9. DONATION BREAKDOWN CARD
// lib/src/features/dashboard/widgets/donation_breakdown_card.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DonationBreakdownCard extends StatelessWidget {
  const DonationBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Donation Breakdown',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Current month distribution',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 60,
                    sections: [
                      PieChartSectionData(
                        value: 65,
                        title: '65%',
                        color: const Color(0xFF667eea),
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: 25,
                        title: '25%',
                        color: const Color(0xFF38ef7d),
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: 10,
                        title: '10%',
                        color: const Color(0xFF764ba2),
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildBreakdownItem(
                'Tithes', '\$17,845 (65%)', const Color(0xFF667eea)),
            const SizedBox(height: 12),
            _buildBreakdownItem(
                'Offerings', '\$6,863 (25%)', const Color(0xFF38ef7d)),
            const SizedBox(height: 12),
            _buildBreakdownItem(
                'Special Funds', '\$2,742 (10%)', const Color(0xFF764ba2)),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownItem(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
