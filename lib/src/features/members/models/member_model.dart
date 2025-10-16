// To parse this JSON data, do
//
//     final membersModel = membersModelFromJson(jsonString);

import 'dart:convert';

import 'package:evochurch_new/src/features/members/models/address_model.dart';
import 'package:evochurch_new/src/features/members/models/contact_model.dart';

MembersModel membersModelFromJson(String str) =>
    MembersModel.fromJson(json.decode(str));

String membersModelToJson(MembersModel data) => json.encode(data.toJson());

class MembersModel {
  bool success;
  int statusCode;
  String message;
  List<Member> memberList;

  MembersModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.memberList,
  });

  MembersModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    List<Member>? memberList,
  }) =>
      MembersModel(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        memberList: memberList ?? this.memberList,
      );

  factory MembersModel.fromJson(Map<String, dynamic> json) => MembersModel(
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
        memberList: List<Member>.from(
            json["member_list"].map((x) => Member.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "member_list": List<dynamic>.from(memberList.map((x) => x.toJson())),
      };
}

class Member {
  String memberId;
  int churchId;
  String firstName;
  String lastName;
  String nickName;
  DateTime dateOfBirth;
  String gender;
  String maritalStatus;
  String nationality;
  String idType;
  String idNumber;
  bool isActive;
  bool isMember;
  String membershipRole;
  String bio;
  AddressModel address;
  ContactModel contact;

  Member({
    required this.memberId,
    required this.churchId,
    required this.firstName,
    required this.lastName,
    required this.nickName,
    required this.dateOfBirth,
    required this.gender,
    required this.maritalStatus,
    required this.nationality,
    required this.idType,
    required this.idNumber,
    required this.isActive,
    required this.isMember,
    required this.membershipRole,
    required this.bio,
    required this.address,
    required this.contact,
  });

  Member copyWith({
    String? memberId,
    int? churchId,
    String? firstName,
    String? lastName,
    String? nickName,
    DateTime? dateOfBirth,
    String? gender,
    String? maritalStatus,
    String? nationality,
    String? idType,
    String? idNumber,
    bool? isActive,
    bool? isMember,
    String? membershipRole,
    String? bio,
    AddressModel? address,
    ContactModel? contact,
  }) =>
      Member(
        memberId: memberId ?? this.memberId,
        churchId: churchId ?? this.churchId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        nickName: nickName ?? this.nickName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        maritalStatus: maritalStatus ?? this.maritalStatus,
        nationality: nationality ?? this.nationality,
        idType: idType ?? this.idType,
        idNumber: idNumber ?? this.idNumber,
        isActive: isActive ?? this.isActive,
        isMember: isMember ?? this.isMember,
        membershipRole: membershipRole ?? this.membershipRole,
        bio: bio ?? this.bio,
        address: address ?? this.address,
        contact: contact ?? this.contact,
      );

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        memberId: json["memberId"],
        churchId: json["churchId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        nickName: json["nickName"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        gender: json["gender"],
        maritalStatus: json["maritalStatus"],
        nationality: json["nationality"],
        idType: json["idType"],
        idNumber: json["idNumber"],
        isActive: json["isActive"],
        isMember: json["isMember"],
        membershipRole: json["membershipRole"],
        bio: json["bio"],
        address: AddressModel.fromJson(json["address"]),
        contact: ContactModel.fromJson(json["contact"]),
      );

  Map<String, dynamic> toJson() => {
        "memberId": memberId,
        "churchId": churchId,
        "firstName": firstName,
        "lastName": lastName,
        "nickName": nickName,
        "dateOfBirth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "maritalStatus": maritalStatus,
        "nationality": nationality,
        "idType": idType,
        "idNumber": idNumber,
        "isActive": isActive,
        "isMember": isMember,
        "membershipRole": membershipRole,
        "bio": bio,
        "address": address.toJson(),
        "contact": contact.toJson(),
      };
}