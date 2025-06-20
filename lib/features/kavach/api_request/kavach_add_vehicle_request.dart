class KavachAddVehicleRequest {
  final int customerId;
  final String vehicleNumber;
  final int vehicleTypeId;
  final String rcNumber;
  final String rcDocLink;
  final String truckMakeAndModel;
  final String truckType;
  final String truckLength;
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
      "vehicleNumber": vehicleNumber,
      "vehicleTypeId": vehicleTypeId,
      "rcNumber": rcNumber,
      "rcDocLink": rcDocLink,
      "truckMakeAndModel": truckMakeAndModel,
      "truckType": truckType,
      "truckLength": truckLength,
      "capacity": capacity,
      "acceptableCommodities": acceptableCommodities,
      "vehicleStatus": vehicleStatus,
    };
  }
}
