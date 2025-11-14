// lib/src/features/members/models/profiles_response.dart

import 'member_model.dart';
import '../../../shared/widgets/server_paginated_table.dart';

class ProfilesResponse {
  final bool success;
  final String message;
  final ProfilesData? data;

  ProfilesResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProfilesResponse.fromJson(Map<String, dynamic> json) {
    // Handle case where response has wrapper {success, message, data, pagination}
    // data can be either a List or a Map
    ProfilesData? profilesData;
    
    if (json.containsKey('data')) {
      final dataValue = json['data'];
      
      // Case 1: data is a List (members directly)
      if (dataValue is List) {
        // Pagination is at the same level as data
        final paginationJson = json['pagination'] as Map<String, dynamic>? ?? {};
        profilesData = ProfilesData(
          items: dataValue
              .map((x) => Member.fromJson(x as Map<String, dynamic>))
              .toList(),
          pagination: PaginationInfo.fromJson(paginationJson),
        );
      }
      // Case 2: data is a Map with items and pagination
      else if (dataValue is Map<String, dynamic>) {
        profilesData = ProfilesData.fromJson(dataValue);
      }
    }
    // Case 3: No wrapper, data structure is at top level
    else {
      profilesData = ProfilesData.fromJson(json);
    }
    
    return ProfilesResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: profilesData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ProfilesData {
  final List<Member> items;
  final PaginationInfo pagination;

  ProfilesData({
    required this.items,
    required this.pagination,
  });

  factory ProfilesData.fromJson(Map<String, dynamic> json) {
    // Handle case where items might be directly in data or in an 'items' key
    List<Member> items = [];
    
    // Try 'items' key first
    if (json['items'] != null && json['items'] is List) {
      final itemsList = json['items'] as List<dynamic>;
      for (var item in itemsList) {
        try {
          if (item is Map<String, dynamic>) {
            items.add(Member.fromJson(item));
          }
        } catch (e) {
          print('⚠️ Error parsing member item: $e, item: $item');
        }
      }
    }
    
    // If items is empty and json is a list, try parsing as list
    if (items.isEmpty && json.containsKey('results') && json['results'] is List) {
      final resultsList = json['results'] as List<dynamic>;
      for (var item in resultsList) {
        try {
          if (item is Map<String, dynamic>) {
            items.add(Member.fromJson(item));
          }
        } catch (e) {
          print('⚠️ Error parsing member result: $e, item: $item');
        }
      }
    }

    // Handle pagination - might be in 'pagination' key or at top level
    Map<String, dynamic> paginationData = {};
    if (json['pagination'] != null && json['pagination'] is Map) {
      paginationData = json['pagination'] as Map<String, dynamic>;
    } else {
      // Check if pagination fields are at the same level
      if (json.containsKey('page') || json.containsKey('page_size') || 
          json.containsKey('total') || json.containsKey('total_items')) {
        paginationData = json;
      }
    }

    return ProfilesData(
      items: items,
      pagination: PaginationInfo.fromJson(paginationData),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((x) => x.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}


class PaginationInfo with IPaginationInfo {
  @override
  final int page;
  @override
  final int pageSize;
  @override
  final int totalItems;
  @override
  final int totalPages;
  @override
  final bool hasNext;
  @override
  final bool hasPrevious;

  const PaginationInfo({
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  // ✅ Factory constructor for empty state
  factory PaginationInfo.empty() {
    return const PaginationInfo(
      page: 1,
      pageSize: 10,
      totalItems: 0,
      totalPages: 0,
      hasNext: false,
      hasPrevious: false,
    );
  }

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    // Handle different pagination field names from API
    final page = json['current_page'] as int? ?? json['page'] as int? ?? 1;
    final pageSize = json['page_size'] as int? ?? json['pageSize'] as int? ?? 10;
    final totalItems = json['total_records'] as int? ?? 
        json['total_items'] as int? ?? 
        json['totalItems'] as int? ?? 
        json['total'] as int? ?? 
        0;
    final totalPages = json['total_pages'] as int? ?? json['totalPages'] as int? ?? 1;
    final hasNext = json['has_next'] as bool? ?? json['hasNext'] as bool? ?? false;
    final hasPrevious = json['has_previous'] as bool? ?? json['hasPrevious'] as bool? ?? false;
    
    return PaginationInfo(
      page: page,
      pageSize: pageSize,
      totalItems: totalItems,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }

  Map<String, dynamic> toJson() => {
        'page': page,
        'page_size': pageSize,
        'total_items': totalItems,
        'total_pages': totalPages,
        'has_next': hasNext,
        'has_previous': hasPrevious,
      };
}

/*
class PaginationInfo with IPaginationInfo {
  @override
  final int page;
  @override
  final int pageSize;
  @override
  final int totalItems;
  @override
  final int totalPages;
  @override
  final bool hasNext;
  @override
  final bool hasPrevious;

  PaginationInfo({
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    // Handle different pagination field names
    final page = json['current_page'] as int? ?? json['page'] as int? ?? 1;
    final pageSize = json['page_size'] as int? ?? json['pageSize'] as int? ?? json['size'] as int? ?? 10;
    final totalItems = json['total_records'] as int? ?? json['total_items'] as int? ?? json['totalItems'] as int? ?? json['total'] as int? ?? json['count'] as int? ?? 0;
    final totalPages = json['total_pages'] as int? ?? json['totalPages'] as int? ?? (pageSize > 0 && totalItems > 0 ? (totalItems / pageSize).ceil() : 0);
    
    return PaginationInfo(
      page: page,
      pageSize: pageSize,
      totalItems: totalItems,
      totalPages: totalPages,
      hasNext: json['has_next'] as bool? ?? json['hasNext'] as bool? ?? false,
      hasPrevious: json['has_previous'] as bool? ?? json['hasPrevious'] as bool? ?? false,
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
}
*/
