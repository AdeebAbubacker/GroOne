class TripStatementResponse {
  TripStatementResponse({
    required this.memoDetails,
    required this.loadSettlement,
  });

  final MemoDetails? memoDetails;
  final LoadSettlement? loadSettlement;

  TripStatementResponse copyWith({
    MemoDetails? memoDetails,
    LoadSettlement? loadSettlement,
  }) {
    return TripStatementResponse(
      memoDetails: memoDetails ?? this.memoDetails,
      loadSettlement: loadSettlement ?? this.loadSettlement,
    );
  }

  factory TripStatementResponse.fromJson(Map<String, dynamic> json){
    return TripStatementResponse(
      memoDetails: json["memoDetails"] == null ? null : MemoDetails.fromJson(json["memoDetails"]),
      loadSettlement: json["loadSettlement"] == null ? null : LoadSettlement.fromJson(json["loadSettlement"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "memoDetails": memoDetails?.toJson(),
    "loadSettlement": loadSettlement?.toJson(),
  };

}

class LoadSettlement {
  LoadSettlement({
    required this.settlementId,
    required this.vehicleId,
    required this.loadId,
    required this.noOfDays,
    required this.amountPerDay,
    required this.loadingCharge,
    required this.unloadingCharge,
    required this.debitDamages,
    required this.debitShortages,
    required this.debitPenalities,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String settlementId;
  final String vehicleId;
  final String loadId;
  final int noOfDays;
  final int amountPerDay;
  final int loadingCharge;
  final int unloadingCharge;
  final int debitDamages;
  final int debitShortages;
  final int debitPenalities;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  LoadSettlement copyWith({
    String? settlementId,
    String? vehicleId,
    String? loadId,
    int? noOfDays,
    int? amountPerDay,
    int? loadingCharge,
    int? unloadingCharge,
    int? debitDamages,
    int? debitShortages,
    int? debitPenalities,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
  }) {
    return LoadSettlement(
      settlementId: settlementId ?? this.settlementId,
      vehicleId: vehicleId ?? this.vehicleId,
      loadId: loadId ?? this.loadId,
      noOfDays: noOfDays ?? this.noOfDays,
      amountPerDay: amountPerDay ?? this.amountPerDay,
      loadingCharge: loadingCharge ?? this.loadingCharge,
      unloadingCharge: unloadingCharge ?? this.unloadingCharge,
      debitDamages: debitDamages ?? this.debitDamages,
      debitShortages: debitShortages ?? this.debitShortages,
      debitPenalities: debitPenalities ?? this.debitPenalities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadSettlement.fromJson(Map<String, dynamic> json){
    return LoadSettlement(
      settlementId: json["settlementId"] ?? "",
      vehicleId: json["vehicleId"] ?? "",
      loadId: json["loadId"] ?? "",
      noOfDays: json["noOfDays"] ?? 0,
      amountPerDay: json["amountPerDay"] ?? 0,
      loadingCharge: json["loadingCharge"] ?? 0,
      unloadingCharge: json["unloadingCharge"] ?? 0,
      debitDamages: json["debitDamages"] ?? 0,
      debitShortages: json["debitShortages"] ?? 0,
      debitPenalities: json["debitPenalities"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "settlementId": settlementId,
    "vehicleId": vehicleId,
    "loadId": loadId,
    "noOfDays": noOfDays,
    "amountPerDay": amountPerDay,
    "loadingCharge": loadingCharge,
    "unloadingCharge": unloadingCharge,
    "debitDamages": debitDamages,
    "debitShortages": debitShortages,
    "debitPenalities": debitPenalities,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}

class MemoDetails {
  MemoDetails({
    required this.loadId,
    required this.transporter,
    required this.vehicleNumber,
    required this.memoNumber,
    required this.lane,
    required this.totalFreight,
    required this.handlingCharges,
    required this.netFreight,
    required this.advanceAmount,
    required this.advancePercentage,
    required this.balancePercentage,
    required this.balanceAmount,
    required this.bankDetails,
    required this.truckSupplier,
  });

  final String loadId;
  final String transporter;
  final String vehicleNumber;
  final String memoNumber;
  final String lane;
  final String totalFreight;
  final String handlingCharges;
  final String netFreight;
  final String advanceAmount;
  final String advancePercentage;
  final String balancePercentage;
  final String balanceAmount;
  final BankDetails? bankDetails;
  final TruckSupplier? truckSupplier;

  MemoDetails copyWith({
    String? loadId,
    String? transporter,
    String? vehicleNumber,
    String? memoNumber,
    String? lane,
    String? totalFreight,
    String? handlingCharges,
    String? netFreight,
    String? advanceAmount,
    String? advancePercentage,
    String? balancePercentage,
    String? balanceAmount,
    BankDetails? bankDetails,
    TruckSupplier? truckSupplier,
  }) {
    return MemoDetails(
      loadId: loadId ?? this.loadId,
      transporter: transporter ?? this.transporter,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      memoNumber: memoNumber ?? this.memoNumber,
      lane: lane ?? this.lane,
      totalFreight: totalFreight ?? this.totalFreight,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      netFreight: netFreight ?? this.netFreight,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      balancePercentage: balancePercentage ?? this.balancePercentage,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      bankDetails: bankDetails ?? this.bankDetails,
      truckSupplier: truckSupplier ?? this.truckSupplier,
    );
  }

  factory MemoDetails.fromJson(Map<String, dynamic> json){
    return MemoDetails(
      loadId: json["loadId"] ?? "",
      transporter: json["transporter"] ?? "",
      vehicleNumber: json["vehicleNumber"] ?? "",
      memoNumber: json["memoNumber"] ?? "",
      lane: json["lane"] ?? "",
      totalFreight: json["totalFreight"] ?? "",
      handlingCharges: json["handlingCharges"] ?? "",
      netFreight: json["netFreight"] ?? "",
      advanceAmount: json["advanceAmount"] ?? "",
      advancePercentage: json["advancePercentage"] ?? "",
      balancePercentage: json["balancePercentage"] ?? "",
      balanceAmount: json["balanceAmount"] ?? "",
      bankDetails: json["bankDetails"] == null ? null : BankDetails.fromJson(json["bankDetails"]),
      truckSupplier: json["truckSupplier"] == null ? null : TruckSupplier.fromJson(json["truckSupplier"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "loadId": loadId,
    "transporter": transporter,
    "vehicleNumber": vehicleNumber,
    "memoNumber": memoNumber,
    "lane": lane,
    "totalFreight": totalFreight,
    "handlingCharges": handlingCharges,
    "netFreight": netFreight,
    "advanceAmount": advanceAmount,
    "advancePercentage": advancePercentage,
    "balancePercentage": balancePercentage,
    "balanceAmount": balanceAmount,
    "bankDetails": bankDetails?.toJson(),
    "truckSupplier": truckSupplier?.toJson(),
  };

}

class BankDetails {
  BankDetails({
    required this.beneficiaryName,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.branchName,
  });

  final String beneficiaryName;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String branchName;

  BankDetails copyWith({
    String? beneficiaryName,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? branchName,
  }) {
    return BankDetails(
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      branchName: branchName ?? this.branchName,
    );
  }

  factory BankDetails.fromJson(Map<String, dynamic> json){
    return BankDetails(
      beneficiaryName: json["beneficiaryName"] ?? "",
      bankName: json["bankName"] ?? "",
      accountNumber: json["accountNumber"] ?? "",
      ifscCode: json["ifscCode"] ?? "",
      branchName: json["branchName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "beneficiaryName": beneficiaryName,
    "bankName": bankName,
    "accountNumber": accountNumber,
    "ifscCode": ifscCode,
    "branchName": branchName,
  };

}

class TruckSupplier {
  TruckSupplier({
    required this.partnerName,
    required this.vehicleNumber,
    required this.panNumber,
  });

  final String partnerName;
  final String vehicleNumber;
  final String panNumber;

  TruckSupplier copyWith({
    String? partnerName,
    String? vehicleNumber,
    String? panNumber,
  }) {
    return TruckSupplier(
      partnerName: partnerName ?? this.partnerName,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      panNumber: panNumber ?? this.panNumber,
    );
  }

  factory TruckSupplier.fromJson(Map<String, dynamic> json){
    return TruckSupplier(
      partnerName: json["partnerName"] ?? "",
      vehicleNumber: json["vehicleNumber"] ?? "",
      panNumber: json["panNumber"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "partnerName": partnerName,
    "vehicleNumber": vehicleNumber,
    "panNumber": panNumber,
  };

}
