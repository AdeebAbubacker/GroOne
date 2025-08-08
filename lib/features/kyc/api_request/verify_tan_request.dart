class VerifyTanApiRequest {
  VerifyTanApiRequest({
    required this.tan,
    required this.force,
  });

  final String tan;
  final bool force;

  factory VerifyTanApiRequest.fromJson(Map<String, dynamic> json){
    return VerifyTanApiRequest(
      tan: json["tan"] ?? "",
      force: json["force"] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    "tan_number": tan,
  };

}
