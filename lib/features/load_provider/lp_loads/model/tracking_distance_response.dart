class TrackingDistanceResponse {
  TrackingDistanceResponse({
    required this.currentdistance,
    required this.currentdistanceValue,
    required this.overalldistance,
    required this.overalldistanceValue,
    required this.duration,
    required this.durationValue,
    required this.percentage,
    required this.coveredPercentage,
    required this.balancePercentage,
  });

  final String currentdistance;
  final int currentdistanceValue;
  final String overalldistance;
  final int overalldistanceValue;
  final String duration;
  final int durationValue;
  final int percentage;
  final int coveredPercentage;
  final int balancePercentage;

  TrackingDistanceResponse copyWith({
    String? currentdistance,
    int? currentdistanceValue,
    String? overalldistance,
    int? overalldistanceValue,
    String? duration,
    int? durationValue,
    int? percentage,
    int? balancePercentage,
    int? coveredPercentage,
  }) {
    return TrackingDistanceResponse(
      currentdistance: currentdistance ?? this.currentdistance,
      currentdistanceValue: currentdistanceValue ?? this.currentdistanceValue,
      overalldistance: overalldistance ?? this.overalldistance,
      overalldistanceValue: overalldistanceValue ?? this.overalldistanceValue,
      duration: duration ?? this.duration,
      durationValue: durationValue ?? this.durationValue,
      percentage: percentage ?? this.percentage,
      coveredPercentage: coveredPercentage ?? this.coveredPercentage,
      balancePercentage: balancePercentage ?? this.balancePercentage,
    );
  }

  factory TrackingDistanceResponse.fromJson(Map<String, dynamic> json){
    return TrackingDistanceResponse(
      currentdistance: json["currentdistance"] ?? "",
      currentdistanceValue: json["currentdistanceValue"] ?? 0,
      overalldistance: json["overalldistance"] ?? "",
      overalldistanceValue: json["overalldistanceValue"] ?? 0,
      duration: json["duration"] ?? "",
      durationValue: json["durationValue"] ?? 0,
      percentage: json["percentage"] ?? 0,
      coveredPercentage: json["coveredPercentage"] ?? 0,
      balancePercentage: json["balancePercentage"] ?? 0,
    );
  }

}
