// lib/src/features/finances/models/collection_model.dart

class CollectionModel {
  final String? collectionId;
  final String? memberId;
  final String? collectionType;
  final double? amount;
  final DateTime? collectionDate;
  final String? paymentMethod;
  final String? comments;
  final bool? isAnonymous;

  CollectionModel({
    this.collectionId,
    this.memberId,
    this.collectionType,
    this.amount,
    this.collectionDate,
    this.paymentMethod,
    this.comments,
    this.isAnonymous,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      collectionId: json['collection_id'] as String?,
      memberId: json['member_id'] as String?,
      collectionType: json['collection_type'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      collectionDate: json['collection_date'] != null
          ? DateTime.parse(json['collection_date'] as String)
          : null,
      paymentMethod: json['payment_method'] as String?,
      comments: json['comments'] as String?,
      isAnonymous: json['is_anonymous'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collection_id': collectionId,
      'member_id': memberId,
      'collection_type': collectionType,
      'amount': amount,
      'collection_date': collectionDate?.toIso8601String(),
      'payment_method': paymentMethod,
      'comments': comments,
      'is_anonymous': isAnonymous,
    };
  }
}
