import 'dart:convert'; // Added for jsonDecode

import '../model/gps_devices_expiry_model.dart';
import '../model/gps_devices_positions_model.dart';

class GpsCombinedVehicleData {
  final int? deviceId;
  final String? vehicleNumber;
  final String? status;
  final String? statusDuration;
  final String? location;
  final int? networkSignal;
  final bool? hasGPS;
  final String? odoReading;
  final String? todayDistance;
  final String? lastSpeed;
  final DateTime? lastUpdate;
  final bool? isExpiringSoon;
  final GpsPositionCounts? apiCounts;
  final String? batteryPercent;
  final String? idleTime;
  final String? address;

  // Additional fields from position data
  final String? category;
  final String? course;
  final bool? expired;
  final String? externalId;
  final int? filterStatus;
  final String? idleFixTimeKey;
  final String? ignition;
  final String? lastRenewalDate;
  final String? posAttr;
  final String? prevOdometer;
  final String? protocol;
  final String? subscriptionExpiryDate;
  final String? totalDistance;
  final String? tripName;
  final String? uniqueId;
  final String? valid;
  final String? alarm;
  final String? deviceStatus;
  final String? fixTime;
  final String? geofenceIds;
  final String? harshAccelerations;
  final String? harshBrakings;
  final String? harshCornerings;
  final String? idleFixTime;
  final String? lastIgnitionOffFixTime;
  final String? lastIgnitionOnFixTime;
  final String? latitude;
  final String? longitude;
  final String? network;
  final String? overSpeeds;
  final String? pushedtoServer;
  final String? serverTime;
  final String? tmp;
  final double? battery;
  final double? extBatt;
  final int? rssi;
  final int? sat;
  final int? odometer;
  final double? distance;
  final bool? motion;
  final int? event;
  final int? workMode;
  final int? io68;
  final int? operatorCode;
  final int? hours;

  // Additional fields from expiry data
  final String? contact;
  final String? dateAdded;
  final int? disabled;
  final int? groupId;
  final String? lastUpdateRfc3339;
  final String? model;
  final String? phone;
  final int? positionId;
  final int? statusCode;
  final GpsDeviceAttributes? attributes;

  GpsCombinedVehicleData({
    this.deviceId,
    this.vehicleNumber,
    this.status,
    this.statusDuration,
    this.location,
    this.networkSignal,
    this.hasGPS,
    this.odoReading,
    this.todayDistance,
    this.lastSpeed,
    this.lastUpdate,
    this.isExpiringSoon,
    this.apiCounts,
    this.batteryPercent,
    this.idleTime,
    this.address,
    this.category,
    this.course,
    this.expired,
    this.externalId,
    this.filterStatus,
    this.idleFixTimeKey,
    this.ignition,
    this.lastRenewalDate,
    this.posAttr,
    this.prevOdometer,
    this.protocol,
    this.subscriptionExpiryDate,
    this.totalDistance,
    this.tripName,
    this.uniqueId,
    this.valid,
    this.alarm,
    this.deviceStatus,
    this.fixTime,
    this.geofenceIds,
    this.harshAccelerations,
    this.harshBrakings,
    this.harshCornerings,
    this.idleFixTime,
    this.lastIgnitionOffFixTime,
    this.lastIgnitionOnFixTime,
    this.latitude,
    this.longitude,
    this.network,
    this.overSpeeds,
    this.pushedtoServer,
    this.serverTime,
    this.tmp,
    this.battery,
    this.extBatt,
    this.rssi,
    this.sat,
    this.odometer,
    this.distance,
    this.motion,
    this.event,
    this.workMode,
    this.io68,
    this.operatorCode,
    this.hours,
    this.contact,
    this.dateAdded,
    this.disabled,
    this.groupId,
    this.lastUpdateRfc3339,
    this.model,
    this.phone,
    this.positionId,
    this.statusCode,
    this.attributes,
  });

  GpsCombinedVehicleData copyWith({
    int? deviceId,
    String? vehicleNumber,
    String? status,
    String? statusDuration,
    String? location,
    int? networkSignal,
    bool? hasGPS,
    String? odoReading,
    String? todayDistance,
    String? lastSpeed,
    DateTime? lastUpdate,
    bool? isExpiringSoon,
    GpsPositionCounts? apiCounts,
    String? batteryPercent,
    String? idleTime,
    String? address,
    String? category,
    String? course,
    bool? expired,
    String? externalId,
    int? filterStatus,
    String? idleFixTimeKey,
    String? ignition,
    String? lastRenewalDate,
    String? posAttr,
    String? prevOdometer,
    String? protocol,
    String? subscriptionExpiryDate,
    String? totalDistance,
    String? tripName,
    String? uniqueId,
    String? valid,
    String? alarm,
    String? deviceStatus,
    String? fixTime,
    String? geofenceIds,
    String? harshAccelerations,
    String? harshBrakings,
    String? harshCornerings,
    String? idleFixTime,
    String? lastIgnitionOffFixTime,
    String? lastIgnitionOnFixTime,
    String? latitude,
    String? longitude,
    String? network,
    String? overSpeeds,
    String? pushedtoServer,
    String? serverTime,
    String? tmp,
    double? battery,
    double? extBatt,
    int? rssi,
    int? sat,
    int? odometer,
    double? distance,
    bool? motion,
    int? event,
    int? workMode,
    int? io68,
    int? operatorCode,
    int? hours,
    String? contact,
    String? dateAdded,
    int? disabled,
    int? groupId,
    String? lastUpdateRfc3339,
    String? model,
    String? phone,
    int? positionId,
    int? statusCode,
    GpsDeviceAttributes? attributes,
  }) {
    return GpsCombinedVehicleData(
      deviceId: deviceId ?? this.deviceId,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      status: status ?? this.status,
      statusDuration: statusDuration ?? this.statusDuration,
      location: location ?? this.location,
      networkSignal: networkSignal ?? this.networkSignal,
      hasGPS: hasGPS ?? this.hasGPS,
      odoReading: odoReading ?? this.odoReading,
      todayDistance: todayDistance ?? this.todayDistance,
      lastSpeed: lastSpeed ?? this.lastSpeed,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isExpiringSoon: isExpiringSoon ?? this.isExpiringSoon,
      apiCounts: apiCounts ?? this.apiCounts,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      idleTime: idleTime ?? this.idleTime,
      address: address ?? this.address,
      category: category ?? this.category,
      course: course ?? this.course,
      expired: expired ?? this.expired,
      externalId: externalId ?? this.externalId,
      filterStatus: filterStatus ?? this.filterStatus,
      idleFixTimeKey: idleFixTimeKey ?? this.idleFixTimeKey,
      ignition: ignition ?? this.ignition,
      lastRenewalDate: lastRenewalDate ?? this.lastRenewalDate,
      posAttr: posAttr ?? this.posAttr,
      prevOdometer: prevOdometer ?? this.prevOdometer,
      protocol: protocol ?? this.protocol,
      subscriptionExpiryDate:
          subscriptionExpiryDate ?? this.subscriptionExpiryDate,
      totalDistance: totalDistance ?? this.totalDistance,
      tripName: tripName ?? this.tripName,
      uniqueId: uniqueId ?? this.uniqueId,
      valid: valid ?? this.valid,
      alarm: alarm ?? this.alarm,
      deviceStatus: deviceStatus ?? this.deviceStatus,
      fixTime: fixTime ?? this.fixTime,
      geofenceIds: geofenceIds ?? this.geofenceIds,
      harshAccelerations: harshAccelerations ?? this.harshAccelerations,
      harshBrakings: harshBrakings ?? this.harshBrakings,
      harshCornerings: harshCornerings ?? this.harshCornerings,
      idleFixTime: idleFixTime ?? this.idleFixTime,
      lastIgnitionOffFixTime:
          lastIgnitionOffFixTime ?? this.lastIgnitionOffFixTime,
      lastIgnitionOnFixTime:
          lastIgnitionOnFixTime ?? this.lastIgnitionOnFixTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      network: network ?? this.network,
      overSpeeds: overSpeeds ?? this.overSpeeds,
      pushedtoServer: pushedtoServer ?? this.pushedtoServer,
      serverTime: serverTime ?? this.serverTime,
      tmp: tmp ?? this.tmp,
      battery: battery ?? this.battery,
      extBatt: extBatt ?? this.extBatt,
      rssi: rssi ?? this.rssi,
      sat: sat ?? this.sat,
      odometer: odometer ?? this.odometer,
      distance: distance ?? this.distance,
      motion: motion ?? this.motion,
      event: event ?? this.event,
      workMode: workMode ?? this.workMode,
      io68: io68 ?? this.io68,
      operatorCode: operatorCode ?? this.operatorCode,
      hours: hours ?? this.hours,
      contact: contact ?? this.contact,
      dateAdded: dateAdded ?? this.dateAdded,
      disabled: disabled ?? this.disabled,
      groupId: groupId ?? this.groupId,
      lastUpdateRfc3339: lastUpdateRfc3339 ?? this.lastUpdateRfc3339,
      model: model ?? this.model,
      phone: phone ?? this.phone,
      positionId: positionId ?? this.positionId,
      statusCode: statusCode ?? this.statusCode,
      attributes: this.attributes,
    );
  }

  factory GpsCombinedVehicleData.fromExpiryAndPosition({
    required GpsDeviceExpiryData expiryData,
    required GpsDevicePositionData? positionData,
    GpsPositionCounts? apiCounts,
  }) {
    final posAttrMap = _parsePosAttr(positionData?.posAttr);
    return GpsCombinedVehicleData(
      deviceId: expiryData.id,
      vehicleNumber: expiryData.name,
      status: _determineStatus(expiryData, positionData),
      statusDuration: _calculateStatusDuration(expiryData.lastUpdate),
      location: _getLocation(positionData),
      networkSignal: _calculateNetworkSignal(positionData?.network),
      hasGPS: positionData?.gpsStatus ?? false,
      odoReading: _getOdoReading(positionData),
      todayDistance: _getTodayDistance(positionData),
      lastSpeed: positionData?.speed ?? '-',
      lastUpdate:
          _parseLastUpdate(expiryData.lastUpdate) ??
          _parseLastUpdateString(positionData?.lastUpdate),
      isExpiringSoon: _checkIfExpiringSoon(expiryData.subscriptionExpiryDate),
      apiCounts: apiCounts,
      batteryPercent: _extractBatteryPercent(positionData?.posAttr),
      idleTime: positionData?.idleFixTime,
      address: _getAddressFromLocation(positionData),

      // Position data fields
      category: positionData?.category,
      course: positionData?.course,
      expired: positionData?.expired,
      externalId: positionData?.externalId,
      filterStatus: positionData?.filterStatus,
      idleFixTimeKey: positionData?.idleFixTimeKey,
      ignition: positionData?.ignition,
      lastRenewalDate: positionData?.lastRenewalDate,
      posAttr: positionData?.posAttr,
      prevOdometer: positionData?.prevOdometer,
      protocol: positionData?.protocol,
      subscriptionExpiryDate: positionData?.subscriptionExpiryDate,
      totalDistance: positionData?.totalDistance,
      tripName: positionData?.tripName,
      uniqueId: positionData?.uniqueId,
      valid: positionData?.valid,
      alarm: positionData?.alarm,
      deviceStatus: positionData?.deviceStatus,
      fixTime: positionData?.fixTime,
      geofenceIds: positionData?.geofenceIds,
      harshAccelerations: positionData?.harshAccelerations,
      harshBrakings: positionData?.harshBrakings,
      harshCornerings: positionData?.harshCornerings,
      idleFixTime: positionData?.idleFixTime,
      lastIgnitionOffFixTime: positionData?.lastIgnitionOffFixTime,
      lastIgnitionOnFixTime: positionData?.lastIgnitionOnFixTime,
      latitude: positionData?.latitude,
      longitude: positionData?.longitude,
      network: positionData?.network,
      overSpeeds: positionData?.overSpeeds,
      pushedtoServer: positionData?.pushedtoServer,
      serverTime: positionData?.serverTime,
      tmp: positionData?.tmp,
      battery: _parseDouble(posAttrMap['battery']),
      extBatt: _parseDouble(posAttrMap['extBatt']),
      rssi: _parseInt(posAttrMap['rssi']),
      sat: _parseInt(posAttrMap['sat']),
      odometer: _parseInt(posAttrMap['odometer']),
      distance: _parseDouble(posAttrMap['distance']),
      motion:
          posAttrMap['motion'] is bool
              ? posAttrMap['motion']
              : (posAttrMap['motion']?.toString() == '1'),
      event: _parseInt(posAttrMap['event']),
      workMode: _parseInt(posAttrMap['workMode']),
      io68: _parseInt(posAttrMap['io68']),
      operatorCode: _parseInt(posAttrMap['operator']),
      hours: _parseInt(posAttrMap['hours']),

      // Expiry data fields
      contact: expiryData.contact,
      dateAdded: expiryData.dateAdded,
      disabled: expiryData.disabled,
      groupId: expiryData.groupId,
      lastUpdateRfc3339: expiryData.lastUpdateRfc3339,
      model: expiryData.model,
      phone: expiryData.phone,
      positionId: expiryData.positionId,
      statusCode: expiryData.status,
      attributes: expiryData.attributes,
    );
  }

  static String _determineStatus(
    GpsDeviceExpiryData expiryData,
    GpsDevicePositionData? positionData,
  ) {
    // Priority: ignition field > status field > position valid > expiry status

    // Check ignition field first
    if (positionData?.ignition != null) {
      final ignition = positionData!.ignition!.toLowerCase().trim();

      // Handle various ignition field values
      if (ignition == "on" ||
          ignition == "1" ||
          ignition == "true" ||
          ignition == "yes" ||
          ignition == "running") {
        return 'IGNITION_ON';
      } else if (ignition == "off" ||
          ignition == "0" ||
          ignition == "false" ||
          ignition == "no" ||
          ignition == "stopped") {
        return 'IGNITION_OFF';
      }
    }

    // Check status field from position data
    if (positionData?.status != null) {
      final status = positionData!.status!;

      // Map status values to our categories
      if (status == 1) {
        return 'IGNITION_ON';
      } else if (status == 0) {
        return 'IGNITION_OFF';
      }
    }

    // Check position valid field
    if (positionData?.valid == "1") {
      return 'IDLE';
    }

    // Check expiry status
    if (expiryData.status == 0) {
      return 'IGNITION_OFF';
    }

    // Default to inactive
    return 'INACTIVE';
  }

  static String _calculateStatusDuration(int? lastUpdate) {
    if (lastUpdate == null) return 'Unknown';

    final now = DateTime.now();
    final lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(lastUpdate);
    final difference = now.difference(lastUpdateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  static String _getLocation(GpsDevicePositionData? positionData) {
    if (positionData?.latitude != null && positionData?.longitude != null) {
      return '${positionData!.latitude!}, ${positionData.longitude!}';
    }
    return 'Location not available';
  }

  static int _calculateNetworkSignal(String? network) {
    if (network == null) return 0;

    switch (network.toLowerCase()) {
      case 'on':
        return 5;
      case 'good':
        return 4;
      case 'fair':
        return 3;
      case 'poor':
        return 2;
      case 'very poor':
        return 1;
      default:
        return 0;
    }
  }

  static String _getOdoReading(GpsDevicePositionData? positionData) {
    if (positionData?.totalDistance != null) {
      final distance = double.tryParse(positionData!.totalDistance!);
      if (distance != null) {
        return '${(distance / 1000).toStringAsFixed(1)} km';
      }
    }
    return '0 km';
  }

  static String _getTodayDistance(GpsDevicePositionData? positionData) {
    if (positionData?.distance != null) {
      final distance = double.tryParse(positionData!.distance!);
      if (distance != null) {
        return '${distance.toStringAsFixed(1)} km';
      }
    }
    return '0 km';
  }

  static DateTime? _parseLastUpdate(int? lastUpdate) {
    if (lastUpdate == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(lastUpdate);
  }

  static DateTime? _parseLastUpdateString(String? lastUpdate) {
    if (lastUpdate == null) return null;
    // Try to parse as ISO8601 or timestamp string
    try {
      return DateTime.parse(lastUpdate);
    } catch (_) {
      return null;
    }
  }

  static bool _checkIfExpiringSoon(String? expiryDate) {
    if (expiryDate == null) return false;

    try {
      final expiry = DateTime.parse(expiryDate);
      final now = DateTime.now();
      final difference = expiry.difference(now);

      return difference.inDays <= 30 && difference.inDays >= 0;
    } catch (e) {
      return false;
    }
  }

  static String? _getAddressFromLocation(GpsDevicePositionData? positionData) {
    if (positionData?.latitude != null && positionData?.longitude != null) {
      // Return null initially - the address will be fetched asynchronously
      // and stored in the realm when available
      return null;
    }
    return null;
  }

  static String? _extractBatteryPercent(String? posAttr) {
    if (posAttr == null || posAttr.isEmpty) return null;

    // Try to extract battery percentage from posAttr
    // This might contain battery info in various formats
    try {
      // If it's a simple number, assume it's battery percentage
      final battery = double.tryParse(posAttr);
      if (battery != null && battery >= 0 && battery <= 100) {
        return battery.toInt().toString();
      }

      // If it contains battery information in a specific format
      if (posAttr.toLowerCase().contains('battery') ||
          posAttr.toLowerCase().contains('batt')) {
        // Extract number from string like "battery: 85" or "batt: 90%"
        final regex = RegExp(r'(\d+)');
        final match = regex.firstMatch(posAttr);
        if (match != null) {
          final value = int.tryParse(match.group(1)!);
          if (value != null && value >= 0 && value <= 100) {
            return value.toString();
          }
        }
      }

      // Try to parse as JSON and extract battery info
      try {
        final jsonMap = jsonDecode(posAttr) as Map<String, dynamic>;
        if (jsonMap.containsKey('battery')) {
          final batteryValue = jsonMap['battery'];
          if (batteryValue != null) {
            final batteryNum = double.tryParse(batteryValue.toString());
            if (batteryNum != null && batteryNum >= 0 && batteryNum <= 100) {
              return batteryNum.toInt().toString();
            }
          }
        }
      } catch (e) {
        // JSON parsing failed, continue with other methods
      }
    } catch (e) {
      // If parsing fails, return the original value
    }

    return posAttr;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static Map<String, dynamic> _parsePosAttr(String? posAttr) {
    if (posAttr == null || posAttr.isEmpty) return {};
    try {
      // Try to parse as JSON
      final decoded = jsonDecode(posAttr);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {};
    } catch (e) {
      // If JSON parsing fails, try to extract key-value pairs from string
      try {
        final Map<String, dynamic> result = {};
        // Handle simple key=value format
        final pairs = posAttr.split(',');
        for (final pair in pairs) {
          final keyValue = pair.split('=');
          if (keyValue.length == 2) {
            final key = keyValue[0].trim();
            final value = keyValue[1].trim();
            // Try to parse value as number if possible
            final numValue = double.tryParse(value);
            result[key] = numValue ?? value;
          }
        }
        return result;
      } catch (e2) {
        return {};
      }
    }
  }
}

/// Extension for filtering GPS vehicle lists based on expiry status
extension GpsVehicleListExtensions on List<GpsCombinedVehicleData> {
  /// Returns all vehicles including expired ones
  List<GpsCombinedVehicleData> get withExpired => this;

  /// Returns only vehicles that are not expired
  /// A vehicle is considered expired if expired == true or expired == null
  List<GpsCombinedVehicleData> get withoutExpired {
    return where((vehicle) {
      // Consider null as expired (default behavior)
      return vehicle.expired == false;
    }).toList();
  }

  /// Returns only expired vehicles
  /// A vehicle is considered expired if expired == true or expired == null
  List<GpsCombinedVehicleData> get onlyExpired {
    return where((vehicle) {
      return vehicle.expired == true || vehicle.expired == null;
    }).toList();
  }

  /// Returns vehicles that are expiring soon (isExpiringSoon == true)
  List<GpsCombinedVehicleData> get expiringSoon {
    return where((vehicle) {
      return vehicle.isExpiringSoon == true;
    }).toList();
  }

  /// Returns vehicles that are not expiring soon
  List<GpsCombinedVehicleData> get notExpiringSoon {
    return where((vehicle) {
      return vehicle.isExpiringSoon != true;
    }).toList();
  }
}
