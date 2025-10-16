// lib/src/features/finances/models/transaction_model.dart

class TransactionModel {
  final String? transactionId;
  final String? fundId;
  final String? transactionType;
  final double? amount;
  final String? description;
  final String? paymentMethod;
  final DateTime? transactionDate;
  final String? createdBy;
  final String? authorizedBy;
  final bool? isAuthorized;

  TransactionModel({
    this.transactionId,
    this.fundId,
    this.transactionType,
    this.amount,
    this.description,
    this.paymentMethod,
    this.transactionDate,
    this.createdBy,
    this.authorizedBy,
    this.isAuthorized,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transaction_id'] as String?,
      fundId: json['fund_id'] as String?,
      transactionType: json['transaction_type'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      description: json['description'] as String?,
      paymentMethod: json['payment_method'] as String?,
      transactionDate: json['transaction_date'] != null
          ? DateTime.parse(json['transaction_date'] as String)
          : null,
      createdBy: json['created_by'] as String?,
      authorizedBy: json['authorized_by'] as String?,
      isAuthorized: json['is_authorized'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'fund_id': fundId,
      'transaction_type': transactionType,
      'amount': amount,
      'description': description,
      'payment_method': paymentMethod,
      'transaction_date': transactionDate?.toIso8601String(),
      'created_by': createdBy,
      'authorized_by': authorizedBy,
      'is_authorized': isAuthorized,
    };
  }
}
