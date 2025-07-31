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
      averageSpeedKph: json['averageSpeedKph']?.toDouble(),
      cacheDistance: json['cacheDistance']?.toDouble(),
      currentTripDistance: json['currentTripDistance']?.toDouble(),
      currentTripEndTime: json['currentTripEndTime'],
      currentTripStartTime: json['currentTripStartTime'],
      dontUse: json['dontUse'],
      engineSecondsViaIgnition: json['engineSecondsViaIgnition'],
      engine2Seconds: json['engine_2_seconds'],
      engine2Time: json['engine_2_time'],
      idleSeconds: json['idleSeconds'],
      ignitionSeconds: json['ignitionSeconds'],
      isStopped: json['isStopped'],
      lastTripDistance: json['lastTripDistance']?.toDouble(),
      lastTripEndTime: json['lastTripEndTime'],
      lastTripStartTime: json['lastTripStartTime'],
      maxSpeedKph: json['maxSpeedKph']?.toDouble(),
      motionSeconds: json['motionSeconds'],
      pastDataReceived: json['pastDataReceived'],
      stoppedSince: json['stoppedSince'],
      stopsCount: json['stopsCount'],
      tripsCount: json['tripsCount'],
    );
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
