// Generic pagination models following DRY principle
// These can be reused across all features (members, finances, events, etc.)

/// Parameters for paginated requests
class PaginationParams {
  final int page;
  final int pageSize;
  final String? search;
  final String? sortBy;
  final String? sortOrder;

  const PaginationParams({
    this.page = 1,
    this.pageSize = 20,
    this.search,
    this.sortBy,
    this.sortOrder,
  });

  /// Copy with method for easy state updates
  PaginationParams copyWith({
    int? page,
    int? pageSize,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// Convert to query parameters for API calls
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };

    if (search != null && search!.isNotEmpty) {
      params['search'] = search;
    }
    if (sortBy != null && sortBy!.isNotEmpty) {
      params['sort_by'] = sortBy;
      params['sort_order'] = sortOrder ?? 'asc';
    }

    return params;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationParams &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          pageSize == other.pageSize &&
          search == other.search &&
          sortBy == other.sortBy &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode =>
      page.hashCode ^
      pageSize.hashCode ^
      search.hashCode ^
      sortBy.hashCode ^
      sortOrder.hashCode;
}

/// Metadata about the current pagination state
class PaginationInfo {
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationInfo({
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    // Support multiple naming conventions (snake_case and camelCase)
    final page = json['current_page'] ?? json['page'] ?? 1;
    final pageSize = json['page_size'] ?? json['pageSize'] ?? json['size'] ?? 10;
    final totalItems = json['total_records'] ??
        json['total_items'] ??
        json['totalItems'] ??
        json['total'] ??
        json['count'] ??
        0;
    final totalPages = json['total_pages'] ?? json['totalPages'] ?? 1;
    final hasNext = json['has_next'] ?? json['hasNext'] ?? false;
    final hasPrevious = json['has_previous'] ?? json['hasPrevious'] ?? false;

    return PaginationInfo(
      page: page,
      pageSize: pageSize,
      totalItems: totalItems,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'page_size': pageSize,
      'total_items': totalItems,
      'total_pages': totalPages,
      'has_next': hasNext,
      'has_previous': hasPrevious,
    };
  }

  /// Helper to get range description (e.g., "1-20 of 250")
  String getRangeDescription() {
    if (totalItems == 0) return '0 items';

    final start = ((page - 1) * pageSize) + 1;
    final end = (page * pageSize).clamp(1, totalItems);

    return '$start-$end of $totalItems';
  }
}

/// Generic paginated response wrapper
class PaginatedResponse<T> {
  final List<T> items;
  final PaginationInfo pagination;

  const PaginatedResponse({
    required this.items,
    required this.pagination,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    final items = itemsList.map((item) => fromJsonT(item as Map<String, dynamic>)).toList();

    final pagination = PaginationInfo.fromJson(json['pagination'] ?? {});

    return PaginatedResponse(
      items: items,
      pagination: pagination,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'items': items.map((item) => toJsonT(item)).toList(),
      'pagination': pagination.toJson(),
    };
  }

  /// Helper to check if there are any items
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  /// Get total count
  int get totalCount => pagination.totalItems;
}
