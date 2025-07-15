class KavachAddVehicleRequest {
  final String customerId;
  final String vehicleNumber;
  final int vehicleTypeId;
  final String rcNumber;
  final String rcDocLink;
  final String truckMakeAndModel;
  final int truckType;
  final int truckLength;
  final int capacity;
  final List<int> acceptableCommodities;
  final int vehicleStatus;

  KavachAddVehicleRequest({
    required this.customerId,
    required this.vehicleNumber,
    required this.vehicleTypeId,
    required this.rcNumber,
    required this.rcDocLink,
    required this.truckMakeAndModel,
    required this.truckType,
    required this.truckLength,
    required this.capacity,
    required this.acceptableCommodities,
    required this.vehicleStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId,
      "truckNo": vehicleNumber,
      "rcNumber": rcNumber,
      "rcDocLink": rcDocLink,
      "tonnage": "${capacity}T",
      "truckTypeId": truckType,
      "truckMakeAndModel": truckMakeAndModel,
      "acceptableCommodities": acceptableCommodities,
      "truckLength": truckLength,
      "vehicleStatus": vehicleStatus,
    };
  }
}
