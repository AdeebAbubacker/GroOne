class TripStatementResponse {
  TripStatementResponse({
    required this.message,
    required this.data,
  });

  final String message;
  final TripDetails? data;

  TripStatementResponse copyWith({
    String? message,
    TripDetails? data,
  }) {
    return TripStatementResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory TripStatementResponse.fromJson(Map<String, dynamic> json){
    return TripStatementResponse(
      message: json["message"] ?? "",
      data: json["data"] == null ? null : TripDetails.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };

}

class TripDetails {
  TripDetails({
    required this.loadId,
    required this.transporter,
    required this.vehicleNumber,
    required this.memoNumber,
    required this.lane,
    required this.totalFreight,
    required this.netFreight,
    required this.advanceAmount,
    required this.advancePaid,
    required this.advancePercentage,
    required this.loading,
    required this.unloading,
    required this.detentions,
    required this.damages,
    required this.shortages,
    required this.penalties,
    required this.loadSettlement,
    required this.handlingCharges,
    required this.balanceToBePaid,
    required this.bankDetails,
    required this.truckSupplier,
    required this.invoiceUrl,
    required this.balancePaid,
  });

  final String loadId;
  final String transporter;
  final String vehicleNumber;
  final String memoNumber;
  final String lane;
  final String totalFreight;
  final String netFreight;
  final String advanceAmount;
  final String advancePaid;
  final String advancePercentage;
  final String loading;
  final String unloading;
  final String detentions;
  final String damages;
  final String shortages;
  final String penalties;
  final LoadSettlement? loadSettlement;
  final String handlingCharges;
  final String balanceToBePaid;
  final BankDetails? bankDetails;
  final TruckSupplier? truckSupplier;
  final String? invoiceUrl;
  final int? balancePaid;

  TripDetails copyWith({
    String? loadId,
    String? transporter,
    String? vehicleNumber,
    String? memoNumber,
    String? lane,
    String? totalFreight,
    String? netFreight,
    String? advanceAmount,
    String? advancePaid,
    String? advancePercentage,
    String? loading,
    String? unloading,
    String? detentions,
    String? damages,
    String? shortages,
    String? penalties,
    LoadSettlement? loadSettlement,
    String? handlingCharges,
    String? balanceToBePaid,
    BankDetails? bankDetails,
    TruckSupplier? truckSupplier,
    String? invoiceUrl,
    int? balancePaid,

  }) {
    return TripDetails(
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
      loadId: loadId ?? this.loadId,
      transporter: transporter ?? this.transporter,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      memoNumber: memoNumber ?? this.memoNumber,
      lane: lane ?? this.lane,
      totalFreight: totalFreight ?? this.totalFreight,
      netFreight: netFreight ?? this.netFreight,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      advancePaid: advancePaid ?? this.advancePaid,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      loading: loading ?? this.loading,
      unloading: unloading ?? this.unloading,
      detentions: detentions ?? this.detentions,
      damages: damages ?? this.damages,
      shortages: shortages ?? this.shortages,
      penalties: penalties ?? this.penalties,
      loadSettlement: loadSettlement ?? this.loadSettlement,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      balanceToBePaid: balanceToBePaid ?? this.balanceToBePaid,
      bankDetails: bankDetails ?? this.bankDetails,
      truckSupplier: truckSupplier ?? this.truckSupplier,
      balancePaid: balancePaid ?? this.balancePaid,

    );
  }

  factory TripDetails.fromJson(Map<String, dynamic> json){
    return TripDetails(
      loadId: json["loadId"] ?? "",
      transporter: json["transporter"] ?? "",
      vehicleNumber: json["vehicleNumber"] ?? "",
      memoNumber: json["memoNumber"] ?? "",
      lane: json["lane"] ?? "",
      totalFreight: json["totalFreight"] ?? "",
      netFreight: json["netFreight"] ?? "",
      advanceAmount: json["advanceAmount"] ?? "",
      advancePaid: json["advancePaid"] ?? "",
      advancePercentage: json["advancePercentage"] ?? "",
      loading: json["loading"] ?? "",
      unloading: json["unloading"] ?? "",
      detentions: json["detentions"] ?? "",
      damages: json["damages"] ?? "",
      shortages: json["shortages"] ?? "",
      penalties: json["penalties"] ?? "",
      loadSettlement: json["loadSettlement"] == null ? null : LoadSettlement.fromJson(json["loadSettlement"]),
      handlingCharges: json["handlingCharges"] ?? "",
      balanceToBePaid: json["balanceToBePaid"] ?? "",
      bankDetails: json["bankDetails"] == null ? null : BankDetails.fromJson(json["bankDetails"]),
      truckSupplier: json["truckSupplier"] == null ? null : TruckSupplier.fromJson(json["truckSupplier"]),

      invoiceUrl: json["invoiceUrl"]??"",
      balancePaid: json["balancePaid"] ?? 0
    );
  }

  Map<String, dynamic> toJson() => {
    "loadId": loadId,
    "transporter": transporter,
    "vehicleNumber": vehicleNumber,
    "memoNumber": memoNumber,
    "lane": lane,
    "totalFreight": totalFreight,
    "netFreight": netFreight,
    "advanceAmount": advanceAmount,
    "advancePaid": advancePaid,
    "advancePercentage": advancePercentage,
    "loading": loading,
    "unloading": unloading,
    "detentions": detentions,
    "damages": damages,
    "shortages": shortages,
    "penalties": penalties,
    "loadSettlement": loadSettlement?.toJson(),
    "handlingCharges": handlingCharges,
    "balanceToBePaid": balanceToBePaid,
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

class LoadSettlement {
  LoadSettlement({required this.json});
  final Map<String,dynamic> json;

  factory LoadSettlement.fromJson(Map<String, dynamic> json){
    return LoadSettlement(
        json: json
    );
  }

  Map<String, dynamic> toJson() => {
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
