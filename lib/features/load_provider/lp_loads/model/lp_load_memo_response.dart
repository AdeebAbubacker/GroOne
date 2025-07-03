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
    required this.id,
    required this.loadId,
    required this.transporter,
    required this.trip,
    required this.memoNumber,
    required this.lane,
    required this.totalFreight,
    required this.netFreight,
    required this.handlingCharges,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.advancePercentage,
    required this.balancePercentage,
    required this.bankDetails,
    required this.truckSupplier,
  });

  final int id;
  final String loadId;
  final String transporter;
  final Trip? trip;
  final String memoNumber;
  final String lane;
  final String totalFreight;
  final String handlingCharges;
  final String netFreight;
  final String advanceAmount;
  final String balanceAmount;
  final String advancePercentage;
  final String balancePercentage;
  final BankDetails? bankDetails;
  final TruckSupplier? truckSupplier;

  LoadMemoData copyWith({
    int? id,
    String? loadId,
    String? transporter,
    Trip? trip,
    String? memoNumber,
    String? lane,
    String? totalFreight,
    String? handlingCharges,
    String? netFreight,
    String? advanceAmount,
    String? balanceAmount,
    String? advancePercentage,
    String? balancePercentage,
    BankDetails? bankDetails,
  }) {
    return LoadMemoData(
      id: id ?? this.id,
      loadId: loadId ?? this.loadId,
      transporter: transporter ?? this.transporter,
      trip: trip ?? this.trip,
      memoNumber: memoNumber ?? this.memoNumber,
      lane: lane ?? this.lane,
      totalFreight: totalFreight ?? this.totalFreight,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      netFreight: netFreight ?? this.netFreight,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      balancePercentage: balancePercentage ?? this.balancePercentage,
      bankDetails: bankDetails ?? this.bankDetails,
      truckSupplier: truckSupplier ?? this.truckSupplier,
    );
  }

  factory LoadMemoData.fromJson(Map<String, dynamic> json){
    return LoadMemoData(
      id: json["id"] ?? 0,
      loadId: json["loadId"] ?? "",
      transporter: json["transporter"] ?? "",
      trip: json["trip"] == null ? null : Trip.fromJson(json["trip"]),
      memoNumber: json["memoNumber"] ?? "",
      lane: json["lane"] ?? "",
      totalFreight: json["totalFreight"] ?? "",
      handlingCharges: json["handlingCharges"] ?? "",
      netFreight: json["netFreight"] ?? "",
      advanceAmount: json["advanceAmount"] ?? "",
      balanceAmount: json["balanceAmount"] ?? "",
      advancePercentage: json["advencePercentage"] ?? "",
      balancePercentage: json["balancePercentage"] ?? "",
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
  });

  final String partnerName;
  final String panNumber;

  TruckSupplier copyWith({
    String? partnerName,
    String? panNumber,
  }) {
    return TruckSupplier(
      partnerName: partnerName ?? this.partnerName,
      panNumber: panNumber ?? this.panNumber,
    );
  }

  factory TruckSupplier.fromJson(Map<String, dynamic> json){
    return TruckSupplier(
      partnerName: json["partnerName"] ?? "",
      panNumber: json["panNumber"] ?? "",
    );
  }

}


class Trip {
  Trip({
    required this.id,
    required this.vehicleId,
    required this.driverId,
    required this.acceptedBy,
    required this.etaForPickUp,
    required this.expectedDeliveryDate,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
    required this.loadId,
    required this.driver,
    required this.vehicle,
  });

  final int id;
  final num vehicleId;
  final num driverId;
  final num acceptedBy;
  final DateTime? etaForPickUp;
  final DateTime? expectedDeliveryDate;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final num loadId;
  final Driver? driver;
  final Vehicle? vehicle;

  Trip copyWith({
    int? id,
    num? vehicleId,
    num? driverId,
    num? acceptedBy,
    DateTime? etaForPickUp,
    DateTime? expectedDeliveryDate,
    num? status,
    DateTime? createdAt,
    dynamic? deletedAt,
    num? loadId,
    Driver? driver,
    Vehicle? vehicle,
  }) {
    return Trip(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      driverId: driverId ?? this.driverId,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      etaForPickUp: etaForPickUp ?? this.etaForPickUp,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      loadId: loadId ?? this.loadId,
      driver: driver ?? this.driver,
      vehicle: vehicle ?? this.vehicle,
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json){
    return Trip(
      id: json["id"] ?? 0,
      vehicleId: json["vehicleId"] ?? 0,
      driverId: json["driverId"] ?? 0,
      acceptedBy: json["acceptedBy"] ?? 0,
      etaForPickUp: DateTime.tryParse(json["etaForPickUp"] ?? ""),
      expectedDeliveryDate: DateTime.tryParse(json["expectedDeliveryDate"] ?? ""),
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      loadId: json["loadId"] ?? 0,
      driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
      vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    );
  }

}

class Driver {
  Driver({
    required this.id,
    required this.name,
    required this.mobile,
  });

  final int id;
  final String name;
  final String mobile;

  Driver copyWith({
    int? id,
    String? name,
    String? mobile,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
    );
  }

  factory Driver.fromJson(Map<String, dynamic> json){
    return Driver(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      mobile: json["mobile"] ?? "",
    );
  }

}

class Vehicle {
  Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.truckType,
  });

  final int id;
  final String vehicleNumber;
  final TruckType? truckType;

  Vehicle copyWith({
    int? id,
    String? vehicleNumber,
    TruckType? truckType,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      truckType: truckType ?? this.truckType,
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json){
    return Vehicle(
      id: json["id"] ?? 0,
      vehicleNumber: json["vehicleNumber"] ?? "",
      truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
    );
  }

}

class TruckType {
  TruckType({
    required this.type,
    required this.subType,
  });

  final String type;
  final String subType;

  TruckType copyWith({
    String? type,
    String? subType,
  }) {
    return TruckType(
      type: type ?? this.type,
      subType: subType ?? this.subType,
    );
  }

  factory TruckType.fromJson(Map<String, dynamic> json){
    return TruckType(
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
    );
  }

}
