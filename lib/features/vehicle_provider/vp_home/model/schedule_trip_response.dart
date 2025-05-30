class ScheduleTripResponse {
  ScheduleTripResponse({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory ScheduleTripResponse.fromJson(Map<String, dynamic> json){
    return ScheduleTripResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };

}
