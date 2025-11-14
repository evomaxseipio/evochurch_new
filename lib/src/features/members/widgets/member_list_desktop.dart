// lib/src/features/members/widgets/member_list_desktop.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../components/datatable/datatable_component.dart';
import '../models/member_model.dart';
import '../providers/members_provider.dart';
import 'member_table_cells.dart';

class MemberListDesktop extends HookConsumerWidget {
  final ValueNotifier<String>? searchQuery;

  const MemberListDesktop({
    super.key,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all members (the component will handle pagination and search locally)
    final membersAsync = ref.watch(membersProvider);

    // Memoize columns to avoid rebuilds
    final columns = useMemoized(() => _buildSortColumns());

    return membersAsync.when(
      data: (members) {
        return CustomPaginatedTable<Member>(
          title: 'Members',
          data: members,
          columns: columns,
          getCells: (member) => _buildCells(context, member),
          filterFunction: (member, query) {
            final searchLower = query.toLowerCase();
            return member.firstName.toLowerCase().contains(searchLower) ||
                   member.lastName.toLowerCase().contains(searchLower) ||
                   (member.contact.email ?? '').toLowerCase().contains(searchLower) ||
                   (member.contact.phone ?? '').toLowerCase().contains(searchLower);
          },
          actionMenuBuilder: (context, member) => _buildActionMenu(context, member),
          onActionSelected: (action, member) => _handleAction(context, ref, action, member),
          onRowTap: (member) {
            ref.read(selectedMemberProvider.notifier).select(member);
            context.go('/members/profile');
          },
        );
      },
      loading: () {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, stack) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading members',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(membersProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build sort columns for CustomPaginatedTable
  static List<SortColumn> _buildSortColumns() {
    return [
      SortColumn(
        label: 'Name',
        field: 'first_name',
        getValue: (item) => '${(item as Member).firstName} ${item.lastName}',
      ),
      SortColumn(
        label: 'Email',
        field: 'email',
        getValue: (item) => (item as Member).contact.email ?? '',
      ),
      SortColumn(
        label: 'Phone',
        field: 'phone',
        getValue: (item) => (item as Member).contact.phone ?? '',
      ),
      SortColumn(
        label: 'Gender',
        field: 'gender',
        getValue: (item) => (item as Member).gender,
      ),
      SortColumn(
        label: 'Role',
        field: 'membership_role',
        getValue: (item) => (item as Member).membershipRole,
      ),
      SortColumn(
        label: 'Nationality',
        field: 'nationality',
        getValue: (item) => (item as Member).nationality,
      ),
      SortColumn(
        label: 'Status',
        field: 'is_active',
        getValue: (item) => (item as Member).isActive ? 'Active' : 'Inactive',
      ),
    ];
  }

  // Build cells for each row
  static List<DataCell> _buildCells(BuildContext context, Member member) {
    return [
      DataCell(MemberNameCell(member: member)),
      DataCell(MemberEmailCell(member: member)),
      DataCell(MemberPhoneCell(member: member)),
      DataCell(MemberGenderCell(member: member)),
      DataCell(MemberRoleCell(member: member)),
      DataCell(MemberNationalityCell(member: member)),
      DataCell(MemberStatusCell(member: member)),
    ];
  }

  // Build action menu
  static List<PopupMenuEntry<String>> _buildActionMenu(BuildContext context, Member member) {
    return [
      const PopupMenuItem(
        value: 'view',
        child: Row(
          children: [
            Icon(Icons.visibility, size: 18),
            SizedBox(width: 8),
            Text('View Profile'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 'edit',
        child: Row(
          children: [
            Icon(Icons.edit, size: 18),
            SizedBox(width: 8),
            Text('Edit'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 'finances',
        child: Row(
          children: [
            Icon(Icons.monetization_on, size: 18),
            SizedBox(width: 8),
            Text('Finances'),
          ],
        ),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red, size: 18),
            SizedBox(width: 8),
            Text('Delete', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    ];
  }

  // Handle action selection
  static void _handleAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    Member member,
  ) {
    ref.read(selectedMemberProvider.notifier).select(member);
    switch (action) {
      case 'view':
        context.go('/members/profile');
        break;
      case 'edit':
        context.go('/members/edit');
        break;
      case 'finances':
        context.go('/members/finances');
        break;
      case 'delete':
        _showDeleteDialog(context, ref, member);
        break;
    }
  }

  static Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    Member member,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: Text(
          'Are you sure you want to delete ${member.firstName} ${member.lastName}? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // TODO: Implement actual deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${member.firstName} ${member.lastName} deleted'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}