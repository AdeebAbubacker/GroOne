class GpsInfoWindowDetails {
  final double? averageSpeedKph;
  final double? cacheDistance;
  final double? currentTripDistance;
  final int? currentTripEndTime;
  final int? currentTripStartTime;
  final String? dontUse;
  final int? engineSecondsViaIgnition;
  final int? engine2Seconds;
  final int? engine2Time;
  final int? idleSeconds;
  final int? ignitionSeconds;
  final bool? isStopped;
  final double? lastTripDistance;
  final int? lastTripEndTime;
  final int? lastTripStartTime;
  final double? maxSpeedKph;
  final int? motionSeconds;
  final bool? pastDataReceived;
  final int? stoppedSince;
  final int? stopsCount;
  final int? tripsCount;

  GpsInfoWindowDetails({
    this.averageSpeedKph,
    this.cacheDistance,
    this.currentTripDistance,
    this.currentTripEndTime,
    this.currentTripStartTime,
    this.dontUse,
    this.engineSecondsViaIgnition,
    this.engine2Seconds,
    this.engine2Time,
    this.idleSeconds,
    this.ignitionSeconds,
    this.isStopped,
    this.lastTripDistance,
    this.lastTripEndTime,
    this.lastTripStartTime,
    this.maxSpeedKph,
    this.motionSeconds,
    this.pastDataReceived,
    this.stoppedSince,
    this.stopsCount,
    this.tripsCount,
  });

  factory GpsInfoWindowDetails.fromJson(Map<String, dynamic> json) {
    return GpsInfoWindowDetails(
      averageSpeedKph: _parseDouble(json['averageSpeedKph']),
      cacheDistance: _parseDouble(json['cacheDistance']),
      currentTripDistance: _parseDouble(json['currentTripDistance']),
      currentTripEndTime: _parseInt(json['currentTripEndTime']),
      currentTripStartTime: _parseInt(json['currentTripStartTime']),
      dontUse: json['dontUse']?.toString(),
      engineSecondsViaIgnition: _parseInt(json['engineSecondsViaIgnition']),
      engine2Seconds: _parseInt(json['engine_2_seconds']),
      engine2Time: _parseInt(json['engine_2_time']),
      idleSeconds: _parseInt(json['idleSeconds']),
      ignitionSeconds: _parseInt(json['ignitionSeconds']),
      isStopped: _parseBool(json['isStopped']),
      lastTripDistance: _parseDouble(json['lastTripDistance']),
      lastTripEndTime: _parseInt(json['lastTripEndTime']),
      lastTripStartTime: _parseInt(json['lastTripStartTime']),
      maxSpeedKph: _parseDouble(json['maxSpeedKph']),
      motionSeconds: _parseInt(json['motionSeconds']),
      pastDataReceived: _parseBool(json['pastDataReceived']),
      stoppedSince: _parseInt(json['stoppedSince']),
      stopsCount: _parseInt(json['stopsCount']),
      tripsCount: _parseInt(json['tripsCount']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed;
    }
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed;
    }
    return null;
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == '1' || lower == 'yes';
    }
    if (value is int) return value > 0;
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'averageSpeedKph': averageSpeedKph,
      'cacheDistance': cacheDistance,
      'currentTripDistance': currentTripDistance,
      'currentTripEndTime': currentTripEndTime,
      'currentTripStartTime': currentTripStartTime,
      'dontUse': dontUse,
      'engineSecondsViaIgnition': engineSecondsViaIgnition,
      'engine_2_seconds': engine2Seconds,
      'engine_2_time': engine2Time,
      'idleSeconds': idleSeconds,
      'ignitionSeconds': ignitionSeconds,
      'isStopped': isStopped,
      'lastTripDistance': lastTripDistance,
      'lastTripEndTime': lastTripEndTime,
      'lastTripStartTime': lastTripStartTime,
      'maxSpeedKph': maxSpeedKph,
      'motionSeconds': motionSeconds,
      'pastDataReceived': pastDataReceived,
      'stoppedSince': stoppedSince,
      'stopsCount': stopsCount,
      'tripsCount': tripsCount,
    };
  }

  @override
  String toString() {
    return 'GpsInfoWindowDetails(averageSpeedKph: $averageSpeedKph, cacheDistance: $cacheDistance, currentTripDistance: $currentTripDistance, currentTripEndTime: $currentTripEndTime, currentTripStartTime: $currentTripStartTime, dontUse: $dontUse, engineSecondsViaIgnition: $engineSecondsViaIgnition, engine2Seconds: $engine2Seconds, engine2Time: $engine2Time, idleSeconds: $idleSeconds, ignitionSeconds: $ignitionSeconds, isStopped: $isStopped, lastTripDistance: $lastTripDistance, lastTripEndTime: $lastTripEndTime, lastTripStartTime: $lastTripStartTime, maxSpeedKph: $maxSpeedKph, motionSeconds: $motionSeconds, pastDataReceived: $pastDataReceived, stoppedSince: $stoppedSince, stopsCount: $stopsCount, tripsCount: $tripsCount)';
  }
}
