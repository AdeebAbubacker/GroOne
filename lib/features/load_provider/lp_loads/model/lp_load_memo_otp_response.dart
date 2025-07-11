class LpLoadMemoOtpResponse {
  LpLoadMemoOtpResponse({
    required this.message,
    required this.mobile,
    required this.otp,
  });

  final String message;
  final String mobile;
  final int otp;

  LpLoadMemoOtpResponse copyWith({
    String? message,
    String? mobile,
    int? otp,
  }) {
    return LpLoadMemoOtpResponse(
      message: message ?? this.message,
      mobile: mobile ?? this.mobile,
      otp: otp ?? this.otp,
    );
  }

  factory LpLoadMemoOtpResponse.fromJson(Map<String, dynamic> json){
    return LpLoadMemoOtpResponse(
      message: json["message"] ?? "",
      mobile: json["mobile"] ?? "",
      otp: json["otp"] ?? "",
    );
  }

}

class LpLoadMemoVerifyOtpResponse {
  LpLoadMemoVerifyOtpResponse({
    required this.message
  });

  final String message;

  LpLoadMemoVerifyOtpResponse copyWith({
    String? message,
  }) {
    return LpLoadMemoVerifyOtpResponse(
      message: message ?? this.message,
    );
  }

  factory LpLoadMemoVerifyOtpResponse.fromJson(Map<String, dynamic> json){
    return LpLoadMemoVerifyOtpResponse(
      message: json["message"] ?? "",
    );
  }

}
