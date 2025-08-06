import 'package:flutter/material.dart';

/// Helper class to manage vehicle icons based on vehicle type and status
/// This is based on the native Android app's GetMarkerIcon.java logic
class VehicleIconHelper {
  // Vehicle types (matching MyConstants.kt from native app)
  static const int VEHICLE_CAR = 0;
  static const int VEHICLE_TRUCK = 1;
  static const int VEHICLE_BIKE = 2;
  static const int PERSONAL = 3;
  static const int TRAIN = 4;
  static const int BUS = 5;
  static const int E_RICKSHAW = 6;
  static const int AMBULANCE = 7;
  static const int TANKER = 8;
  static const int TRACTOR = 10;
  static const int CRANE = 11;

  // Device states (matching MyConstants.kt from native app)
  static const int DEVICE_STATE_ON = 11;
  static const int DEVICE_STATE_OFF = 7;
  static const int DEVICE_STATE_IDLE = 5;
  static const int DEVICE_STATE_OFFLINE = 0;

  // Color codes for different states
  static const Color ONLINE_COLOR = Color(0xFF0FAF84); // Green
  static const Color OFFLINE_COLOR = Color(0xFFF93537); // Red
  static const Color IDLE_COLOR = Color(0xFFC9AC00); // Orange/Yellow
  static const Color INACTIVE_COLOR = Color(0xFFA9A9A9); // Gray

  /// Get vehicle type from category string
  static int getVehicleType(String? category) {
    if (category == null) return VEHICLE_CAR;

    switch (category.toLowerCase()) {
      case "car":
        return VEHICLE_CAR;
      case "truck":
        return VEHICLE_TRUCK;
      case "bike":
        return VEHICLE_BIKE;
      case "personal":
        return PERSONAL;
      case "bus":
        return BUS;
      case "erickshaw":
        return E_RICKSHAW;
      case "subway":
        return TRAIN;
      case "ambulance":
        return AMBULANCE;
      case "tanker":
        return TANKER;
      case "tractor":
        return TRACTOR;
      case "steam":
        return CRANE;
      default:
        return VEHICLE_CAR;
    }
  }

  /// Get device state from status string
  static int getDeviceState(String? status) {
    if (status == null) return DEVICE_STATE_OFFLINE;

    final statusLower = status.toLowerCase();

    if (statusLower.contains('on') ||
        statusLower.contains('active') ||
        statusLower.contains('running') ||
        statusLower == 'ignition_on') {
      return DEVICE_STATE_ON;
    } else if (statusLower.contains('off') ||
        statusLower.contains('inactive') ||
        statusLower.contains('stopped') ||
        statusLower == 'ignition_off') {
      return DEVICE_STATE_OFF;
    } else if (statusLower.contains('idle') || statusLower.contains('parked')) {
      return DEVICE_STATE_IDLE;
    } else {
      return DEVICE_STATE_OFFLINE;
    }
  }

  /// Get vehicle icon asset path based on vehicle type and device state
  static String getVehicleIconAsset(int vehicleType, int deviceState) {
    String baseIcon = _getBaseIconForVehicleType(vehicleType);
    String stateSuffix = _getStateSuffix(deviceState);

    return 'assets/icons/vehicle_icons/$baseIcon$stateSuffix.xml';
  }

  /// Get base icon name for vehicle type
  static String _getBaseIconForVehicleType(int vehicleType) {
    switch (vehicleType) {
      case VEHICLE_TRUCK:
        return 'ic_truck_new';
      case VEHICLE_BIKE:
        return 'ic_bike';
      case PERSONAL:
        return 'ic_marker';
      case BUS:
        return 'ic_school_bus';
      case TRAIN:
        return 'ic_train';
      case E_RICKSHAW:
        return 'ic_erickshaw';
      case AMBULANCE:
        return 'ic_ambulance';
      case TANKER:
        return 'ic_tanker';
      case TRACTOR:
        return 'ic_tractor';
      case CRANE:
        return 'ic_crane';
      case VEHICLE_CAR:
      default:
        return 'ic_car';
    }
  }

  /// Get state suffix for icon filename
  static String _getStateSuffix(int deviceState) {
    switch (deviceState) {
      case DEVICE_STATE_ON:
        return ''; // Default green color
      case DEVICE_STATE_OFF:
        return '_off';
      case DEVICE_STATE_IDLE:
        return '_idle';
      case DEVICE_STATE_OFFLINE:
      default:
        return '_inactive';
    }
  }

  /// Get color for vehicle state
  static Color getVehicleStateColor(int deviceState) {
    switch (deviceState) {
      case DEVICE_STATE_ON:
        return ONLINE_COLOR;
      case DEVICE_STATE_OFF:
        return OFFLINE_COLOR;
      case DEVICE_STATE_IDLE:
        return IDLE_COLOR;
      case DEVICE_STATE_OFFLINE:
      default:
        return INACTIVE_COLOR;
    }
  }

  /// Check if vehicle is expired (24 hours without update)
  static bool isVehicleExpired(DateTime? lastUpdate) {
    if (lastUpdate == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastUpdate);
    return difference.inHours >= 24;
  }

  /// Get vehicle icon with proper state handling
  static String getVehicleIconWithState({
    required String? vehicleCategory,
    required String? status,
    required DateTime? lastUpdate,
    bool isExpired = false,
  }) {
    final vehicleType = getVehicleType(vehicleCategory);
    final deviceState = getDeviceState(status);

    // If vehicle is expired, use expired icon
    if (isExpired || isVehicleExpired(lastUpdate)) {
      return _getExpiredIconForVehicleType(vehicleType);
    }

    return getVehicleIconAsset(vehicleType, deviceState);
  }

  /// Get expired icon for vehicle type
  static String _getExpiredIconForVehicleType(int vehicleType) {
    switch (vehicleType) {
      case VEHICLE_TRUCK:
        return 'assets/icons/vehicle_icons/ic_truck_expired.xml';
      case VEHICLE_BIKE:
        return 'assets/icons/vehicle_icons/ic_bike_expired.xml';
      case PERSONAL:
        return 'assets/icons/vehicle_icons/ic_personal_expired.xml';
      case VEHICLE_CAR:
      default:
        return 'assets/icons/vehicle_icons/ic_car_expired.xml';
    }
  }

  /// Get vehicle status text
  static String getVehicleStatusText(String? status) {
    if (status == null) return 'Offline';

    final statusLower = status.toLowerCase();

    if (statusLower.contains('on') ||
        statusLower.contains('active') ||
        statusLower.contains('running')) {
      return 'Online';
    } else if (statusLower.contains('off') ||
        statusLower.contains('inactive') ||
        statusLower.contains('stopped')) {
      return 'Offline';
    } else if (statusLower.contains('idle') || statusLower.contains('parked')) {
      return 'Idle';
    } else {
      return 'Unknown';
    }
  }

  /// Get vehicle type display name
  static String getVehicleTypeDisplayName(int vehicleType) {
    switch (vehicleType) {
      case VEHICLE_CAR:
        return 'Car';
      case VEHICLE_TRUCK:
        return 'Truck';
      case VEHICLE_BIKE:
        return 'Bike';
      case PERSONAL:
        return 'Personal';
      case BUS:
        return 'Bus';
      case TRAIN:
        return 'Train';
      case E_RICKSHAW:
        return 'E-Rickshaw';
      case AMBULANCE:
        return 'Ambulance';
      case TANKER:
        return 'Tanker';
      case TRACTOR:
        return 'Tractor';
      case CRANE:
        return 'Crane';
      default:
        return 'Vehicle';
    }
  }
}
