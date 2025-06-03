class KavachVehicleModel {
  final int id;
  final int customerId;
  final String vehicleNumber;
  final int vehicleTypeId;
  final String rcNumber;
  final String rcDocLink;
  final String capacity;
  final int status;
  final String createdAt;

  KavachVehicleModel({
    required this.id,
    required this.customerId,
    required this.vehicleNumber,
    required this.vehicleTypeId,
    required this.rcNumber,
    required this.rcDocLink,
    required this.capacity,
    required this.status,
    required this.createdAt,
  });

  factory KavachVehicleModel.fromJson(Map<String, dynamic> json) {
    return KavachVehicleModel(
      id: json['id'],
      customerId: json['customerId'],
      vehicleNumber: json['vehicleNumber'],
      vehicleTypeId: json['vehicleTypeId'],
      rcNumber: json['rcNumber'],
      rcDocLink: json['rcDocLink'],
      capacity: json['capacity'],
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }
}
