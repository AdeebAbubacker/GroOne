class ScheduleTripResponse {
  ScheduleTripResponse({

    required this.data,
  });


  final Data? data;

  factory ScheduleTripResponse.fromJson(Map<String, dynamic> json){
    return ScheduleTripResponse(
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

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
  final String? id;
  final String? vehicleId;
  final String? driverId;
  final String? acceptedBy;
  final DateTime? etaForPickUp;
  final DateTime? expectedDeliveryDate;
  final dynamic status;
  final dynamic loadId;
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
