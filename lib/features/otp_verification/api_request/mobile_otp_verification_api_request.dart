

class OtpRequest {
  String mobile;
  int type;
  int otp;
  bool driver;

  OtpRequest({
    required this.mobile,
    required this.type,
    required this.otp,
    required this.driver,
  });

  factory OtpRequest.fromJson(Map<String, dynamic> json) => OtpRequest(
    mobile: json["mobile"],
    type: json["type"],
    otp: json["otp"],
    driver: json["driver"],
  );

  Map<String, dynamic> toJson() => {
    "mobile": mobile,
    "type": type,
    "otp": otp,
    "driver": driver,
  };
}
