// lib/src/features/members/widgets/member_list_desktop.dart

import 'package:evochurch_new/src/features/members/pages/profile_page.dart';
import 'package:evochurch_new/src/features/members/pages/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/member_model.dart';
import '../providers/members_provider.dart';

class MemberListDesktop extends ConsumerStatefulWidget {
  final AsyncValue<List<Member>> membersAsync;
  final ValueNotifier<String> searchQuery;

  const MemberListDesktop({
    super.key,
    required this.membersAsync,
    required this.searchQuery,
  });

  @override
  ConsumerState<MemberListDesktop> createState() => _MemberListDesktopState();
}

class _MemberListDesktopState extends ConsumerState<MemberListDesktop> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return widget.membersAsync.when(
      data: (members) {
        if (members.isEmpty) {
          return _buildEmptyState();
        }

        final filteredMembers = _filterMembers(members);

        if (filteredMembers.isEmpty) {
          return _buildNoResultsState();
        }

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              // Table Header Info
              //  MemberSearchBar(searchQuery: widget.searchQuery),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredMembers.length} members found',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Page size: $_rowsPerPage',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // DataTable
              PaginatedDataTable(
                header: null,
                rowsPerPage: _rowsPerPage,
                availableRowsPerPage: const [5, 10, 20, 50],
                onRowsPerPageChanged: (value) {
                  setState(() {
                    _rowsPerPage = value ?? 10;
                  });
                },
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person,
                            size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        const Text('Name'),
                      ],
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                  ),
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.email,
                            size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        const Text('Email'),
                      ],
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                  ),
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone,
                            size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        const Text('Phone'),
                      ],
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                  ),
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wc, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        const Text('Gender'),
                      ],
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                  ),
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cake, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        const Text('Age'),
                      ],
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                  ),
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.badge,
                            size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        const Text('Role'),
                      ],
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                  ),
                  // DataColumn(
                  //   label: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Icon(Icons.favorite,
                  //           size: 16, color: Colors.grey.shade600),
                  //       const SizedBox(width: 4),
                  //       const Text('Marital'),
                  //     ],
                  //   ),
                  //   onSort: (columnIndex, ascending) {
                  //     setState(() {
                  //       _sortColumnIndex = columnIndex;
                  //       _sortAscending = ascending;
                  //     });
                  //   },
                  // ),
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flag, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        const Text('Nationality'),
                      ],
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                  ),
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        const Text('Status'),
                      ],
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                  ),
                  const DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.more_vert, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('Actions'),
                      ],
                    ),
                  ),
                ],
                source: _MemberDataSource(
                  members: filteredMembers,
                  context: context,
                  ref: ref,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(),
    );
  }

  List<Member> _filterMembers(List<Member> members) {
    final query = widget.searchQuery.value.toLowerCase();
    if (query.isEmpty) return members;

    return members.where((member) {
      final fullName =
          '${member.firstName ?? ''} ${member.lastName ?? ''}'.toLowerCase();
      final email = (member.contact.email ?? '').toLowerCase();
      return fullName.contains(query) || email.contains(query);
    }).toList();
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.people_outline,
                size: 40,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No members found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first member to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(60),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildErrorState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red.shade400),
            const SizedBox(height: 16),
            const Text('Error loading members'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(membersProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// DataSource para PaginatedDataTable
class _MemberDataSource extends DataTableSource {
  final List<Member> members;
  final BuildContext context;
  final WidgetRef ref;
  final int sortColumnIndex;
  final bool sortAscending;

  _MemberDataSource({
    required this.members,
    required this.context,
    required this.ref,
    required this.sortColumnIndex,
    required this.sortAscending,
  }) {
    _sortMembers();
  }

  void _sortMembers() {
    members.sort((a, b) {
      int comparison;
      switch (sortColumnIndex) {
        case 0: // Name
          final aName =
              '${a.firstName ?? ''} ${a.lastName ?? ''}'.toLowerCase();
          final bName =
              '${b.firstName ?? ''} ${b.lastName ?? ''}'.toLowerCase();
          comparison = aName.compareTo(bName);
          break;
        case 1: // Email
          comparison = (a.contact.email ?? '').compareTo(b.contact.email ?? '');
          break;
        case 2: // Phone
          comparison = (a.contact.phone ?? '').compareTo(b.contact.phone ?? '');
          break;
        case 3: // Gender
          comparison = a.gender.compareTo(b.gender);
          break;
        case 4: // Age
          comparison = a.dateOfBirth.compareTo(b.dateOfBirth);
          break;
        case 5: // Role
          comparison = a.membershipRole.compareTo(b.membershipRole);
          break;
        // case 6: // Marital Status
        //   comparison = a.maritalStatus.compareTo(b.maritalStatus);
        //   break;
        case 6: // Nationality
          comparison = (a.nationality ?? '').compareTo(b.nationality ?? '');
          break;
        case 8: // Status
          comparison = (a.isActive == true ? 1 : 0)
              .compareTo(b.isActive == true ? 1 : 0);
          break;
        default:
          comparison = 0;
      }
      return sortAscending ? comparison : -comparison;
    });
  }

  @override
  DataRow getRow(int index) {
    if (index >= members.length) return const DataRow(cells: []);

    final member = members[index];
    return DataRow(
      color: WidgetStateProperty.all(
        index % 2 == 0 ? Colors.grey.shade50 : Colors.white,
      ),
      cells: [
        // Name
        DataCell(
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: member.gender.toLowerCase() == 'male'
                        ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
                        : [const Color(0xFFf093fb), const Color(0xFFf5576c)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    (member.firstName?[0] ?? 'M').toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${member.firstName ?? ''} ${member.lastName ?? ''}'.trim(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Email
        DataCell(
          Tooltip(
            message: member.contact.email ?? 'No email',
            child: Text(
              member.contact.email ?? '-',
              style: TextStyle(
                color: member.contact.email != null
                    ? Colors.blue.shade700
                    : Colors.grey.shade500,
              ),
            ),
          ),
        ),
        // Phone
        DataCell(
          Tooltip(
            message: member.contact.phone ?? 'No phone',
            child: Text(
              member.contact.phone ?? '-',
              style: TextStyle(
                color: member.contact.phone != null
                    ? Colors.green.shade700
                    : Colors.grey.shade500,
              ),
            ),
          ),
        ),
        // Gender
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: member.gender.toLowerCase() == 'male'
                  ? Colors.blue.shade50
                  : Colors.pink.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: member.gender.toLowerCase() == 'male'
                    ? Colors.blue.shade200
                    : Colors.pink.shade200,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  member.gender.toLowerCase() == 'male'
                      ? Icons.male
                      : Icons.female,
                  size: 14,
                  color: member.gender.toLowerCase() == 'male'
                      ? Colors.blue.shade700
                      : Colors.pink.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  member.gender,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: member.gender.toLowerCase() == 'male'
                        ? Colors.blue.shade700
                        : Colors.pink.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Age
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200, width: 1),
            ),
            child: Text(
              '${_calculateAge(member.dateOfBirth)} years',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ),
        // Role
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  _getRoleColor(member.membershipRole).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    _getRoleColor(member.membershipRole).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              member.membershipRole,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getRoleColor(member.membershipRole),
              ),
            ),
          ),
        ),
        // Marital Status
        /*DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getMaritalStatusColor(member.maritalStatus)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getMaritalStatusColor(member.maritalStatus)
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getMaritalStatusIcon(member.maritalStatus),
                  size: 14,
                  color: _getMaritalStatusColor(member.maritalStatus),
                ),
                const SizedBox(width: 4),
                Text(
                  member.maritalStatus,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getMaritalStatusColor(member.maritalStatus),
                  ),
                ),
              ],
            ),
          ),
        ),*/
        // Nationality
        DataCell(
          Tooltip(
            message: member.nationality ?? 'Unknown',
            child: Text(
              member.nationality ?? '-',
              style: TextStyle(
                color: Colors.purple.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        // Status
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: member.isActive == true
                  ? Colors.green.shade50
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              member.isActive == true ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: member.isActive == true
                    ? Colors.green.shade700
                    : Colors.grey.shade600,
              ),
            ),
          ),
        ),
        // Actions
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 20),
            itemBuilder: (context) => [
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
            ],
            onSelected: (value) {
              ref.read(selectedMemberProvider.notifier).select(member);
              switch (value) {
                case 'view':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileView()),
                  );
                  break;
                case 'edit':
                  context.push('/members/edit');
                  break;
                case 'finances':
                  context.push('/members/finances');
                  break;
                case 'delete':
                  _showDeleteDialog(member);
                  break;
              }
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(Member member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: Text(
          'Are you sure you want to delete ${member.firstName} ${member.lastName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete feature coming soon')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Helper methods for styling
  int _calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'pastor':
      case 'leader':
        return Colors.purple.shade700;
      case 'member':
        return Colors.blue.shade700;
      case 'volunteer':
        return Colors.green.shade700;
      case 'visitor' || 'visita':
        return Colors.greenAccent.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => members.length;

  @override
  int get selectedRowCount => 0;
}
