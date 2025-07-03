class LpGetLoadModel {
  LpGetLoadModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<LoadData> data;

  LpGetLoadModel copyWith({
    bool? success,
    String? message,
    List<LoadData>? data,
  }) {
    return LpGetLoadModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LpGetLoadModel.fromJson(Map<String, dynamic> json){
    return LpGetLoadModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<LoadData>.from(json["data"]!.map((x) => LoadData.fromJson(x))),
    );
  }

}

class LoadData {
  LoadData({
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
    required this.maxRate,
    required this.vpRate,
    required this.status,
    required this.loadStatus,
    required this.vehicleLength,
    required this.pickUpDateTime,
    required this.expectedDeliveryDateTime,
    required this.pickUpWholeAddr,
    required this.dropWholeAddr,
    required this.handlingCharges,
    required this.acceptedBy,
    required this.matchingStartDate,
    required this.agreedPrice,
    required this.acceptedVehicleId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.loadStatusDetails,
    required this.customer,
  });

  final int id;
  final String loadId;
  final num laneId;
  final num rateId;
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
  final String? maxRate;
  final String vpRate;
  final num status;
  final num loadStatus;
  final String vehicleLength;
  final DateTime? pickUpDateTime;
  final DateTime? expectedDeliveryDateTime;
  final String pickUpWholeAddr;
  final String dropWholeAddr;
  final num handlingCharges;
  final num acceptedBy;
  final DateTime? matchingStartDate;
  final num agreedPrice;
  final num acceptedVehicleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final LoadStatusDetails? loadStatusDetails;
  final Customer? customer;

  LoadData copyWith({
    int? id,
    String? loadId,
    num? laneId,
    num? rateId,
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
    String? maxRate,
    String? vpRate,
    num? status,
    num? loadStatus,
    String? vehicleLength,
    DateTime? pickUpDateTime,
    DateTime? expectedDeliveryDateTime,
    String? pickUpWholeAddr,
    String? dropWholeAddr,
    num? handlingCharges,
    num? acceptedBy,
    DateTime? matchingStartDate,
    num? agreedPrice,
    num? acceptedVehicleId,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
    LoadStatusDetails? loadStatusDetails,
    Customer? customer,
  }) {
    return LoadData(
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
      maxRate: maxRate ?? this.maxRate,
      vpRate: vpRate ?? this.vpRate,
      status: status ?? this.status,
      loadStatus: loadStatus ?? this.loadStatus,
      vehicleLength: vehicleLength ?? this.vehicleLength,
      pickUpDateTime: pickUpDateTime ?? this.pickUpDateTime,
      expectedDeliveryDateTime: expectedDeliveryDateTime ?? this.expectedDeliveryDateTime,
      pickUpWholeAddr: pickUpWholeAddr ?? this.pickUpWholeAddr,
      dropWholeAddr: dropWholeAddr ?? this.dropWholeAddr,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      matchingStartDate: matchingStartDate ?? this.matchingStartDate,
      agreedPrice: agreedPrice ?? this.agreedPrice,
      acceptedVehicleId: acceptedVehicleId ?? this.acceptedVehicleId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      loadStatusDetails: loadStatusDetails ?? this.loadStatusDetails,
      customer: customer ?? this.customer,
    );
  }

  factory LoadData.fromJson(Map<String, dynamic> json){
    return LoadData(
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
      maxRate: json["maxRate"],
      vpRate: json["vpRate"] ?? "",
      status: json["status"] ?? 0,
      loadStatus: json["loadStatus"] ?? 0,
      vehicleLength: json["vehicleLength"] ?? "",
      pickUpDateTime: DateTime.tryParse(json["pickUpDateTime"] ?? ""),
      expectedDeliveryDateTime: DateTime.tryParse(json["expectedDeliveryDateTime"] ?? ""),
      pickUpWholeAddr: json["pickUpWholeAddr"] ?? "",
      dropWholeAddr: json["dropWholeAddr"] ?? "",
      handlingCharges: json["handlingCharges"] ?? 0,
      acceptedBy: json["acceptedBy"] ?? 0,
      matchingStartDate: DateTime.tryParse(json["matchingStartDate"] ?? ""),
      agreedPrice: json["agreedPrice"] ?? 0,
      acceptedVehicleId: json["acceptedVehicleId"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      loadStatusDetails: json["loadStatusDetails"] == null ? null : LoadStatusDetails.fromJson(json["loadStatusDetails"]),
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    );
  }

}

class Customer {
  Customer({
    required this.id,
    required this.customerName,
    required this.createdAt,
    required this.kycPendingDate,
  });

  final int id;
  final String customerName;
  final DateTime? createdAt;
  final DateTime? kycPendingDate;

  Customer copyWith({
    int? id,
    String? customerName,
    DateTime? createdAt,
    DateTime? kycPendingDate,
  }) {
    return Customer(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      createdAt: createdAt ?? this.createdAt,
      kycPendingDate: kycPendingDate ?? this.kycPendingDate,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      id: json["id"] ?? 0,
      customerName: json["customerName"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      kycPendingDate: DateTime.tryParse(json["kycPendingDate"] ?? ""),
    );
  }

}

class LoadStatusDetails {
  LoadStatusDetails({
    required this.id,
    required this.loadType,
  });

  final int id;
  final String loadType;

  LoadStatusDetails copyWith({
    int? id,
    String? loadType,
  }) {
    return LoadStatusDetails(
      id: id ?? this.id,
      loadType: loadType ?? this.loadType,
    );
  }

  factory LoadStatusDetails.fromJson(Map<String, dynamic> json){
    return LoadStatusDetails(
      id: json["id"] ?? 0,
      loadType: json["load_type"] ?? "",
    );
  }

}
