class VehicleDataResponse {
  final String totalVehicles;
  final String activeVehicles;
  final String inactiveVehicles;
  final int idleCount;
  final int ignitionOnCount;
  final int ignitionOffCount;
  final String totalDistance;
  final String todaysDistance;
  final String yesterdaysDistance;
  final String vehicleNumber;

  VehicleDataResponse({
    required this.totalVehicles,
    required this.activeVehicles,
    required this.inactiveVehicles,
    required this.idleCount,
    required this.ignitionOnCount,
    required this.ignitionOffCount,
    required this.totalDistance,
    required this.todaysDistance,
    required this.yesterdaysDistance,
    required this.vehicleNumber,
  });
}
