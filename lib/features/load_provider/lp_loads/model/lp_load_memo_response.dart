class LpLoadMemoResponse {
  LpLoadMemoResponse({
    required this.success,
    required this.message,
    required this.loadMemoData,
  });

  final bool success;
  final String message;
  final LoadMemoData? loadMemoData;

  LpLoadMemoResponse copyWith({
    bool? success,
    String? message,
    LoadMemoData? loadMemoData,
  }) {
    return LpLoadMemoResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      loadMemoData: loadMemoData ?? this.loadMemoData,
    );
  }

  factory LpLoadMemoResponse.fromJson(Map<String, dynamic> json){
    return LpLoadMemoResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      loadMemoData: json["data"] == null ? null : LoadMemoData.fromJson(json["data"]),
    );
  }

}

class LoadMemoData {
  LoadMemoData({
    required this.loadId,
    required this.transporter,
    required this.vehicleNumber,
    required this.memoNumber,
    required this.lane,
    required this.totalFreight,
    required this.handlingCharges,
    required this.netFreight,
    required this.advanceAmount,
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
  final String balanceAmount;
  final BankDetails? bankDetails;
  final TruckSupplier? truckSupplier;

  LoadMemoData copyWith({
    String? loadId,
    String? transporter,
    String? vehicleNumber,
    String? memoNumber,
    String? lane,
    String? totalFreight,
    String? handlingCharges,
    String? netFreight,
    String? advanceAmount,
    String? balanceAmount,
    BankDetails? bankDetails,
    TruckSupplier? truckSupplier,
  }) {
    return LoadMemoData(
      loadId: loadId ?? this.loadId,
      transporter: transporter ?? this.transporter,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      memoNumber: memoNumber ?? this.memoNumber,
      lane: lane ?? this.lane,
      totalFreight: totalFreight ?? this.totalFreight,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      netFreight: netFreight ?? this.netFreight,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      bankDetails: bankDetails ?? this.bankDetails,
      truckSupplier: truckSupplier ?? this.truckSupplier,
    );
  }

  factory LoadMemoData.fromJson(Map<String, dynamic> json){
    return LoadMemoData(
      loadId: json["loadId"] ?? "",
      transporter: json["transporter"] ?? "",
      vehicleNumber: json["vehicleNumber"] ?? "",
      memoNumber: json["memoNumber"] ?? "",
      lane: json["lane"] ?? "",
      totalFreight: json["totalFreight"] ?? "",
      handlingCharges: json["handlingCharges"] ?? "",
      netFreight: json["netFreight"] ?? "",
      advanceAmount: json["advanceAmount"] ?? "",
      balanceAmount: json["balanceAmount"] ?? "",
      bankDetails: json["bankDetails"] == null ? null : BankDetails.fromJson(json["bankDetails"]),
      truckSupplier: json["truckSupplier"] == null ? null : TruckSupplier.fromJson(json["truckSupplier"]),
    );
  }

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

}

class TruckSupplier {
  TruckSupplier({
    required this.partnerName,
    required this.panNumber,
    required this.vehicleNumber,
  });

  final String partnerName;
  final String panNumber;
  final String vehicleNumber;

  TruckSupplier copyWith({
    String? partnerName,
    String? panNumber,
    String? vehicleNumber,
  }) {
    return TruckSupplier(
      partnerName: partnerName ?? this.partnerName,
      panNumber: panNumber ?? this.panNumber,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
    );
  }

  factory TruckSupplier.fromJson(Map<String, dynamic> json){
    return TruckSupplier(
      partnerName: json["partnerName"] ?? "",
      panNumber: json["panNumber"] ?? "",
      vehicleNumber: json["vehicleNumber"] ?? "",
    );
  }

}
