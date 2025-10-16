// lib/src/features/finances/models/fund_model.dart

class FundModel {
  final String fundId;
  final String fundName;
  final String? description;
  final double? balance;
  final bool? isActive;
  final DateTime? createdAt;

  FundModel({
    required this.fundId,
    required this.fundName,
    this.description,
    this.balance,
    this.isActive,
    this.createdAt,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      fundId: json['fund_id'] as String,
      fundName: json['fund_name'] as String,
      description: json['description'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fund_id': fundId,
      'fund_name': fundName,
      'description': description,
      'balance': balance,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
