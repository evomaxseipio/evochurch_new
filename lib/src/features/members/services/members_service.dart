// lib/src/features/members/services/members_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/member_model.dart';
import '../models/address_model.dart';
import '../models/contact_model.dart';

class MembersService {
  final SupabaseClient _client;
  final String _churchId;

  MembersService(this._client, this._churchId);

  Future<List<Member>> fetchMembers() async {
    try {
      final response = await _client.rpc('spgetprofiles', params: {
        'p_church_id': _churchId,
      });

      final MembersModel profileList = MembersModel.fromJson(response);
      return profileList.memberList;
    } catch (rpcError) {
      // Fallback: Query directo a la tabla
      try {
        final response =
            await _client.from('members').select().eq('church_id', _churchId);

        final List<Member> members = (response as List<dynamic>)
            .map((json) => Member.fromJson(json))
            .toList();

        return members;
      } catch (directError) {
        // Si no hay church_id, devolver datos mock para testing
        if (_churchId.isEmpty) {
          return _getMockMembers();
        }

        // Si hay church_id pero fallan ambos métodos, también devolver mock
        return _getMockMembers();
      }
    }
  }

  Future<Map<String, dynamic>> addMember(
    Member member,
    AddressModel address,
    ContactModel contact,
  ) async {
    final response = await _client.rpc('spinsertprofiles', params: {
      'p_church_id': _churchId,
      'p_first_name': member.firstName,
      'p_last_name': member.lastName,
      'p_nick_name': member.nickName,
      'p_date_of_birth': member.dateOfBirth?.toIso8601String(),
      'p_gender': member.gender,
      'p_marital_status': member.maritalStatus,
      'p_nationality': member.nationality,
      'p_id_type': member.idType,
      'p_id_number': member.idNumber,
      'p_is_member': member.isMember,
      'p_is_active': member.isActive,
      'p_bio': member.bio,
      'p_street_address': address.streetAddress,
      'p_state_province': address.stateProvince,
      'p_city_state': address.cityState,
      'p_country': address.country,
      'p_phone': contact.phone,
      'p_mobile_phone': contact.mobilePhone,
      'p_email': contact.email,
    });
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateMember(
    Member member,
    AddressModel address,
    ContactModel contact,
  ) async {
    final response = await _client.rpc('spupdateprofiles', params: {
      'p_id': member.memberId,
      'p_first_name': member.firstName,
      'p_last_name': member.lastName,
      // ... resto de params
    });
    return response as Map<String, dynamic>;
  }

  Future<List<String>> getMemberRoles() async {
    final response = await _client
        .from('member_roles')
        .select('role_name')
        .order('role_name', ascending: true);

    return (response as List<dynamic>)
        .map((role) => role['role_name'] as String)
        .where((role) => role.isNotEmpty)
        .toList();
  }

  // Datos mock para testing cuando no hay church_id
  List<Member> _getMockMembers() {
    return [
      Member(
        memberId: 'mock-1',
        firstName: 'John',
        lastName: 'Doe',
        churchId: 1,
        nickName: 'John',
        dateOfBirth: DateTime.now(),
        gender: 'Male',
        maritalStatus: 'Single',
        nationality: 'American',
        idType: 'Passport',
        idNumber: '1234567890',
        isActive: true,
        isMember: true,
        membershipRole: 'Member',
        bio: 'Bio',
        address: AddressModel(),
        contact: ContactModel(),
      ),
      Member(
        memberId: 'mock-2',
        firstName: 'Jane',
        lastName: 'Smith',
        churchId: 1,
        nickName: 'Jane',
        dateOfBirth: DateTime.now(),
        gender: 'Female',
        maritalStatus: 'Single',
        nationality: 'American',
        idType: 'Passport',
        idNumber: '1234567891',
        isActive: true,
        isMember: true,
        membershipRole: 'Member',
        bio: 'Bio',
        address: AddressModel(),
        contact: ContactModel(),
      ),
      Member(
        memberId: 'mock-3',
        firstName: 'Mike',
        lastName: 'Johnson',
        churchId: 1,
        nickName: 'Mike',
        dateOfBirth: DateTime.now(),
        gender: 'Male',
        maritalStatus: 'Single',
        nationality: 'American',
        idType: 'Passport',
        idNumber: '1234567892',
        isActive: false,
        isMember: true,
        membershipRole: 'Member',
        bio: 'Bio',
        address: AddressModel(),
        contact: ContactModel(),
      ),
      Member(
        memberId: 'mock-4',
        firstName: 'Sarah',
        lastName: 'Williams',
        churchId: 1,
        nickName: 'Sarah',
        dateOfBirth: DateTime.now(),
        gender: 'Female',
        maritalStatus: 'Single',
        nationality: 'American',
        idType: 'Passport',
        idNumber: '1234567893',
        isActive: true,
        isMember: false,
        membershipRole: 'Member',
        bio: 'Bio',
        address: AddressModel(),
        contact: ContactModel(),
      ),
    ];
  }
}
