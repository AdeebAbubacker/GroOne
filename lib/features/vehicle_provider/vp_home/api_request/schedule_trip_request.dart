class ScheduleTripRequest {
  ScheduleTripRequest({
    required this.vehicleId,
    required this.driverId,
    required this.acceptedBy,
    required this.etaForPickUp,
    required this.expectedDeliveryDate,
  });

  final int vehicleId;
  final int driverId;
  final String acceptedBy;
  final DateTime? etaForPickUp;
  final DateTime? expectedDeliveryDate;

  factory ScheduleTripRequest.fromJson(Map<String, dynamic> json){
    return ScheduleTripRequest(
      vehicleId: json["vehicleId"] ?? 0,
      driverId: json["driverId"] ?? 0,
      acceptedBy: json["acceptedBy"] ?? "",
      etaForPickUp: DateTime.tryParse(json["etaForPickUp"] ?? ""),
      expectedDeliveryDate: DateTime.tryParse(json["expectedDeliveryDate"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    "driverId": driverId,
    "acceptedBy": acceptedBy,
    "etaForPickUp": etaForPickUp?.toIso8601String(),
    "expectedDeliveryDate": expectedDeliveryDate?.toIso8601String(),
  };

}
