// lib/src/features/members/widgets/member_table_cells.dart

import 'package:flutter/material.dart';
import '../models/member_model.dart';

/// Base class for member table cells
abstract class MemberTableCell extends StatelessWidget {
  final Member member;

  const MemberTableCell({
    super.key,
    required this.member,
  });
}

/// Name cell with avatar
class MemberNameCell extends MemberTableCell {
  const MemberNameCell({super.key, required super.member});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: member.gender.toLowerCase() == 'male'
              ? Colors.blue.shade100
              : Colors.pink.shade100,
          child: Text(
            member.firstName.isNotEmpty
                ? member.firstName[0].toUpperCase()
                : '?',
            style: TextStyle(
              color: member.gender.toLowerCase() == 'male'
                  ? Colors.blue.shade700
                  : Colors.pink.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '${member.firstName} ${member.lastName}'.trim(),
            style: const TextStyle(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Email cell
class MemberEmailCell extends MemberTableCell {
  const MemberEmailCell({super.key, required super.member});

  @override
  Widget build(BuildContext context) {
    final email = member.contact.email;
    return Tooltip(
      message: email ?? 'No email',
      child: Text(
        email ?? '-',
        style: TextStyle(
          color: email != null
              ? Colors.blue.shade700
              : Colors.grey.shade500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

/// Phone cell
class MemberPhoneCell extends MemberTableCell {
  const MemberPhoneCell({super.key, required super.member});

  @override
  Widget build(BuildContext context) {
    final phone = member.contact.phone;
    return Tooltip(
      message: phone ?? 'No phone',
      child: Text(
        phone ?? '-',
        style: TextStyle(
          color: phone != null
              ? Colors.green.shade700
              : Colors.grey.shade500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

/// Gender cell with badge
class MemberGenderCell extends MemberTableCell {
  const MemberGenderCell({super.key, required super.member});

  @override
  Widget build(BuildContext context) {
    final isMale = member.gender.toLowerCase() == 'male';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isMale ? Colors.blue.shade50 : Colors.pink.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMale ? Colors.blue.shade200 : Colors.pink.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMale ? Icons.male : Icons.female,
            size: 14,
            color: isMale ? Colors.blue.shade700 : Colors.pink.shade700,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              member.gender,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isMale ? Colors.blue.shade700 : Colors.pink.shade700,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Role cell with colored badge
class MemberRoleCell extends MemberTableCell {
  const MemberRoleCell({super.key, required super.member});

  static Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'pastor':
      case 'leader':
        return Colors.purple.shade700;
      case 'member':
        return Colors.blue.shade700;
      case 'volunteer':
        return Colors.green.shade700;
      case 'visitor':
      case 'visita':
        return Colors.orange.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(member.membershipRole);
    return Tooltip(
      message: member.membershipRole,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: roleColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: roleColor.withValues(alpha: 0.3)),
        ),
        child: Text(
          member.membershipRole,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: roleColor,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}

/// Nationality cell
class MemberNationalityCell extends MemberTableCell {
  const MemberNationalityCell({super.key, required super.member});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: member.nationality,
      child: Text(
        member.nationality,
        style: TextStyle(
          color: Colors.purple.shade700,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

/// Status cell with active/inactive badge
class MemberStatusCell extends MemberTableCell {
  const MemberStatusCell({super.key, required super.member});

  @override
  Widget build(BuildContext context) {
    final isActive = member.isActive == true;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.green.shade700 : Colors.grey.shade600,
        ),
      ),
    );
  }
}

