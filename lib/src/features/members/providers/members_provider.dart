// lib/src/features/members/providers/members_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/api_client_provider.dart';
import '../models/member_model.dart';
import '../models/address_model.dart';
import '../models/contact_model.dart';
import '../services/members_service.dart';

// Service provider
final membersServiceProvider = Provider<MembersService>((ref) {
  final client = ref.watch(apiClientProvider);

  // Get church_id from TokenStorage (saved during login)
  // The service will get church_id from storage if not provided
  return MembersService(client, null);
});

// Members notifier
class MembersNotifier extends AsyncNotifier<List<Member>> {
  @override
  Future<List<Member>> build() async {
    return _fetchMembers();
  }

  Future<List<Member>> _fetchMembers() async {
    final service = ref.read(membersServiceProvider);
    return service.fetchMembers();
  }

  Future<void> addMember(
    Member member,
    AddressModel address,
    ContactModel contact,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(membersServiceProvider);
      await service.addMember(member, address, contact);
      return _fetchMembers();
    });
  }

  Future<void> updateMember(
    Member member,
    AddressModel address,
    ContactModel contact,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(membersServiceProvider);
      await service.updateMember(member, address, contact);
      return _fetchMembers();
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMembers());
  }
}

final membersProvider = AsyncNotifierProvider<MembersNotifier, List<Member>>(
  () => MembersNotifier(),
);

// Provider for selected member
class SelectedMemberNotifier extends StateNotifier<Member?> {
  SelectedMemberNotifier() : super(null);

  void select(Member member) {
    state = member;
  }

  void clear() {
    state = null;
  }
}

final selectedMemberProvider =
    StateNotifierProvider<SelectedMemberNotifier, Member?>(
  (ref) => SelectedMemberNotifier(),
);

// Provider for member roles
final memberRolesProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(membersServiceProvider);
  return service.getMemberRoles();
});

// Provider family to get membership data for a member
final membershipDataProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, memberId) async {
  final service = ref.watch(membersServiceProvider);
  return service.getMembershipByMemberId(memberId);
});

// Notifier to update membership
class MembershipNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  MembershipNotifier(this.ref) : super(const AsyncValue.loading());

  final Ref ref;

  Future<void> updateMembership(String memberId, Map<String, dynamic> membershipData) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(membersServiceProvider);
      final response = await service.updateMembership(memberId, membershipData);
      
      if (response['success'] == true) {
        state = AsyncValue.data(response);
        // Invalidate membership data provider to refresh
        ref.invalidate(membershipDataProvider(memberId));
      } else {
        state = AsyncValue.error(
          Exception(response['message'] ?? 'Failed to update membership'),
          StackTrace.current,
        );
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void reset() {
    state = const AsyncValue.loading();
  }
}

final membershipNotifierProvider = StateNotifierProvider<MembershipNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return MembershipNotifier(ref);
});

// Provider family for member finances
// final memberFinancesProvider =
//     FutureProvider.family<Map<String, dynamic>, String>((ref, memberId) async {
//   final service = ref.watch(membersServiceProvider);
//   return service.getFinancialByMemberId(memberId);
// });
