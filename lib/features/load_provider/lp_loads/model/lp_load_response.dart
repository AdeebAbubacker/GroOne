class LpLoadResponse {
  LpLoadResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final LpLoadData? data;

  LpLoadResponse copyWith({
    bool? success,
    String? message,
    LpLoadData? data,
  }) {
    return LpLoadResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LpLoadResponse.fromJson(Map<String, dynamic> json){
    return LpLoadResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : LpLoadData.fromJson(json["data"]),
    );
  }

}

class LpLoadData {
  LpLoadData({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<LpLoadItem> data;
  final num total;
  final num page;
  final num limit;

  LpLoadData copyWith({
    List<LpLoadItem>? data,
    num? total,
    num? page,
    num? limit,
  }) {
    return LpLoadData(
      data: data ?? this.data,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  factory LpLoadData.fromJson(Map<String, dynamic> json){
    return LpLoadData(
      data: json["data"] == null ? [] : List<LpLoadItem>.from(json["data"]!.map((x) => LpLoadItem.fromJson(x))),
      total: json["total"] ?? 0,
      page: json["page"] ?? 0,
      limit: json["limit"] ?? 0,
    );
  }

}

class LpLoadItem {
  LpLoadItem({
    required this.id,
    required this.loadId,
    required this.laneId,
    required this.rateId,
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.pickUpAddr,
    required this.pickUpLocation,
    required this.assignStatus,
    required this.pickUpLatlon,
    required this.dropAddr,
    required this.dropLocation,
    required this.dropLatlon,
    required this.dueDate,
    required this.consignmentWeight,
    required this.notes,
    required this.rate,
    required this.status,
    required this.loadStatus,
    required this.vehicleLength,
    required this.pickUpDateTime,
    required this.expectedDeliveryDateTime,
    required this.handlingCharges,
    required this.acceptedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.commodity,
    required this.truckType,
    required this.customer,
    required this.customerDetail,
  });

  final int id;
  final String loadId;
  final String laneId;
  final dynamic rateId;
  final num customerId;
  final num commodityId;
  final num truckTypeId;
  final String pickUpAddr;
  final String pickUpLocation;
  final num assignStatus;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropLocation;
  final String dropLatlon;
  final DateTime? dueDate;
  final num consignmentWeight;
  final String notes;
  final String rate;
  final num status;
  final num loadStatus;
  final String vehicleLength;
  final DateTime? pickUpDateTime;
  final DateTime? expectedDeliveryDateTime;
  final num handlingCharges;
  final dynamic acceptedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final Commodity? commodity;
  final TruckType? truckType;
  final Customer? customer;
  final dynamic customerDetail;

  LpLoadItem copyWith({
    int? id,
    String? loadId,
    String? laneId,
    dynamic? rateId,
    num? customerId,
    num? commodityId,
    num? truckTypeId,
    String? pickUpAddr,
    String? pickUpLocation,
    num? assignStatus,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropLocation,
    String? dropLatlon,
    DateTime? dueDate,
    num? consignmentWeight,
    String? notes,
    String? rate,
    num? status,
    num? loadStatus,
    String? vehicleLength,
    DateTime? pickUpDateTime,
    DateTime? expectedDeliveryDateTime,
    num? handlingCharges,
    dynamic? acceptedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
    Commodity? commodity,
    TruckType? truckType,
    Customer? customer,
    dynamic? customerDetail,
  }) {
    return LpLoadItem(
      id: id ?? this.id,
      loadId: loadId ?? this.loadId,
      laneId: laneId ?? this.laneId,
      rateId: rateId ?? this.rateId,
      customerId: customerId ?? this.customerId,
      commodityId: commodityId ?? this.commodityId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      pickUpAddr: pickUpAddr ?? this.pickUpAddr,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      assignStatus: assignStatus ?? this.assignStatus,
      pickUpLatlon: pickUpLatlon ?? this.pickUpLatlon,
      dropAddr: dropAddr ?? this.dropAddr,
      dropLocation: dropLocation ?? this.dropLocation,
      dropLatlon: dropLatlon ?? this.dropLatlon,
      dueDate: dueDate ?? this.dueDate,
      consignmentWeight: consignmentWeight ?? this.consignmentWeight,
      notes: notes ?? this.notes,
      rate: rate ?? this.rate,
      status: status ?? this.status,
      loadStatus: loadStatus ?? this.loadStatus,
      vehicleLength: vehicleLength ?? this.vehicleLength,
      pickUpDateTime: pickUpDateTime ?? this.pickUpDateTime,
      expectedDeliveryDateTime: expectedDeliveryDateTime ?? this.expectedDeliveryDateTime,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      customer: customer ?? this.customer,
      customerDetail: customerDetail ?? this.customerDetail,
    );
  }

  factory LpLoadItem.fromJson(Map<String, dynamic> json){
    return LpLoadItem(
      id: json["id"] ?? 0,
      loadId: json["loadId"] ?? "",
      laneId: json["laneId"] ?? "",
      rateId: json["rateId"],
      customerId: json["customerId"] ?? 0,
      commodityId: json["commodityId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      pickUpAddr: json["pickUpAddr"] ?? "",
      pickUpLocation: json["pickUpLocation"] ?? "",
      assignStatus: json["assignStatus"] ?? 0,
      pickUpLatlon: json["pickUpLatlon"] ?? "",
      dropAddr: json["dropAddr"] ?? "",
      dropLocation: json["dropLocation"] ?? "",
      dropLatlon: json["dropLatlon"] ?? "",
      dueDate: DateTime.tryParse(json["dueDate"] ?? ""),
      consignmentWeight: json["consignmentWeight"] ?? 0,
      notes: json["notes"] ?? "",
      rate: json["rate"] ?? "",
      status: json["status"] ?? 0,
      loadStatus: json["loadStatus"] ?? 0,
      vehicleLength: json["vehicleLength"] ?? "",
      pickUpDateTime: DateTime.tryParse(json["pickUpDateTime"] ?? ""),
      expectedDeliveryDateTime: DateTime.tryParse(json["expectedDeliveryDateTime"] ?? ""),
      handlingCharges: json["handlingCharges"] ?? 0,
      acceptedBy: json["acceptedBy"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      commodity: json["commodity"] == null ? null : Commodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      customerDetail: json["customerDetail"],
    );
  }

}

class Commodity {
  Commodity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  Commodity copyWith({
    int? id,
    String? name,
  }) {
    return Commodity(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory Commodity.fromJson(Map<String, dynamic> json){
    return Commodity(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
    );
  }

}

class Customer {
  Customer({
    required this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.emailId,
    required this.blueId,
    required this.password,
    required this.otp,
    required this.otpAttempt,
    required this.isKyc,
    required this.roleId,
    required this.tempFlg,
    required this.status,
    required this.isLogin,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String customerName;
  final String mobileNumber;
  final String emailId;
  final String blueId;
  final dynamic password;
  final num otp;
  final num otpAttempt;
  final num isKyc;
  final num roleId;
  final bool tempFlg;
  final num status;
  final bool isLogin;
  final DateTime? createdAt;
  final dynamic deletedAt;

  Customer copyWith({
    int? id,
    String? customerName,
    String? mobileNumber,
    String? emailId,
    String? blueId,
    dynamic? password,
    num? otp,
    num? otpAttempt,
    num? isKyc,
    num? roleId,
    bool? tempFlg,
    num? status,
    bool? isLogin,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailId: emailId ?? this.emailId,
      blueId: blueId ?? this.blueId,
      password: password ?? this.password,
      otp: otp ?? this.otp,
      otpAttempt: otpAttempt ?? this.otpAttempt,
      isKyc: isKyc ?? this.isKyc,
      roleId: roleId ?? this.roleId,
      tempFlg: tempFlg ?? this.tempFlg,
      status: status ?? this.status,
      isLogin: isLogin ?? this.isLogin,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      id: json["id"] ?? 0,
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      emailId: json["emailId"] ?? "",
      blueId: json["blueId"] ?? "",
      password: json["password"],
      otp: json["otp"] ?? 0,
      otpAttempt: json["otpAttempt"] ?? 0,
      isKyc: json["isKyc"] ?? 0,
      roleId: json["roleId"] ?? 0,
      tempFlg: json["tempFlg"] ?? false,
      status: json["status"] ?? 0,
      isLogin: json["isLogin"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class TruckType {
  TruckType({
    required this.id,
    required this.type,
  });

  final int id;
  final String type;

  TruckType copyWith({
    int? id,
    String? type,
  }) {
    return TruckType(
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }

  factory TruckType.fromJson(Map<String, dynamic> json){
    return TruckType(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
    );
  }

}


