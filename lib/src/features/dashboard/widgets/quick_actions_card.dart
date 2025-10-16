// ============================================
// 5. QUICK ACTIONS CARD
// lib/src/features/dashboard/widgets/quick_actions_card.dart
// ============================================

import 'package:flutter/material.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

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
              'Quick Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              'Add New Member',
              Icons.person_add,
              isPrimary: true,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'Record Donation',
              Icons.volunteer_activism,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'Create Event',
              Icons.event,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'Add Expense',
              Icons.receipt_long,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon,
      {bool isPrimary = false, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF667eea) : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.black87,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: Colors.grey.shade300, width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward, size: 16),
          ],
        ),
      ),
    );
  }
}
