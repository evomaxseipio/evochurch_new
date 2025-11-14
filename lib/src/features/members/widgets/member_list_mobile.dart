// lib/src/features/members/widgets/member_list_mobile.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/widgets/infinite_scroll_list.dart';
import '../../../shared/widgets/server_paginated_table.dart';
import '../../../shared/utils/debouncer.dart';
import '../models/member_model.dart';
import '../models/profiles_response.dart';
import '../providers/members_pagination_provider.dart';
import 'member_card.dart';

class MemberListMobile extends ConsumerStatefulWidget {
  final AsyncValue<List<Member>> membersAsync; // Keep for stats compatibility
  final ValueNotifier<String> searchQuery;

  const MemberListMobile({
    super.key,
    required this.membersAsync,
    required this.searchQuery,
  });

  @override
  ConsumerState<MemberListMobile> createState() => _MemberListMobileState();
}

class _MemberListMobileState extends ConsumerState<MemberListMobile> {
  final Debouncer _searchDebouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    widget.searchQuery.addListener(_onSearchChanged);
    // Trigger initial search if there's already a query
    if (widget.searchQuery.value.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onSearchChanged();
      });
    }
  }

  @override
  void dispose() {
    widget.searchQuery.removeListener(_onSearchChanged);
    _searchDebouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = widget.searchQuery.value.trim();
    _searchDebouncer.run(() {
      if (query.isEmpty) {
        ref.read(membersPaginationStateProvider.notifier).clearSearch();
      } else {
        ref.read(membersPaginationStateProvider.notifier).search(query);
      }
    });
  }

  Future<void> _loadMore() async {
    final paginationInfo = ref.read(membersPaginationInfoProvider);

    if (paginationInfo.hasNext) {
      ref.read(membersPaginationStateProvider.notifier).goToPage(paginationInfo.page + 1);
    }
  }

  Future<void> _refresh() async {
    ref.read(membersPaginationStateProvider.notifier).reset();
    ref.invalidate(membersPaginatedProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the paginated data (now returns AsyncValue)
    final paginatedDataAsync = ref.watch(membersPaginatedProvider);

    return paginatedDataAsync.when(
      data: (paginatedData) {
        return InfiniteScrollList<Member>(
          items: paginatedData.items,
          paginationInfo: paginatedData.pagination as IPaginationInfo,
          itemBuilder: (context, member, index) => MemberCard(member: member),
          onLoadMore: _loadMore,
          onRefresh: _refresh,
          isLoading: false,
        );
      },
      loading: () {
        return InfiniteScrollList<Member>(
          items: const [],
          paginationInfo: PaginationInfo.empty() as IPaginationInfo,
          itemBuilder: (context, member, index) => MemberCard(member: member),
          onLoadMore: () async {},
          onRefresh: _refresh,
          isLoading: true,
        );
      },
      error: (error, stack) {
        return InfiniteScrollList<Member>(
          items: const [],
          paginationInfo: PaginationInfo.empty() as IPaginationInfo,
          itemBuilder: (context, member, index) => MemberCard(member: member),
          onLoadMore: () async {},
          onRefresh: _refresh,
          isLoading: false,
          errorMessage: error.toString(),
        );
      },
    );
  }
}
