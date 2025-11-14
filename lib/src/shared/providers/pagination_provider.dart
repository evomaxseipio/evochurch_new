// lib/src/shared/providers/pagination_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ✅ Creates a StateNotifierProvider for pagination state
StateNotifierProvider<PaginationStateNotifier, PaginationState>
    createPaginationProvider({
  required int initialPageSize,
  required String name,
}) {
  return StateNotifierProvider<PaginationStateNotifier, PaginationState>(
    (ref) => PaginationStateNotifier(
      initialPageSize: initialPageSize,
    ),
    name: name,
  );
}

class PaginationStateNotifier extends StateNotifier<PaginationState> {
  PaginationStateNotifier({required int initialPageSize})
      : super(PaginationState(
          page: 1,
          pageSize: initialPageSize,
        ));

  /// ✅ Change page number
  void goToPage(int page) {
    if (page < 1) return;
    state = state.copyWith(page: page);
    print('📄 Page changed to: $page');
  }

  /// ✅ Change page size
  void changePageSize(int size) {
    state = state.copyWith(pageSize: size, page: 1);
    print('📊 Page size changed to: $size, reset to page 1');
  }

  /// ✅ Update search query
  void search(String? query) {
    final trimmed = query?.trim();
    state = state.copyWith(
      search: trimmed?.isEmpty ?? true ? null : trimmed,
      page: 1, // Reset to first page on search
    );
    print('🔎 Search updated: ${state.search}, reset to page 1');
  }

  /// ✅ Clear search
  void clearSearch() {
    state = state.copyWith(search: null, page: 1);
    print('🔎 Search cleared, reset to page 1');
  }

  /// ✅ Update sort parameters
  void sort(String field, String order) {
    state = state.copyWith(
      sortBy: field,
      sortOrder: order,
      page: 1, // Reset to first page on sort
    );
    print('📊 Sort updated: $field $order, reset to page 1');
  }

  /// ✅ Reset all pagination state
  void reset() {
    state = PaginationState(
      page: 1,
      pageSize: state.pageSize,
    );
    print('🔄 Pagination state reset');
  }
}

/// ✅ Pagination state model
class PaginationState {
  final int page;
  final int pageSize;
  final String? search;
  final String? sortBy;
  final String? sortOrder;

  const PaginationState({
    required this.page,
    required this.pageSize,
    this.search,
    this.sortBy,
    this.sortOrder,
  });

  PaginationState copyWith({
    int? page,
    int? pageSize,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) {
    return PaginationState(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      search: search,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}