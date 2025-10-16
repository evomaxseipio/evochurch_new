// lib/src/features/members/models/contact_model.dart

class ContactModel {
  final String? contactId;
  final String? phone;
  final String? mobilePhone;
  final String? email;
  final String? alternativeEmail;

  ContactModel({
    this.contactId,
    this.phone,
    this.mobilePhone,
    this.email,
    this.alternativeEmail,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      contactId: json['contact_id'] as String?,
      phone: json['phone'] as String?,
      mobilePhone: json['mobile_phone'] as String?,
      email: json['email'] as String?,
      alternativeEmail: json['alternative_email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact_id': contactId,
      'phone': phone,
      'mobile_phone': mobilePhone,
      'email': email,
      'alternative_email': alternativeEmail,
    };
  }
}
