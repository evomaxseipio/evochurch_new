// lib/src/features/members/providers/members_provider.dart

import 'package:riverpod/riverpod.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/member_model.dart';
import '../models/address_model.dart';
import '../models/contact_model.dart';
import '../services/members_service.dart';

// Provider del servicio
final membersServiceProvider = Provider<MembersService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final authService = ref.watch(authServiceProvider);
  final churchId = authService.userMetaData?['church_id'] ?? '';

  return MembersService(client, churchId);
});

// Notifier de miembros
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

// Provider para miembro seleccionado
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

// Provider para roles de miembros
final memberRolesProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(membersServiceProvider);
  return service.getMemberRoles();
});

// Provider family para finanzas de un miembro
// final memberFinancesProvider =
//     FutureProvider.family<Map<String, dynamic>, String>((ref, memberId) async {
//   final service = ref.watch(membersServiceProvider);
//   return service.getFinancialByMemberId(memberId);
// });
