class VerifyPanApiRequest {
  VerifyPanApiRequest({
    required this.pan,
    required this.force,
  });

  final String pan;
  final bool force;

  factory VerifyPanApiRequest.fromJson(Map<String, dynamic> json){
    return VerifyPanApiRequest(
      pan: json["pan"] ?? "",
      force: json["force"] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    "pan_number": pan,
    "name": "Test User",
  };

}
