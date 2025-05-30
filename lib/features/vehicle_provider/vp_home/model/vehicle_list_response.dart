class VehicleListResponse {
  VehicleListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<VehicleDetail> data;

  factory VehicleListResponse.fromJson(Map<String, dynamic> json){
    return VehicleListResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<VehicleDetail>.from(json["data"]!.map((x) => VehicleDetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };

}

class VehicleDetail {
  VehicleDetail({
    required this.id,
    required this.customerId,
    required this.vehicleNumber,
    required this.vehicleTypeId,
    required this.rcNumber,
    required this.rcDocLink,
    required this.capacity,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final num customerId;
  final String vehicleNumber;
  final num vehicleTypeId;
  final String rcNumber;
  final String rcDocLink;
  final String capacity;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  factory VehicleDetail.fromJson(Map<String, dynamic> json){
    return VehicleDetail(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      vehicleNumber: json["vehicleNumber"] ?? "",
      vehicleTypeId: json["vehicleTypeId"] ?? 0,
      rcNumber: json["rcNumber"] ?? "",
      rcDocLink: json["rcDocLink"] ?? "",
      capacity: json["capacity"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "vehicleNumber": vehicleNumber,
    "vehicleTypeId": vehicleTypeId,
    "rcNumber": rcNumber,
    "rcDocLink": rcDocLink,
    "capacity": capacity,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}
