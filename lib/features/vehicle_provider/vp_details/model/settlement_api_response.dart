class SettlementApiResponse {
  final bool? success;
  final String? message;
  final SettlementDetails? data;

  SettlementApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SettlementApiResponse.fromJson(Map<String, dynamic> json) {
    return SettlementApiResponse(
      success: json['success'],
      message: json['message'],
      data: SettlementDetails.fromJson(json['data']),
    );
  }
}

class SettlementDetails {
  final String? vehicleId;
  final String? loadId;
  final int? noOfDays;
  final int? amountPerDay;
  final int? loadingCharge;
  final String? updatedAt;
  final String? settlementId;
  final int? unLoadingCharge;
  final int? debitDamages;
  final int? debitShortages;
  final int? debitPenalities;
  final String? createdAt;
  final String? deletedAt;

  SettlementDetails({
    this.vehicleId,
    this.loadId,
    this.noOfDays,
    this.amountPerDay,
    this.loadingCharge,
    this.updatedAt,
    this.settlementId,
    this.unLoadingCharge,
    this.debitDamages,
    this.debitShortages,
    this.debitPenalities,
    this.createdAt,
    this.deletedAt,
  });

  factory SettlementDetails.fromJson(Map<String, dynamic> json) {
    return SettlementDetails(
      vehicleId: json['vehicleId'] as String?,
      loadId: json['loadId'] as String?,
      noOfDays: json['noOfDays'] as int?,
      amountPerDay: json['amountPerDay'] as int?,
      loadingCharge: json['loadingCharge'] as int?,
      updatedAt: json['updatedAt'] as String?,
      settlementId: json['settlementId'] as String?,
      unLoadingCharge: json['unLoadingCharge'] as int?,
      debitDamages: json['debitDamages'] as int?,
      debitShortages: json['debitShortages'] as int?,
      debitPenalities: json['debitPenalities'] as int?,
      createdAt: json['createdAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'loadId': loadId,
      'noOfDays': noOfDays,
      'amountPerDay': amountPerDay,
      'loadingCharge': loadingCharge,
      'updatedAt': updatedAt,
      'settlementId': settlementId,
      'unLoadingCharge': unLoadingCharge,
      'debitDamages': debitDamages,
      'debitShortages': debitShortages,
      'debitPenalities': debitPenalities,
      'createdAt': createdAt,
      'deletedAt': deletedAt,
    };
  }
}

