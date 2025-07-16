class GpsNotificationModel {
  final int id;
  final int deviceId;
  final String? geofenceName;
  final double latitude;
  final double longitude;
  final String type;
  final DateTime fixTime;
  final DateTime serverTime;
  final double speed;
  final double speedLimit;
  final Map<String, dynamic> attributes;

  GpsNotificationModel({
    required this.id,
    required this.deviceId,
    required this.geofenceName,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.fixTime,
    required this.serverTime,
    required this.speed,
    required this.speedLimit,
    required this.attributes,
  });

  factory GpsNotificationModel.fromJson(Map<String, dynamic> json) {
    return GpsNotificationModel(
      id: json['id'] ?? 0,
      deviceId: json['deviceid'] ?? 0,
      geofenceName: json['geofencename'] ?? "Unknown",
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      type: json['type'] ?? "Unknown",
      fixTime: DateTime.fromMillisecondsSinceEpoch(json['fixtime'] ?? 0),
      serverTime: DateTime.fromMillisecondsSinceEpoch(json['servertime'] ?? 0),
      speed: json['attributes']?['speed']?.toDouble() ?? 0,
      speedLimit: json['attributes']?['speedLimit']?.toDouble() ?? 0,
      attributes: json['attributes'] ?? {},
    );
  }
}

extension NotificationTypeMapper on GpsNotificationModel {
  String get filterKey {
    if (type == "ignitionOn") return "Ignition ON";
    if (type == "ignitionOff") return "Ignition OFF";
    if (type == "deviceOverspeed") return "Device Over-speed";
    if (type == "alarm") {
      final alarm = attributes['alarm'];
      if (alarm == "powerCut") return "Power-Cut";
      if (alarm == "powerRestored") return "Power-Cut"; // mapped same as powerCut
      if (alarm == "vibration") return "Vibration";
      if (alarm == "lowBattery") return "Low Battery";
      if (alarm == "geofenceEnter") return "Geo-fence Enter";
      if (alarm == "geofenceExit") return "Geo-fence Exit";
      if (alarm == "overSpeed") return "Device Over-speed";
      if (alarm == "hardBraking") return "Other";
    }
    return "Other";
  }
}

