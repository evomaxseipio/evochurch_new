import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/pagination_provider.dart';
import '../../../shared/models/pagination_models.dart' as shared;
import '../models/profiles_response.dart';
import '../models/member_model.dart';
import 'members_provider.dart';

// Pagination state provider for members (10 items per page)
final membersPaginationStateProvider = createPaginationProvider(
  initialPageSize: 10,
  name: 'membersPaginationState',
);

// SERVER-SIDE paginated members data provider
// Fetches members from server with pagination/search/sort parameters
// Makes a new API call whenever pagination state changes
final membersPaginatedProvider = FutureProvider.autoDispose<ProfilesData>(
  (ref) async {
    final paginationState = ref.watch(membersPaginationStateProvider);
    final service = ref.watch(membersServiceProvider);

    print('🔄 membersPaginatedProvider: Fetching page ${paginationState.page}, pageSize: ${paginationState.pageSize}, search: ${paginationState.search}');

    // Build PaginationParams from state
    final params = shared.PaginationParams(
      page: paginationState.page,
      pageSize: paginationState.pageSize,
      search: paginationState.search,
      sortBy: paginationState.sortBy,
      sortOrder: paginationState.sortOrder,
    );

    // Fetch paginated data from server
    final result = await service.fetchMembersPaginated(params);
    print('✅ membersPaginatedProvider: Fetched ${result.items.length} items for page ${result.pagination.page}');
    
    return result;
  },
);

// Helper provider to get just the members list (for easier access)
final membersListProvider = Provider.autoDispose<List<Member>>((ref) {
  final paginatedDataAsync = ref.watch(membersPaginatedProvider);
  return paginatedDataAsync.maybeWhen(
    data: (data) => data.items,
    orElse: () => <Member>[],
  );
});

// Helper provider to get pagination info (for easier access)
final membersPaginationInfoProvider = Provider.autoDispose<PaginationInfo>((ref) {
  final paginatedDataAsync = ref.watch(membersPaginatedProvider);
  return paginatedDataAsync.maybeWhen(
    data: (data) => data.pagination,
    orElse: () => PaginationInfo(
      page: 1,
      pageSize: 10,
      totalItems: 0,
      totalPages: 0,
      hasNext: false,
      hasPrevious: false,
    ),
  );
});
