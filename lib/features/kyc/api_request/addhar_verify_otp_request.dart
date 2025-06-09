// To parse this JSON data, do
//
//     final addharVerifyOtpRequest = addharVerifyOtpRequestFromJson(jsonString);

import 'dart:convert';

AddharVerifyOtpApiRequest addharVerifyOtpRequestFromJson(String str) => AddharVerifyOtpApiRequest.fromJson(json.decode(str));

String addharVerifyOtpRequestToJson(AddharVerifyOtpApiRequest data) => json.encode(data.toJson());

class AddharVerifyOtpApiRequest {
  String requestId;
  String otp;
  String aadhaar;

  AddharVerifyOtpApiRequest({
    required this.requestId,
    required this.otp,
    required this.aadhaar,
  });

  factory AddharVerifyOtpApiRequest.fromJson(Map<String, dynamic> json) => AddharVerifyOtpApiRequest(
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
