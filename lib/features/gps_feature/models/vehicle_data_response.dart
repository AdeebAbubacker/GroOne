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

class VehicleData {
  final String id;
  final String vehicleNumber;
  final VehicleStatus status;
  final String statusDuration;
  final String location;
  final int networkSignal; // 1-5
  final bool hasGPS;
  final String odoReading;
  final String todayDistance;
  final String lastSpeed;
  final DateTime lastUpdate;

  VehicleData({
    required this.id,
    required this.vehicleNumber,
    required this.status,
    required this.statusDuration,
    required this.location,
    required this.networkSignal,
    required this.hasGPS,
    required this.odoReading,
    required this.todayDistance,
    required this.lastSpeed,
    required this.lastUpdate,
  });
}

enum VehicleStatus { active, off, inactive }

enum VehicleTabType { all, active, off, inactive }

class VehicleStatusCount {
  final int active;
  final int off;
  final int inactive;

  VehicleStatusCount({
    required this.active,
    required this.off,
    required this.inactive,
  });
}
