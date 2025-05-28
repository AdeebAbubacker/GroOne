// To parse this JSON data, do
//
//     final addharVerifyOtpRequest = addharVerifyOtpRequestFromJson(jsonString);

import 'dart:convert';

AddharVerifyOtpRequest addharVerifyOtpRequestFromJson(String str) => AddharVerifyOtpRequest.fromJson(json.decode(str));

String addharVerifyOtpRequestToJson(AddharVerifyOtpRequest data) => json.encode(data.toJson());

class AddharVerifyOtpRequest {
  String requestId;
  String otp;
  String aadhaar;

  AddharVerifyOtpRequest({
    required this.requestId,
    required this.otp,
    required this.aadhaar,
  });

  factory AddharVerifyOtpRequest.fromJson(Map<String, dynamic> json) => AddharVerifyOtpRequest(
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
