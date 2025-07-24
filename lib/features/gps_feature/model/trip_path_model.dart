class TripPathResponse {
  final List<TripPath> data;

  TripPathResponse({required this.data});

  factory TripPathResponse.fromJson(Map<String, dynamic> json) {
    return TripPathResponse(
      data:
          (json['data'] as List<dynamic>)
              .map((e) => TripPath.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.map((e) => e.toJson()).toList()};
  }
}

class TripPath {
  final String? timestamp;
  final int? deviceId;
  final String? deviceTime;
  final String? serverTime;
  final double? latitude;
  final double? longitude;
  final double? speed;
  final String? ignition;
  final String? motion;
  final double? altitude;
  final double? distance;
  final double? totalDistance;
  final String? location;
  final String? fixTime;
  final String? stopTime;
  final double? temperature;
  final String? engineHours;
  final double? extPower;
  final String? engine2;

  TripPath({
    this.timestamp,
    this.deviceId,
    this.deviceTime,
    this.serverTime,
    this.latitude,
    this.longitude,
    this.speed,
    this.ignition,
    this.motion,
    this.altitude,
    this.distance,
    this.totalDistance,
    this.location,
    this.fixTime,
    this.stopTime,
    this.temperature,
    this.engineHours,
    this.extPower,
    this.engine2,
  });

  factory TripPath.fromJson(Map<String, dynamic> json) {
    return TripPath(
      timestamp: json['@timestamp']?.toString(),
      deviceId:
          json['device_id'] is int
              ? json['device_id']
              : int.tryParse(json['device_id']?.toString() ?? ''),
      deviceTime: json['device_time']?.toString(),
      serverTime: json['server_time']?.toString(),
      latitude:
          json['latitude'] is double
              ? json['latitude']
              : double.tryParse(json['latitude']?.toString() ?? ''),
      longitude:
          json['longitude'] is double
              ? json['longitude']
              : double.tryParse(json['longitude']?.toString() ?? ''),
      speed:
          json['speed'] is double
              ? json['speed']
              : double.tryParse(json['speed']?.toString() ?? ''),
      ignition: json['ignition']?.toString(),
      motion: json['motion']?.toString(),
      altitude:
          json['altitude'] is double
              ? json['altitude']
              : double.tryParse(json['altitude']?.toString() ?? ''),
      distance:
          json['distance'] is double
              ? json['distance']
              : double.tryParse(json['distance']?.toString() ?? ''),
      totalDistance:
          json['total_distance'] is double
              ? json['total_distance']
              : double.tryParse(json['total_distance']?.toString() ?? ''),
      location: json['location']?.toString(),
      fixTime: json['fix_time']?.toString(),
      stopTime: json['stop_time']?.toString(),
      temperature:
          json['temperature'] is double
              ? json['temperature']
              : double.tryParse(json['temperature']?.toString() ?? ''),
      engineHours: json['engine_hours']?.toString(),
      extPower:
          json['ext_power'] is double
              ? json['ext_power']
              : double.tryParse(json['ext_power']?.toString() ?? ''),
      engine2: json['engine2']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '@timestamp': timestamp,
      'device_id': deviceId,
      'device_time': deviceTime,
      'server_time': serverTime,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'ignition': ignition,
      'motion': motion,
      'altitude': altitude,
      'distance': distance,
      'total_distance': totalDistance,
      'location': location,
      'fix_time': fixTime,
      'stop_time': stopTime,
      'temperature': temperature,
      'engine_hours': engineHours,
      'ext_power': extPower,
      'engine2': engine2,
    };
  }
}
