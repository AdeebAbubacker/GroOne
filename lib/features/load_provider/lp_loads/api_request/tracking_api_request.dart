class TrackingDistanceApiRequest {
  TrackingDistanceApiRequest({
    required this.originLat,
    required this.originLong,
    required this.currentLat,
    required this.currentLong,
    required this.destLat,
    required this.destLong,
  });

  final double originLat;
  final double originLong;
  final double currentLat;
  final double currentLong;
  final double destLat;
  final double destLong;

  TrackingDistanceApiRequest copyWith({
    double? originLat,
    double? originLong,
    double? currentLat,
    double? currentLong,
    double? destLat,
    double? destLong,
  }) {
    return TrackingDistanceApiRequest(
      originLat: originLat ?? this.originLat,
      originLong: originLong ?? this.originLong,
      currentLat: currentLat ?? this.currentLat,
      currentLong: currentLong ?? this.currentLong,
      destLat: destLat ?? this.destLat,
      destLong: destLong ?? this.destLong,
    );
  }

  factory TrackingDistanceApiRequest.fromJson(Map<String, dynamic> json){
    return TrackingDistanceApiRequest(
      originLat: json["originLat"] ?? 0.0,
      originLong: json["originLong"] ?? 0.0,
      currentLat: json["currentLat"] ?? 0.0,
      currentLong: json["currentLong"] ?? 0.0,
      destLat: json["destLat"] ?? 0.0,
      destLong: json["destLong"] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    "originLat": originLat,
    "originLong": originLong,
    "currentLat": currentLat,
    "currentLong": currentLong,
    "destLat": destLat,
    "destLong": destLong,
  };

}
