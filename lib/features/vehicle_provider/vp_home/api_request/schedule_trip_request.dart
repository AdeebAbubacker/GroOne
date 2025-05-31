class ScheduleTripRequest {
  ScheduleTripRequest({
    required this.vehicleId,
    required this.driverId,
    required this.acceptedBy,
    required this.etaForPickUp,
    required this.expectedDeliveryDate,
    required this.loadId,
  });

  final int vehicleId;
  final int loadId;
  final int driverId;
  final int acceptedBy;
  final DateTime? etaForPickUp;
  final DateTime? expectedDeliveryDate;

  factory ScheduleTripRequest.fromJson(Map<String, dynamic> json){
    return ScheduleTripRequest(
      loadId: json['loadId']??0,
      vehicleId: json["vehicleId"] ?? 0,
      driverId: json["driverId"] ?? 0,
      acceptedBy: json["acceptedBy"] ?? 0,
      etaForPickUp: DateTime.tryParse(json["etaForPickUp"] ?? ""),
      expectedDeliveryDate: DateTime.tryParse(json["expectedDeliveryDate"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "loadId": loadId,
    "vehicleId": vehicleId,
    "driverId": driverId,
    "acceptedBy": acceptedBy,
    "etaForPickUp": etaForPickUp?.toIso8601String(),
    "expectedDeliveryDate": expectedDeliveryDate?.toIso8601String(),
  };

}
