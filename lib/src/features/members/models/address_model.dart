// lib/src/features/members/models/address_model.dart

class AddressModel {
  final String? addressId;
  final String? streetAddress;
  final String? stateProvince;
  final String? cityState;
  final String? country;
  final String? postalCode;

  AddressModel({
    this.addressId,
    this.streetAddress,
    this.stateProvince,
    this.cityState,
    this.country,
    this.postalCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'] as String?,
      streetAddress: json['street_address'] as String?,
      stateProvince: json['state_province'] as String?,
      cityState: json['city_state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postal_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'street_address': streetAddress,
      'state_province': stateProvince,
      'city_state': cityState,
      'country': country,
      'postal_code': postalCode,
    };
  }
}
