// To parse this JSON data, do
//
//     final aadhaarOtpRequest = aadhaarOtpRequestFromJson(jsonString);

import 'dart:convert';

AadhaarOtpApiRequest aadhaarOtpRequestFromJson(String str) => AadhaarOtpApiRequest.fromJson(json.decode(str));

String aadhaarOtpRequestToJson(AadhaarOtpApiRequest data) => json.encode(data.toJson());

class AadhaarOtpApiRequest {
  String aadhaar;
  bool force;

  AadhaarOtpApiRequest({
    required this.aadhaar,
    required this.force,
  });

  factory AadhaarOtpApiRequest.fromJson(Map<String, dynamic> json) => AadhaarOtpApiRequest(
    aadhaar: json["aadhaar"],
    force: json["force"],
  );

  Map<String, dynamic> toJson() => {
    "aadhaar": aadhaar,
    "force": force,
  };
}
