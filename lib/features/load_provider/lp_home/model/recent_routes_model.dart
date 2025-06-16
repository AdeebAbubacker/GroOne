class RecentRoutesModel {
  RecentRoutesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<RecentRouteData> data;

  RecentRoutesModel copyWith({
    bool? success,
    String? message,
    List<RecentRouteData>? data,
  }) {
    return RecentRoutesModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory RecentRoutesModel.fromJson(Map<String, dynamic> json){
    return RecentRoutesModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<RecentRouteData>.from(json["data"]!.map((x) => RecentRouteData.fromJson(x))),
    );
  }

}

class RecentRouteData {
  RecentRouteData({
    required this.id,
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.loadId,
    required this.pickUpAddr,
    required this.assignStatus,
    required this.pickUpLocation,
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
    required this.laneId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int id;
  final num customerId;
  final num commodityId;
  final num truckTypeId;
  final dynamic loadId;
  final String pickUpAddr;
  final num assignStatus;
  final dynamic pickUpLocation;
  final String pickUpLatlon;
  final String dropAddr;
  final dynamic dropLocation;
  final String dropLatlon;
  final DateTime? dueDate;
  final num consignmentWeight;
  final String notes;
  final String rate;
  final num status;
  final num loadStatus;
  final String vehicleLength;
  final dynamic pickUpDateTime;
  final DateTime? expectedDeliveryDateTime;
  final num handlingCharges;
  final num acceptedBy;
  final num laneId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  RecentRouteData copyWith({
    int? id,
    num? customerId,
    num? commodityId,
    num? truckTypeId,
    dynamic? loadId,
    String? pickUpAddr,
    num? assignStatus,
    dynamic? pickUpLocation,
    String? pickUpLatlon,
    String? dropAddr,
    dynamic? dropLocation,
    String? dropLatlon,
    DateTime? dueDate,
    num? consignmentWeight,
    String? notes,
    String? rate,
    num? status,
    num? loadStatus,
    String? vehicleLength,
    dynamic? pickUpDateTime,
    DateTime? expectedDeliveryDateTime,
    num? handlingCharges,
    num? acceptedBy,
    num? laneId,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
  }) {
    return RecentRouteData(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      commodityId: commodityId ?? this.commodityId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      loadId: loadId ?? this.loadId,
      pickUpAddr: pickUpAddr ?? this.pickUpAddr,
      assignStatus: assignStatus ?? this.assignStatus,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
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
      laneId: laneId ?? this.laneId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory RecentRouteData.fromJson(Map<String, dynamic> json){
    return RecentRouteData(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      commodityId: json["commodityId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      loadId: json["loadId"],
      pickUpAddr: json["pickUpAddr"] ?? "",
      assignStatus: json["assignStatus"] ?? 0,
      pickUpLocation: json["pickUpLocation"] ?? "" ,
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
      pickUpDateTime: json["pickUpDateTime"],
      expectedDeliveryDateTime: DateTime.tryParse(json["expectedDeliveryDateTime"] ?? ""),
      handlingCharges: json["handlingCharges"] ?? 0,
      acceptedBy: json["acceptedBy"] ?? 0,
      laneId: json["laneId"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}
