import 'package:equatable/equatable.dart';

/// Model for reachability notification configuration
class ReachabilityConfig extends Equatable {
  final String id;
  final String vehicleId;
  final String vehicleNumber;
  final LocationMethod locationMethod;
  final String? locationAddress;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final String? geofenceId;
  final String? geofenceName;
  final DateTime? selectedDate;
  final DateTime? selectedTime;
  final List<NotificationMethod> notificationMethods;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReachabilityConfig({
    required this.id,
    required this.vehicleId,
    required this.vehicleNumber,
    required this.locationMethod,
    this.locationAddress,
    this.latitude,
    this.longitude,
    this.radius,
    this.geofenceId,
    this.geofenceName,
    this.selectedDate,
    this.selectedTime,
    required this.notificationMethods,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReachabilityConfig.fromJson(Map<String, dynamic> json) {
    return ReachabilityConfig(
      id: json['id']?.toString() ?? '',
      vehicleId: json['vehicle_id']?.toString() ?? '',
      vehicleNumber: json['vehicle_number']?.toString() ?? '',
      locationMethod: LocationMethod.values.firstWhere(
        (e) => e.name == json['location_method'],
        orElse: () => LocationMethod.newLocation,
      ),
      locationAddress: json['location_address']?.toString(),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      radius: json['radius']?.toDouble(),
      geofenceId: json['geofence_id']?.toString(),
      geofenceName: json['geofence_name']?.toString(),
      selectedDate:
          json['selected_date'] != null
              ? DateTime.parse(json['selected_date'])
              : null,
      selectedTime:
          json['selected_time'] != null
              ? DateTime.parse(json['selected_time'])
              : null,
      notificationMethods:
          (json['notification_methods'] as List<dynamic>?)
              ?.map(
                (e) => NotificationMethod.values.firstWhere(
                  (method) => method.name == e,
                  orElse: () => NotificationMethod.email,
                ),
              )
              .toList() ??
          [],
      status: json['status']?.toString() ?? 'active',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'vehicle_number': vehicleNumber,
      'location_method': locationMethod.name,
      'location_address': locationAddress,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'geofence_id': geofenceId,
      'geofence_name': geofenceName,
      'selected_date': selectedDate?.toIso8601String(),
      'selected_time': selectedTime?.toIso8601String(),
      'notification_methods': notificationMethods.map((e) => e.name).toList(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ReachabilityConfig copyWith({
    String? id,
    String? vehicleId,
    String? vehicleNumber,
    LocationMethod? locationMethod,
    String? locationAddress,
    double? latitude,
    double? longitude,
    double? radius,
    String? geofenceId,
    String? geofenceName,
    DateTime? selectedDate,
    DateTime? selectedTime,
    List<NotificationMethod>? notificationMethods,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReachabilityConfig(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      locationMethod: locationMethod ?? this.locationMethod,
      locationAddress: locationAddress ?? this.locationAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      geofenceId: geofenceId ?? this.geofenceId,
      geofenceName: geofenceName ?? this.geofenceName,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      notificationMethods: notificationMethods ?? this.notificationMethods,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    vehicleId,
    vehicleNumber,
    locationMethod,
    locationAddress,
    latitude,
    longitude,
    radius,
    geofenceId,
    geofenceName,
    selectedDate,
    selectedTime,
    notificationMethods,
    status,
    createdAt,
    updatedAt,
  ];
}

/// Location method enum
enum LocationMethod { newLocation, existingGeofence }

/// Notification method enum
enum NotificationMethod { email, sms, push, web }

/// Geofence model for reachability
class ReachabilityGeofence extends Equatable {
  final String id;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final String shapeType;

  const ReachabilityGeofence({
    required this.id,
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.radius,
    this.shapeType = 'circle',
  });

  factory ReachabilityGeofence.fromJson(Map<String, dynamic> json) {
    return ReachabilityGeofence(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString(),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      radius: json['radius']?.toDouble(),
      shapeType: json['shape_type']?.toString() ?? 'circle',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'shape_type': shapeType,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    latitude,
    longitude,
    radius,
    shapeType,
  ];
}
