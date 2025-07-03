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
  final String? etaForPickUp;
  final String? expectedDeliveryDate;



  Map<String, dynamic> toJson() => {
    "loadId": loadId,
    "vehicleId": vehicleId,
    "driverId": driverId,
    "acceptedBy": acceptedBy,
    "etaForPickUp": etaForPickUp,
    "possibleDeliveryDate": expectedDeliveryDate,
  };

}
