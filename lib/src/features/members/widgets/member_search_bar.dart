// lib/src/features/members/widgets/member_search_bar.dart

import 'package:flutter/material.dart';

class MemberSearchBar extends StatelessWidget {
  final ValueNotifier<String> searchQuery;

  const MemberSearchBar({
    super.key,
    required this.searchQuery,
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
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search members...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF667eea)),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            searchQuery.value = '';
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  searchQuery.value = value;
                },
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Show filters dialog
                _showFiltersDialog(context);
              },
              icon: const Icon(Icons.filter_list, size: 18),
              label: const Text('Filters'),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFiltersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Members'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: true,
                    onSelected: (value) {
                      // TODO: Implement filter logic
                    },
                  ),
                  FilterChip(
                    label: const Text('Active'),
                    selected: false,
                    onSelected: (value) {
                      // TODO: Implement filter logic
                    },
                  ),
                  FilterChip(
                    label: const Text('Inactive'),
                    selected: false,
                    onSelected: (value) {
                      // TODO: Implement filter logic
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Member Type',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: true,
                    onSelected: (value) {
                      // TODO: Implement filter logic
                    },
                  ),
                  FilterChip(
                    label: const Text('Regular'),
                    selected: false,
                    onSelected: (value) {
                      // TODO: Implement filter logic
                    },
                  ),
                  FilterChip(
                    label: const Text('New'),
                    selected: false,
                    onSelected: (value) {
                      // TODO: Implement filter logic
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Reset'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Apply filters
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
            ),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
