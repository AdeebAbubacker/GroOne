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
  });

  factory GpsCombinedVehicleData.fromExpiryAndPosition({
    required GpsDeviceExpiryData expiryData,
    required GpsDevicePositionData? positionData,
  }) {
    return GpsCombinedVehicleData(
      deviceId: expiryData.id,
      vehicleNumber: expiryData.name,
      status: _determineStatus(expiryData.status, positionData?.valid),
      statusDuration: _calculateStatusDuration(expiryData.lastUpdate),
      location: _getLocation(positionData),
      networkSignal: _calculateNetworkSignal(positionData?.network),
      hasGPS: positionData?.gpsStatus ?? false,
      odoReading: _getOdoReading(positionData),
      todayDistance: _getTodayDistance(positionData),
      lastSpeed: positionData?.speed ?? '0 km/h',
      lastUpdate: _parseLastUpdate(expiryData.lastUpdate),
      isExpiringSoon: _checkIfExpiringSoon(expiryData.subscriptionExpiryDate),
    );
  }

  static String _determineStatus(int? expiryStatus, String? positionValid) {
    if (positionValid == "1") {
      return 'idle';
    } else if (expiryStatus == 0) {
      return 'off';
    } else {
      return 'inactive';
    }
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

  static bool _checkIfExpiringSoon(String? expiryDate) {
    if (expiryDate == null) return false;

    try {
      final expiry = DateTime.parse(expiryDate);
      final now = DateTime.now();
      final difference = expiry.difference(now);

      // Consider expiring soon if within 30 days
      return difference.inDays <= 30 && difference.inDays >= 0;
    } catch (e) {
      return false;
    }
  }
}
