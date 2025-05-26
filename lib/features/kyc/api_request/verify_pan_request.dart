class VerifyPanRequest {
  VerifyPanRequest({
    required this.pan,
    required this.force,
  });

  final String pan;
  final bool force;

  factory VerifyPanRequest.fromJson(Map<String, dynamic> json){
    return VerifyPanRequest(
      pan: json["pan"] ?? "",
      force: json["force"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "pan": pan,
    "force": force,
  };

}
