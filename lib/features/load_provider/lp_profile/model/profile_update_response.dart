class ProfileUpdateResponse {
  ProfileUpdateResponse({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json){
    return ProfileUpdateResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };

}
