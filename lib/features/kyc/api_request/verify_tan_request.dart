class VerifyTanRequest {
  VerifyTanRequest({
    required this.tan,
    required this.force,
  });

  final String tan;
  final bool force;

  factory VerifyTanRequest.fromJson(Map<String, dynamic> json){
    return VerifyTanRequest(
      tan: json["tan"] ?? "",
      force: json["force"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "tan": tan,
    "force": force,
  };

}
