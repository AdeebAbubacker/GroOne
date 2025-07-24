class DeviceDistancePojo {
  final int? deviceId;
  final List<DistanceNestedPojo>? nested;

  DeviceDistancePojo({this.deviceId, this.nested});

  factory DeviceDistancePojo.fromJson(Map<String, dynamic> json) {
    return DeviceDistancePojo(
      deviceId: json['device_id'],
      nested: (json['nested'] as List)
          .map((e) => DistanceNestedPojo.fromJson(e))
          .toList(),
    );
  }
}

class DistanceNestedPojo {
  final String date;
  final double distance;

  DistanceNestedPojo({required this.date, required this.distance});

  factory DistanceNestedPojo.fromJson(Map<String, dynamic> json) {
    return DistanceNestedPojo(
      date: json['date'],
      distance: (json['distance'] ?? 0).toDouble(),
    );
  }
}
