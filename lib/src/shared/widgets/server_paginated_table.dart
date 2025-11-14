import 'package:flutter/material.dart';

/// Simple pagination info interface - accepts any object with these fields
mixin IPaginationInfo {
  int get page;
  int get pageSize;
  int get totalItems;
  int get totalPages;
  bool get hasNext;
  bool get hasPrevious;

  /// Helper to get range description (e.g., "1-20 of 250")
  String getRangeDescription() {
    if (totalItems == 0) return '0 items';

    final start = ((page - 1) * pageSize) + 1;
    final end = (page * pageSize).clamp(1, totalItems);

    return '$start-$end of $totalItems';
  }
}

/// Generic server-paginated table wrapper following KISS principle
/// Wraps PaginatedDataTable to handle server-side pagination
class ServerPaginatedTable extends StatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> Function(List<dynamic> items) rowBuilder;
  final List<dynamic> items;
  final IPaginationInfo paginationInfo;
  final bool isLoading;
  final String? errorMessage;
  final Function(int page) onPageChanged;
  final Function(int pageSize) onPageSizeChanged;
  final Function(int columnIndex, bool ascending)? onSort;
  final int? sortColumnIndex;
  final bool sortAscending;
  final List<int> availableRowsPerPage;

  const ServerPaginatedTable({
    super.key,
    required this.columns,
    required this.rowBuilder,
    required this.items,
    required this.paginationInfo,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    this.isLoading = false,
    this.errorMessage,
    this.onSort,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.availableRowsPerPage = const [10, 20, 50, 100],
  });

  @override
  State<ServerPaginatedTable> createState() => _ServerPaginatedTableState();
}

class _ServerPaginatedTableState extends State<ServerPaginatedTable> {
  @override
  Widget build(BuildContext context) {
    if (widget.errorMessage != null) {
      return _buildErrorState();
    }

    if (widget.isLoading && widget.items.isEmpty) {
      return _buildLoadingState();
    }

    if (widget.items.isEmpty) {
      return _buildEmptyState();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Pagination info header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.paginationInfo.getRangeDescription(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (widget.isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Data table with loading overlay
          _ServerPaginatedDataSource(
            columns: widget.columns,
            rows: widget.rowBuilder(widget.items),
            sortColumnIndex: widget.sortColumnIndex,
            sortAscending: widget.sortAscending,
            onSort: widget.onSort,
            paginationInfo: widget.paginationInfo,
            onPageChanged: widget.onPageChanged,
            onPageSizeChanged: widget.onPageSizeChanged,
            availableRowsPerPage: widget.availableRowsPerPage,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.errorMessage ?? 'Unknown error',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No data found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal widget to handle the actual PaginatedDataTable
class _ServerPaginatedDataSource extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int? sortColumnIndex;
  final bool sortAscending;
  final Function(int, bool)? onSort;
  final IPaginationInfo paginationInfo;
  final Function(int) onPageChanged;
  final Function(int) onPageSizeChanged;
  final List<int> availableRowsPerPage;

  const _ServerPaginatedDataSource({
    required this.columns,
    required this.rows,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onSort,
    required this.paginationInfo,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    required this.availableRowsPerPage,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: null,
      rowsPerPage: paginationInfo.pageSize,
      availableRowsPerPage: availableRowsPerPage,
      onRowsPerPageChanged: (value) {
        if (value != null) {
          onPageSizeChanged(value);
        }
      },
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      columns: columns.map((col) {
        return DataColumn(
          label: col.label,
          onSort: onSort != null
              ? (columnIndex, ascending) {
                  onSort!(columnIndex, ascending);
                }
              : null,
        );
      }).toList(),
      source: _CustomDataTableSource(
        rows: rows,
        totalItems: paginationInfo.totalItems,
        currentPage: paginationInfo.page,
        pageSize: paginationInfo.pageSize,
        onPageChanged: onPageChanged,
      ),
    );
  }
}

/// Custom DataTableSource to handle server-side pagination
class _CustomDataTableSource extends DataTableSource {
  final List<DataRow> rows;
  final int totalItems;
  final int currentPage;
  final int pageSize;
  final Function(int) onPageChanged;

  _CustomDataTableSource({
    required this.rows,
    required this.totalItems,
    required this.currentPage,
    required this.pageSize,
    required this.onPageChanged,
  });

  @override
  DataRow? getRow(int index) {
    // When user navigates pages, this gets called with different indices
    // We need to detect page changes and trigger API calls
    final requestedPage = (index ~/ pageSize) + 1;
    if (requestedPage != currentPage) {
      // Trigger page change callback
      Future.microtask(() => onPageChanged(requestedPage));
      return null; // Return null while loading
    }

    final localIndex = index % pageSize;
    if (localIndex >= rows.length) {
      return null;
    }

    return rows[localIndex];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => totalItems;

  @override
  int get selectedRowCount => 0;
}
