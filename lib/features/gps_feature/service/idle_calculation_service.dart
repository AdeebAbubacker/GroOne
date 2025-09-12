import 'package:gro_one_app/utils/custom_log.dart';

class IdleCalculationService {
  static const int IDLE_THRESHOLD_SECONDS = 60; // 60 seconds threshold for idle

  /// Determines if a vehicle is currently idle based on the requirements:
  /// - Ignition must be ON
  /// - Speed must be 0
  /// - Idle time must be > 60 seconds
  static bool isVehicleIdle({
    required String? ignition,
    required String? speed,
    required String? idleFixTime,
  }) {
    try {
      // Check if ignition is ON
      if (!_isIgnitionOn(ignition)) {
        return false;
      }

      // Check if speed is 0
      if (!_isSpeedZero(speed)) {
        return false;
      }

      // Check if idle time is greater than 60 seconds
      if (!_isIdleTimeGreaterThanThreshold(idleFixTime)) {
        return false;
      }

      return true;
    } catch (e) {
      CustomLog.error(
        IdleCalculationService,
        "Error calculating idle status",
        e,
      );
      return false;
    }
  }

  /// Calculates the idle duration from idleFixTime timestamp
  /// Returns duration in seconds
  static int calculateIdleDurationSeconds(String? idleFixTime) {
    if (idleFixTime == null || idleFixTime.isEmpty) {
      return 0;
    }

    try {
      final DateTime idleStartTime = DateTime.parse(idleFixTime);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(idleStartTime);

      // Return 0 if the time is in the future (invalid data)
      if (difference.isNegative) {
        return 0;
      }

      return difference.inSeconds;
    } catch (e) {
      CustomLog.error(
        IdleCalculationService,
        "Error parsing idleFixTime: $idleFixTime",
        e,
      );
      return 0;
    }
  }

  /// Formats idle duration in hours and minutes
  /// Returns formatted string like "2h 30m" or "45m" or "0m"
  static String formatIdleDuration(int idleSeconds) {
    if (idleSeconds <= 0) {
      return "0m";
    }

    final int hours = idleSeconds ~/ 3600;
    final int minutes = (idleSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m";
    } else {
      return "${minutes}m";
    }
  }

  /// Formats idle duration from idleFixTime timestamp
  static String formatIdleDurationFromTimestamp(String? idleFixTime) {
    final int idleSeconds = calculateIdleDurationSeconds(idleFixTime);
    return formatIdleDuration(idleSeconds);
  }

  /// Checks if ignition is ON
  static bool _isIgnitionOn(String? ignition) {
    if (ignition == null) return false;

    final String ignitionLower = ignition.toLowerCase().trim();
    return ignitionLower == 'on' ||
        ignitionLower == '1' ||
        ignitionLower == 'true' ||
        ignitionLower == 'yes' ||
        ignitionLower == 'running';
  }

  /// Checks if speed is 0
  static bool _isSpeedZero(String? speed) {
    if (speed == null) return false;

    final double? speedValue = double.tryParse(speed);
    return speedValue != null && speedValue == 0.0;
  }

  /// Checks if idle time is greater than the threshold (60 seconds)
  static bool _isIdleTimeGreaterThanThreshold(String? idleFixTime) {
    final int idleSeconds = calculateIdleDurationSeconds(idleFixTime);
    return idleSeconds > IDLE_THRESHOLD_SECONDS;
  }

  /// Gets the idle status text for display
  static String getIdleStatusText({
    required String? ignition,
    required String? speed,
    required String? idleFixTime,
  }) {
    if (isVehicleIdle(
      ignition: ignition,
      speed: speed,
      idleFixTime: idleFixTime,
    )) {
      final String duration = formatIdleDurationFromTimestamp(idleFixTime);
      return "Idle ($duration)";
    } else {
      return "Not Idle";
    }
  }

  /// Gets the idle count (number of idle events)
  /// For now, we consider any idle period > 60 seconds as 1 idle event
  static int getIdleCount({
    required String? ignition,
    required String? speed,
    required String? idleFixTime,
  }) {
    if (isVehicleIdle(
      ignition: ignition,
      speed: speed,
      idleFixTime: idleFixTime,
    )) {
      return 1;
    }
    return 0;
  }
}
