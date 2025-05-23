

class OtpRequest {
  String mobile;
  int role;
  int otp;

  OtpRequest({
    required this.mobile,
    required this.role,
    required this.otp,
  });

  factory OtpRequest.fromJson(Map<String, dynamic> json) => OtpRequest(
    mobile: json["mobile"],
    role: json["role"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "mobile": mobile,
    "role": role,
    "otp": otp,
  };
}
