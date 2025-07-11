class DriverRecentLoadResponse {
  DriverRecentLoadResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<DriverRecentLoadData> data;

  DriverRecentLoadResponse copyWith({
    bool? success,
    String? message,
    List<DriverRecentLoadData>? data,
  }) {
    return DriverRecentLoadResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory DriverRecentLoadResponse.fromJson(Map<String, dynamic> json){
    return DriverRecentLoadResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<DriverRecentLoadData>.from(json["data"]!.map((x) => DriverRecentLoadData.fromJson(x))),
    );
  }

}

class DriverRecentLoadData {
  DriverRecentLoadData({
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
    required this.agreedPrice,
    required this.acceptedVehicleId,
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
  final int laneId;
  final int rateId;
  final int customerId;
  final int commodityId;
  final int truckTypeId;
  final String pickUpAddr;
  final String pickUpLocation;
  final int assignStatus;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropLocation;
  final String dropLatlon;
  final DateTime? dueDate;
  final int consignmentWeight;
  final String notes;
  final String rate;
  final int status;
  final int loadStatus;
  final String vehicleLength;
  final DateTime? pickUpDateTime;
  final DateTime? expectedDeliveryDateTime;
  final int handlingCharges;
  final dynamic acceptedBy;
  final int agreedPrice;
  final int acceptedVehicleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final Commodity? commodity;
  final TruckType? truckType;
  final DriversCustomer? customer;
  final DriversCustomerDetail? customerDetail;

  DriverRecentLoadData copyWith({
    int? id,
    String? loadId,
    int? laneId,
    int? rateId,
    int? customerId,
    int? commodityId,
    int? truckTypeId,
    String? pickUpAddr,
    String? pickUpLocation,
    int? assignStatus,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropLocation,
    String? dropLatlon,
    DateTime? dueDate,
    int? consignmentWeight,
    String? notes,
    String? rate,
    int? status,
    int? loadStatus,
    String? vehicleLength,
    DateTime? pickUpDateTime,
    DateTime? expectedDeliveryDateTime,
    int? handlingCharges,
    dynamic? acceptedBy,
    int? agreedPrice,
    int? acceptedVehicleId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    Commodity? commodity,
    TruckType? truckType,
    DriversCustomer? customer,
    DriversCustomerDetail? customerDetail,
  }) {
    return DriverRecentLoadData(
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
      agreedPrice: agreedPrice ?? this.agreedPrice,
      acceptedVehicleId: acceptedVehicleId ?? this.acceptedVehicleId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      customer: customer ?? this.customer,
      customerDetail: customerDetail ?? this.customerDetail,
    );
  }

  factory DriverRecentLoadData.fromJson(Map<String, dynamic> json){
    return DriverRecentLoadData(
      id: json["id"] ?? 0,
      loadId: json["loadId"] ?? "",
      laneId: json["laneId"] ?? 0,
      rateId: json["rateId"] ?? 0,
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
      agreedPrice: json["agreedPrice"] ?? 0,
      acceptedVehicleId: json["acceptedVehicleId"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: DateTime.tryParse(json["deletedAt"] ?? ""),
      commodity: json["commodity"] == null ? null : Commodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
      customer: json["customer"] == null ? null : DriversCustomer.fromJson(json["customer"]),
      customerDetail: json["customerDetail"] == null ? null : DriversCustomerDetail.fromJson(json["customerDetail"]),
    );
  }

}

class Commodity {
  Commodity({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  final int id;
  final String name;
  final dynamic iconUrl;

  Commodity copyWith({
    int? id,
    String? name,
    dynamic? iconUrl,
  }) {
    return Commodity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  factory Commodity.fromJson(Map<String, dynamic> json){
    return Commodity(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      iconUrl: json["iconUrl"],
    );
  }

}

class DriversCustomer {
  DriversCustomer({
    required this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.emailId,
  });

  final int id;
  final String customerName;
  final String mobileNumber;
  final String emailId;

  DriversCustomer copyWith({
    int? id,
    String? customerName,
    String? mobileNumber,
    String? emailId,
  }) {
    return DriversCustomer(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailId: emailId ?? this.emailId,
    );
  }

  factory DriversCustomer.fromJson(Map<String, dynamic> json){
    return DriversCustomer(
      id: json["id"] ?? 0,
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      emailId: json["emailId"] ?? "",
    );
  }

}

class DriversCustomerDetail {
  DriversCustomerDetail({
    required this.id,
    required this.companyName,
    required this.companyTypeId,
  });

  final int id;
  final String companyName;
  final int companyTypeId;

  DriversCustomerDetail copyWith({
    int? id,
    String? companyName,
    int? companyTypeId,
  }) {
    return DriversCustomerDetail(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      companyTypeId: companyTypeId ?? this.companyTypeId,
    );
  }

  factory DriversCustomerDetail.fromJson(Map<String, dynamic> json){
    return DriversCustomerDetail(
      id: json["id"] ?? 0,
      companyName: json["companyName"] ?? "",
      companyTypeId: json["companyTypeId"] ?? 0,
    );
  }

}

class TruckType {
  TruckType({
    required this.id,
    required this.type,
    required this.subType,
  });

  final int id;
  final String type;
  final String subType;

  TruckType copyWith({
    int? id,
    String? type,
    String? subType,
  }) {
    return TruckType(
      id: id ?? this.id,
      type: type ?? this.type,
      subType: subType ?? this.subType,
    );
  }

  factory TruckType.fromJson(Map<String, dynamic> json){
    return TruckType(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
    );
  }

}
