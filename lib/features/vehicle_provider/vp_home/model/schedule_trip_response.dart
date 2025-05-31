class ScheduleTripResponse {
  ScheduleTripResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  factory ScheduleTripResponse.fromJson(Map<String, dynamic> json){
    return ScheduleTripResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };

}

class Data {
  Data({
    required this.createdAt,
    required this.id,
    required this.vehicleId,
    required this.driverId,
    required this.acceptedBy,
    required this.etaForPickUp,
    required this.expectedDeliveryDate,
    required this.status,
    required this.loadId,
    required this.deletedAt,
  });

  final DateTime? createdAt;
  final int id;
  final num vehicleId;
  final num driverId;
  final num acceptedBy;
  final DateTime? etaForPickUp;
  final DateTime? expectedDeliveryDate;
  final num status;
  final num loadId;
  final dynamic deletedAt;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      id: json["id"] ?? 0,
      vehicleId: json["vehicleId"] ?? 0,
      driverId: json["driverId"] ?? 0,
      acceptedBy: json["acceptedBy"] ?? 0,
      etaForPickUp: DateTime.tryParse(json["etaForPickUp"] ?? ""),
      expectedDeliveryDate: DateTime.tryParse(json["expectedDeliveryDate"] ?? ""),
      status: json["status"] ?? 0,
      loadId: json["loadId"] ?? 0,
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt?.toIso8601String(),
    "id": id,
    "vehicleId": vehicleId,
    "driverId": driverId,
    "acceptedBy": acceptedBy,
    "etaForPickUp": etaForPickUp?.toIso8601String(),
    "expectedDeliveryDate": expectedDeliveryDate?.toIso8601String(),
    "status": status,
    "loadId": loadId,
    "deletedAt": deletedAt,
  };

}
