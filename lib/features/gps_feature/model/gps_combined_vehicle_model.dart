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
    );
  }

  factory GpsCombinedVehicleData.fromExpiryAndPosition({
    required GpsDeviceExpiryData expiryData,
    required GpsDevicePositionData? positionData,
    GpsPositionCounts? apiCounts,
  }) {
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
      batteryPercent:
          positionData
              ?.posAttr, // If battery percent is in posAttr or another field, map it here
      idleTime:
          positionData
              ?.idleFixTime, // If idle time is in idleFixTime or another field, map it here
      address: _getAddressFromLocation(positionData),
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
}
