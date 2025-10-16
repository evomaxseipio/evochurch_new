// lib/src/features/members/models/membership_model.dart

class MembershipModel {
  final String? membershipId;
  final String? memberId;
  final String? roleName;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isActive;

  MembershipModel({
    this.membershipId,
    this.memberId,
    this.roleName,
    this.startDate,
    this.endDate,
    this.isActive,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      membershipId: json['membership_id'] as String?,
      memberId: json['member_id'] as String?,
      roleName: json['role_name'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'membership_id': membershipId,
      'member_id': memberId,
      'role_name': roleName,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
    };
  }
}
