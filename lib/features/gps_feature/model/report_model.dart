class Report {
  final String date;
  final int safetyCount;
  final String colorCode;
  final List<ReportLocation> locations;
  final double distance;
  final double avgSpeed;
  final String engineOn;
  final String idleTime;

  Report({
    required this.date,
    required this.safetyCount,
    required this.colorCode,
    required this.locations,
    required this.distance,
    required this.avgSpeed,
    required this.engineOn,
    required this.idleTime,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      date: json['date'] ?? '',
      safetyCount: json['safetyCount'] ?? 0,
      colorCode: json['colorCode'] ?? 'green',
      locations: (json['locations'] as List)
          .map((e) => ReportLocation.fromJson(e))
          .toList(),
      distance: (json['distance'] ?? 0).toDouble(),
      avgSpeed: (json['avgSpeed'] ?? 0).toDouble(),
      engineOn: json['engineOn'] ?? '',
      idleTime: json['idleTime'] ?? '',
    );
  }
}

class ReportLocation {
  final String address;
  final String time;
  final bool isSafe;

  ReportLocation({
    required this.address,
    required this.time,
    required this.isSafe,
  });

  factory ReportLocation.fromJson(Map<String, dynamic> json) {
    return ReportLocation(
      address: json['address'] ?? '',
      time: json['time'] ?? '',
      isSafe: json['isSafe'] ?? false,
    );
  }
}
