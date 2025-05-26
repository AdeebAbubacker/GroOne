class SubmitKycResponse {
  SubmitKycResponse({
    required this.status,
    required this.message,
  });

  final bool status;
  final String message;

  factory SubmitKycResponse.fromJson(Map<String, dynamic> json){
    return SubmitKycResponse(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };

}
