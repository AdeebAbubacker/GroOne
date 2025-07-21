class VehicleListResponse {
  VehicleListResponse({

    required this.message,
    required this.data,
  });


  final String message;
  final List<VehicleDetail> data;

  factory VehicleListResponse.fromJson(Map<String, dynamic> json){
    return VehicleListResponse(

      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<VehicleDetail>.from(json["data"]!.map((x) => VehicleDetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {

    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };

}

class VehicleDetail {
  VehicleDetail({
    required this.id,
    required this.customerId,
    required this.truckNumber,
    required this.vehicleTypeId,
    required this.rcNumber,
    required this.rcDocLink,
    required this.capacity,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final String? id;
  final String? customerId;
  final String truckNumber;
  final String? vehicleTypeId;
  final String rcNumber;
  final String rcDocLink;
  final String capacity;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  factory VehicleDetail.fromJson(Map<String, dynamic> json){
    return VehicleDetail(
      id: json["vehicleId"]?.toString() ?? '',
      customerId: json["customerId"] ?? "",
      truckNumber: json["truckNo"] ?? "",
      vehicleTypeId: json["vehicleTypeId"] ?? "",
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
    "vehicleNumber": truckNumber,
    "vehicleTypeId": vehicleTypeId,
    "rcNumber": rcNumber,
    "rcDocLink": rcDocLink,
    "capacity": capacity,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}
