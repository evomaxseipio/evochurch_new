// lib/src/features/members/services/members_service.dart

import '../../../shared/services/http_client.dart';
import '../../../shared/constants/api_config.dart';
import '../../../shared/services/token_storage.dart';
import '../../../shared/models/pagination_models.dart' as shared;
import '../models/member_model.dart';
import '../models/profiles_response.dart';
import '../models/address_model.dart';
import '../models/contact_model.dart';
import 'package:dio/dio.dart';

class MembersService {
  final ApiClient _client;
  final int? _churchId;

  MembersService(this._client, this._churchId);


  /// ✅ Fetch paginated members with search/sort support
  Future<ProfilesData> fetchMembersPaginated(
    shared.PaginationParams params,
  ) async {
    print('🔍 === fetchMembersPaginated ===');
    print('📄 Page: ${params.page}, Size: ${params.pageSize}');
    print('🔎 Search: ${params.search}');
    print('📊 Sort: ${params.sortBy} ${params.sortOrder}');

    // Get church_id
    int? churchId = _churchId ?? await TokenStorage.getChurchId();

    if (churchId == null) {
      throw Exception('church_id is required to fetch members');
    }

    try {
      // Build query parameters from PaginationParams
      final queryParams = params.toQueryParams();
      queryParams['church_id'] = churchId;

      print('📡 API Request: ${ApiConfig.profilesEndpoint}');
      print('📦 Query Params: $queryParams');

      final response = await _client.get(
        ApiConfig.profilesEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final profilesResponse = ProfilesResponse.fromJson(response.data);

        if (!profilesResponse.success) {
          throw Exception(
            profilesResponse.message.isNotEmpty
                ? profilesResponse.message
                : 'Failed to fetch members',
          );
        }

        if (profilesResponse.data == null) {
          // Return empty data with default pagination
          return ProfilesData(
            items: [],
            pagination: PaginationInfo(
              page: params.page,
              pageSize: params.pageSize,
              totalItems: 0,
              totalPages: 0,
              hasNext: false,
              hasPrevious: false,
            ),
          );
        }

        print('✅ Fetched ${profilesResponse.data!.items.length} members');
        print('📊 Total: ${profilesResponse.data!.pagination.totalItems}');
        return profilesResponse.data!;
      } else {
        throw Exception('Failed to fetch members: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException in fetchMembersPaginated: $e');
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data['detail'] != null) {
          throw Exception(data['detail'].toString());
        }
        throw Exception('Error fetching members: ${e.response!.statusCode}');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      print('❌ Error in fetchMembersPaginated: $e');
      rethrow;
    }
  }
  /// Fetch members from the API with pagination support (LEGACY - kept for compatibility)
  /// If fetchAll is true, fetches all pages, otherwise returns only the first page
  Future<List<Member>> fetchMembers({
    int page = 1,
    int pageSize = 1000,
    bool fetchAll = false,
  }) async {
    print('=== fetchMembers ===');
    print('Church ID: $_churchId');
    print('Page: $page, Page Size: $pageSize');

    // If no church_id, try to get it from storage
    int? churchId = _churchId;
    if (churchId == null) {
      churchId = await TokenStorage.getChurchId();
      print('Church ID from storage: $churchId');
    }

    if (churchId == null) {
      print('⚠️ No church_id available, returning empty list');
      throw Exception('church_id is required to fetch members');
    }

    try {
      List<Member> allMembers = [];

      // Fetch first page
      final firstPageResponse = await _client.get(
        ApiConfig.profilesEndpoint,
        queryParameters: {
          'church_id': churchId,
          'page': page,
          'page_size': pageSize,
        },
      );

      if (firstPageResponse.statusCode == 200) {
        // Debug: Log raw response
        print('📦 Raw API Response: ${firstPageResponse.data}');
        print('📦 Response Type: ${firstPageResponse.data.runtimeType}');
        
        final responseData = firstPageResponse.data;
        
        // Try to parse as ProfilesResponse first
        ProfilesResponse? profilesResponse;
        try {
          if (responseData is Map<String, dynamic>) {
            profilesResponse = ProfilesResponse.fromJson(responseData);
            print('✅ Parsed as ProfilesResponse');
          } else {
            print('⚠️ Response is not a Map, trying alternative parsing');
          }
        } catch (e) {
          print('❌ Error parsing ProfilesResponse: $e');
          // Try alternative structure - maybe data is directly in response
          if (responseData is Map<String, dynamic> && responseData['items'] != null) {
            print('📦 Trying direct items parsing');
            final items = responseData['items'] as List;
            for (var item in items) {
              try {
                allMembers.add(Member.fromJson(item as Map<String, dynamic>));
              } catch (e) {
                print('⚠️ Error parsing member: $e');
              }
            }
            print('✅ Loaded ${allMembers.length} members from direct parsing');
            return allMembers;
          }
          rethrow;
        }

        if (profilesResponse != null) {
          if (!profilesResponse.success) {
            throw Exception(profilesResponse.message.isNotEmpty 
                ? profilesResponse.message 
                : 'Failed to fetch members: API returned success=false');
          }
          
          if (profilesResponse.data == null) {
            print('⚠️ ProfilesResponse.data is null, returning empty list');
            return [];
          }
          
          final data = profilesResponse.data!;
          allMembers.addAll(data.items);

          print('✅ Fetched page $page: ${data.items.length} members');
          print('Total items: ${data.pagination.totalItems}, Total pages: ${data.pagination.totalPages}');

          // If fetchAll is true and there are more pages, fetch them all
          if (fetchAll && data.pagination.hasNext && data.pagination.totalPages > 1) {
            int currentPage = page;
            int lastTotalPages = data.pagination.totalPages;
            
            while (currentPage < lastTotalPages) {
              currentPage++;
              try {
                final nextPageResponse = await _client.get(
                  ApiConfig.profilesEndpoint,
                  queryParameters: {
                    'church_id': churchId,
                    'page': currentPage,
                    'page_size': pageSize,
                  },
                );

                if (nextPageResponse.statusCode == 200) {
                  final nextProfilesResponse = ProfilesResponse.fromJson(nextPageResponse.data);
                  if (nextProfilesResponse.success && nextProfilesResponse.data != null) {
                    final nextData = nextProfilesResponse.data!;
                    allMembers.addAll(nextData.items);
                    lastTotalPages = nextData.pagination.totalPages; // Update total pages
                    print('✅ Fetched page $currentPage: ${nextData.items.length} members');
                    
                    // Break if no more pages
                    if (!nextData.pagination.hasNext || currentPage >= lastTotalPages) {
                      break;
                    }
                  }
                }
              } catch (e) {
                print('⚠️ Error fetching page $currentPage: $e');
                // Continue with the members we have so far
                break;
              }
            }
          }

          print('✅ Total members loaded: ${allMembers.length}');
          return allMembers;
        } else {
          throw Exception('Failed to parse API response');
        }
      } else {
        throw Exception('Failed to fetch members: ${firstPageResponse.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException in fetchMembers: $e');
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data['detail'] != null) {
          throw Exception(data['detail'].toString());
        }
        throw Exception('Error fetching members: ${e.response!.statusCode}');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      print('❌ Error in fetchMembers: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> addMember(
    Member member,
    AddressModel address,
    ContactModel contact,
  ) async {
    // TODO: Implement when API endpoint is available
    throw UnimplementedError('addMember API endpoint not yet implemented');
  }

  Future<Map<String, dynamic>> updateMember(
    Member member,
    AddressModel address,
    ContactModel contact,
  ) async {
    // TODO: Implement when API endpoint is available
    throw UnimplementedError('updateMember API endpoint not yet implemented');
  }

  /// Get membership data for a specific member
  Future<Map<String, dynamic>> getMembershipByMemberId(String memberId) async {
    try {
      final response = await _client.get(
        ApiConfig.membershipEndpoint(memberId),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return data;
        }
        return {'membership': []};
      } else {
        throw Exception('Failed to fetch membership: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Member has no membership data yet, return empty structure
        return {'membership': []};
      }
      print('❌ Error fetching membership: $e');
      rethrow;
    } catch (e) {
      print('❌ Unexpected error fetching membership: $e');
      rethrow;
    }
  }

  /// Update membership data for a specific member
  Future<Map<String, dynamic>> updateMembership(
    String memberId,
    Map<String, dynamic> membershipData,
  ) async {
    try {
      final response = await _client.put(
        ApiConfig.membershipEndpoint(memberId),
        data: membershipData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return {
            'success': true,
            'message': 'Membership updated successfully',
            'data': data,
          };
        }
        return {
          'success': true,
          'message': 'Membership updated successfully',
        };
      } else {
        throw Exception('Failed to update membership: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Error updating membership: $e');
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data['detail'] != null) {
          return {
            'success': false,
            'message': data['detail'].toString(),
          };
        }
        return {
          'success': false,
          'message': 'Error updating membership: ${e.response!.statusCode}',
        };
      }
      return {
        'success': false,
        'message': 'Connection error: ${e.message}',
      };
    } catch (e) {
      print('❌ Unexpected error updating membership: $e');
      return {
        'success': false,
        'message': 'Unexpected error: $e',
      };
    }
  }

  /// Get available member roles
  Future<List<String>> getMemberRoles() async {
    try {
      final response = await _client.get(
        ApiConfig.memberRolesEndpoint,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((e) => e.toString()).toList();
        }
        if (data is Map<String, dynamic> && data['roles'] is List) {
          return (data['roles'] as List).map((e) => e.toString()).toList();
        }
        // Return default roles if API structure is different
        return ['Member', 'Leader', 'Pastor', 'Deacon', 'Elder'];
      } else {
        // Return default roles if endpoint is not available
        return ['Member', 'Leader', 'Pastor', 'Deacon', 'Elder'];
      }
    } on DioException catch (e) {
      // Return default roles if endpoint is not available
      print('⚠️ Member roles endpoint not available, using defaults: $e');
      return ['Member', 'Leader', 'Pastor', 'Deacon', 'Elder'];
    } catch (e) {
      // Return default roles on any error
      print('⚠️ Error fetching member roles, using defaults: $e');
      return ['Member', 'Leader', 'Pastor', 'Deacon', 'Elder'];
    }
  }
}
