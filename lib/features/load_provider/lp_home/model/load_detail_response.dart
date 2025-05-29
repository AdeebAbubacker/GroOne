class LoadDetailResponse {
  LoadDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final LoadDetail? data;

  factory LoadDetailResponse.fromJson(Map<String, dynamic> json){
    return LoadDetailResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : LoadDetail.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };

}

class LoadDetail {
  LoadDetail({
    required this.id,
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.pickUpAddr,
    required this.pickUpLatlon,
    required this.dropAddr,
    required this.dropLatlon,
    required this.dueDate,
    required this.consignmentWeight,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final num customerId;
  final num commodityId;
  final num truckTypeId;
  final String pickUpAddr;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropLatlon;
  final dynamic dueDate;
  final num consignmentWeight;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  factory LoadDetail.fromJson(Map<String, dynamic> json){
    return LoadDetail(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      commodityId: json["commodityId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      pickUpAddr: json["pickUpAddr"] ?? "",
      pickUpLatlon: json["pickUpLatlon"] ?? "",
      dropAddr: json["dropAddr"] ?? "",
      dropLatlon: json["dropLatlon"] ?? "",
      dueDate: json["dueDate"],
      consignmentWeight: json["consignmentWeight"] ?? 0,
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "commodityId": commodityId,
    "truckTypeId": truckTypeId,
    "pickUpAddr": pickUpAddr,
    "pickUpLatlon": pickUpLatlon,
    "dropAddr": dropAddr,
    "dropLatlon": dropLatlon,
    "dueDate": dueDate,
    "consignmentWeight": consignmentWeight,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}
