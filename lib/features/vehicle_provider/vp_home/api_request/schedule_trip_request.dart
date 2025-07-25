class ScheduleTripRequest {
  ScheduleTripRequest({
    required this.vehicleId,
    required this.driverId,
    required this.acceptedBy,
    required this.etaForPickUp,
    required this.possibleDeliveryDate,
    required this.loadId,
    required this.expectedDeliveryDate,
  });

  final String? vehicleId;
  final String? loadId;
  final String? driverId;
  final String? acceptedBy;
  final String? etaForPickUp;
  final String? possibleDeliveryDate;
  final String? expectedDeliveryDate;




  Map<String, dynamic> toJson() => {
    "loadId": loadId,
    "vehicleId": vehicleId,
    "driverId": driverId,
    "acceptedBy": acceptedBy,
    "etaForPickUp": etaForPickUp,
    "possibleDeliveryDate": possibleDeliveryDate,
    "expectedDeliveryDate":expectedDeliveryDate
  };

}
