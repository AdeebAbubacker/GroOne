// lib/features/gps_feature/model/report_models.dart
import 'package:equatable/equatable.dart';

// Helper function to safely parse numbers
T _parseNum<T>(dynamic value) {
  if (value == null) {
    if (T == int) return 0 as T;
    if (T == double) return 0.0 as T;
    return '' as T;
  }
  if (value is T) return value;
  if (value is String) {
    if (T == int) return int.tryParse(value) as T? ?? 0 as T;
    if (T == double) return double.tryParse(value) as T? ?? 0.0 as T;
  }
  if (value is num) {
    if (T == int) return value.toInt() as T;
    if (T == double) return value.toDouble() as T;
  }
  if (T == int) return 0 as T;
  if (T == double) return 0.0 as T;
  return '' as T;
}

// Helper function to safely parse strings
String _parseString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is num) return value.toString();
  return value.toString();
}

// --- Model for 'STOPS' Report ---
class StopReport extends Equatable {
  final int deviceId;
  final String duration;
  final String endTime;
  final double latitude;
  final double longitude;
  final String address;
  final String startTime;

  const StopReport({ required this.deviceId, required this.duration, required this.endTime, required this.latitude, required this.longitude, required this.address, required this.startTime });

  factory StopReport.fromJson(Map<String, dynamic> json) {
    return StopReport(
      deviceId: _parseNum<int>(json['device_id']),
      duration: _parseString(json['duration']),
      endTime: _parseString(json['end_time']),
      latitude: _parseNum<double>(json['latitude']),
      longitude: _parseNum<double>(json['longitude']),
      address: _parseString(json['address'] ?? json['location']),
      startTime: _parseString(json['start_time']),
    );
  }
  @override
  List<Object?> get props => [deviceId, startTime];
}

// --- Model for 'TRIPS' Report ---
class TripReport extends Equatable {
  final int deviceId;
  final String deviceName;
  final double distance;
  final String duration;
  final String startAddress;
  final String endAddress;
  final String startTime;
  final String endTime;
  final double avgSpeed;
  final double maxSpeed;
  final double safetyScore;
  final String engineTime;
  final String idleTime;
  final String reportDate;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final int harshAcceleration;
  final int harshBraking;
  final int harshCornering;
  final int overSpeed;
  final int crash;
  final int startPositionId;
  final int endPositionId;

  const TripReport({ 
    required this.deviceId,
    required this.deviceName,
    required this.distance, 
    required this.duration, 
    required this.startAddress, 
    required this.endAddress, 
    required this.startTime, 
    required this.endTime, 
    required this.avgSpeed, 
    required this.maxSpeed,
    required this.safetyScore,
    required this.engineTime,
    required this.idleTime,
    required this.reportDate,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.harshAcceleration,
    required this.harshBraking,
    required this.harshCornering,
    required this.overSpeed,
    required this.crash,
    required this.startPositionId,
    required this.endPositionId,
  });

  // Helper getter for safety count as integer
  int get safetyCount => safetyScore.toInt();

  factory TripReport.fromJson(Map<String, dynamic> json) {
    return TripReport(
      deviceId: _parseNum<int>(json['device_id']),
      deviceName: _parseString(json['device_name']),
      distance: _parseNum<double>(json['distance']),
      duration: _parseString(json['duration']),
      startAddress: _parseString(json['start_location']),
      endAddress: _parseString(json['end_location']),
      startTime: _parseString(json['start_time']),
      endTime: _parseString(json['end_time']),
      avgSpeed: _parseNum<double>(json['avg_speed']),
      maxSpeed: _parseNum<double>(json['max_speed']),
      safetyScore: _parseNum<double>(json['driving_safety_score']),
      engineTime: _parseString(json['duration']), // Trip duration as engine time
      idleTime: _parseString(json['excessive_idle_time']),
      reportDate: _parseString(json['@timestamp']),
      startLat: _parseNum<double>(json['start_lat']),
      startLng: _parseNum<double>(json['start_lng']),
      endLat: _parseNum<double>(json['end_lat']),
      endLng: _parseNum<double>(json['end_lng']),
      harshAcceleration: _parseNum<int>(json['harsh_acceleration']),
      harshBraking: _parseNum<int>(json['harsh_braking']),
      harshCornering: _parseNum<int>(json['harsh_cornering']),
      overSpeed: _parseNum<int>(json['over_speed']),
      crash: _parseNum<int>(json['crash']),
      startPositionId: _parseNum<int>(json['start_position_id']),
      endPositionId: _parseNum<int>(json['end_position_id']),
    );
  }
  @override
  List<Object?> get props => [deviceId, startTime];
}

// --- Model for 'DAILY (Summary)' Report ---
class SummaryReport extends Equatable {
  final int deviceId;
  final String deviceName;
  final double distance;
  final String engineTime;
  final String idleTime;
  final double maxSpeed;
  final double avgSpeed;
  final String startTime;
  final String endTime;
  final String reportDate;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final String startAddress;
  final String endAddress;
  final double safetyScore;
  final int harshAcceleration;
  final int harshBraking;
  final int harshCornering;
  final int overSpeed;
  final int crash;

  const SummaryReport({
    required this.deviceId,
    required this.deviceName,
    required this.distance,
    required this.engineTime,
    required this.idleTime,
    required this.maxSpeed,
    required this.avgSpeed,
    required this.startTime,
    required this.endTime,
    required this.reportDate,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.startAddress,
    required this.endAddress,
    required this.safetyScore,
    required this.harshAcceleration,
    required this.harshBraking,
    required this.harshCornering,
    required this.overSpeed,
    required this.crash,
  });

  // Helper getter for safety count as integer
  int get safetyCount => safetyScore.toInt();

  factory SummaryReport.fromJson(Map<String, dynamic> json) {
    return SummaryReport(
      deviceId: _parseNum<int>(json['device_id']),
      deviceName: _parseString(json['device_name']),
      distance: _parseNum<double>(json['distance']),
      engineTime: _parseString(json['engine_time']),
      idleTime: _parseString(json['idle_time']),
      maxSpeed: _parseNum<double>(json['max_speed']),
      avgSpeed: _parseNum<double>(json['avg_speed']),
      startTime: _parseString(json['start_time']),
      endTime: _parseString(json['end_time']),
      reportDate: _parseString(json['@timestamp']),
      startLat: _parseNum<double>(json['start_lat']),
      startLng: _parseNum<double>(json['start_lng']),
      endLat: _parseNum<double>(json['end_lat']),
      endLng: _parseNum<double>(json['end_lng']),
      startAddress: _parseString(json['start_location']),
      endAddress: _parseString(json['end_location']),
      safetyScore: _parseNum<double>(json['driving_safety_score']),
      harshAcceleration: _parseNum<int>(json['harsh_acceleration']),
      harshBraking: _parseNum<int>(json['harsh_braking']),
      harshCornering: _parseNum<int>(json['harsh_cornering']),
      overSpeed: _parseNum<int>(json['over_speed']),
      crash: _parseNum<int>(json['crash']),
    );
  }
  @override
  List<Object?> get props => [deviceId, startTime, endTime];
}

// --- Model for 'REACHABILITY' Report ---
class ReachabilityReport extends Equatable {
  final String dateAdded;
  final int deviceId;
  final int email;
  final String geofenceId;
  final String geofenceName;
  final int id;
  final double lat;
  final double latAtReach;
  final double lng;
  final double lngAtReach;
  final String notificationConfigs;
  final double radius;
  final String reachDate;
  final String sms;
  final String status;
  final int userId;
  final int web;
  final String setAddress;
  final String endAddress;

  const ReachabilityReport({ 
    required this.dateAdded,
    required this.deviceId, 
    required this.email,
    required this.geofenceId,
    required this.geofenceName, 
    required this.id,
    required this.lat,
    required this.latAtReach,
    required this.lng,
    required this.lngAtReach,
    required this.notificationConfigs,
    required this.radius,
    required this.reachDate, 
    required this.sms,
    required this.status,
    required this.userId,
    required this.web,
    required this.setAddress,
    required this.endAddress,
  });

  factory ReachabilityReport.fromJson(Map<String, dynamic> json) {
    return ReachabilityReport(
      dateAdded: _parseString(json['date_added']),
      deviceId: _parseNum<int>(json['device_id']),
      email: _parseNum<int>(json['email']),
      geofenceId: _parseString(json['geofence_id']),
      geofenceName: _parseString(json['geofence_name']),
      id: _parseNum<int>(json['id']),
      lat: _parseNum<double>(json['lat']),
      latAtReach: _parseNum<double>(json['lat_at_reach']),
      lng: _parseNum<double>(json['lng']),
      lngAtReach: _parseNum<double>(json['lng_at_reach']),
      notificationConfigs: _parseString(json['notification_configs']),
      radius: _parseNum<double>(json['radius']),
      reachDate: _parseString(json['reach_date']),
      sms: _parseString(json['sms']),
      status: _parseString(json['status']),
      userId: _parseNum<int>(json['user_id']),
      web: _parseNum<int>(json['web']),
      setAddress: _parseString(json['setAddress']),
      endAddress: _parseString(json['endAddress']),
    );
  }
  
  @override
  List<Object?> get props => [id, deviceId, geofenceId, reachDate];
}

// --- Models for 'DAILY KM' Report ---
class DailyDistanceReport extends Equatable {
  final int deviceId;
  final double totalDistance;
  final List<DailyDistanceItem> dailyDistances;

  const DailyDistanceReport({ required this.deviceId, required this.totalDistance, required this.dailyDistances });

  factory DailyDistanceReport.fromJson(Map<String, dynamic> json) {
    return DailyDistanceReport(
      deviceId: _parseNum<int>(json['device_id']),
      totalDistance: _parseNum<double>(json['total_distance']),
      dailyDistances: (json['nested'] as List<dynamic>?)?.map((e) => DailyDistanceItem.fromJson(e)).toList() ?? [],
    );
  }
  @override
  List<Object?> get props => [deviceId, totalDistance, dailyDistances];
}

class DailyDistanceItem extends Equatable {
  final String date;
  final double distance; // Distance in meters

  const DailyDistanceItem({ required this.date, required this.distance });

  factory DailyDistanceItem.fromJson(Map<String, dynamic> json) {
    return DailyDistanceItem(
      date: _parseString(json['key_as_string'] ?? json['date']),
      distance: _parseNum<double>(json['value'] ?? json['distance']),
    );
  }
  @override
  List<Object?> get props => [date];
}