class LpLoadMemoOtpResponse {
  LpLoadMemoOtpResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  LpLoadMemoOtpResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return LpLoadMemoOtpResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LpLoadMemoOtpResponse.fromJson(Map<String, dynamic> json){
    return LpLoadMemoOtpResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.message,
    required this.mobile,
    required this.otp,
  });

  final String message;
  final String mobile;
  final String otp;

  Data copyWith({
    String? message,
    String? mobile,
    String? otp,
  }) {
    return Data(
      message: message ?? this.message,
      mobile: mobile ?? this.mobile,
      otp: otp ?? this.otp,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      message: json["message"] ?? "",
      mobile: json["mobile"] ?? "",
      otp: json["otp"] ?? "",
    );
  }

}
