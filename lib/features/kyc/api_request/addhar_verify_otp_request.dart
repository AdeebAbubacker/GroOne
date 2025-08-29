// To parse this JSON data, do
//
//     final aadhaarVerifyOtpRequest = aadhaarVerifyOtpRequestFromJson(jsonString);

import 'dart:convert';

AadhaarVerifyOtpApiRequest aadhaarVerifyOtpRequestFromJson(String str) => AadhaarVerifyOtpApiRequest.fromJson(json.decode(str));

String aadhaarVerifyOtpRequestToJson(AadhaarVerifyOtpApiRequest data) => json.encode(data.toJson());

class AadhaarVerifyOtpApiRequest {
  String requestId;
  String otp;
  String aadhaar;

  AadhaarVerifyOtpApiRequest({
    required this.requestId,
    required this.otp,
    required this.aadhaar,
  });

  factory AadhaarVerifyOtpApiRequest.fromJson(Map<String, dynamic> json) => AadhaarVerifyOtpApiRequest(
    requestId: json["request_id"],
    otp: json["otp"],
    aadhaar: json["aadhaar"],
  );

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "otp": otp,
    "aadhaar": aadhaar,
  };
}
