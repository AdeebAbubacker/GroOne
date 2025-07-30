class FastagModel {
  final String id;
  final String vehicleNumber;
  final String status;
  final double balance;
  final DateTime lastUpdated;
  final bool canRecharge;

  FastagModel({
    required this.id,
    required this.vehicleNumber,
    required this.status,
    required this.balance,
    required this.lastUpdated,
    this.canRecharge = true,
  });

  factory FastagModel.fromJson(Map<String, dynamic> json) {
    return FastagModel(
      id: json['id'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      status: json['status'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      lastUpdated: DateTime.tryParse(json['lastUpdated'] ?? '') ?? DateTime.now(),
      canRecharge: json['canRecharge'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleNumber': vehicleNumber,
      'status': status,
      'balance': balance,
      'lastUpdated': lastUpdated.toIso8601String(),
      'canRecharge': canRecharge,
    };
  }
}

enum FastagStatus {
  active,
  lowBalance,
  underIssuance,
}

extension FastagStatusExtension on FastagStatus {
  String get displayName {
    switch (this) {
      case FastagStatus.active:
        return 'Active';
      case FastagStatus.lowBalance:
        return 'Low Balance';
      case FastagStatus.underIssuance:
        return 'Under Issuance';
    }
  }
} 