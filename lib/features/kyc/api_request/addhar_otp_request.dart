// To parse this JSON data, do
//
//     final addharOtpRequest = addharOtpRequestFromJson(jsonString);

import 'dart:convert';

AddharOtpApiRequest addharOtpRequestFromJson(String str) => AddharOtpApiRequest.fromJson(json.decode(str));

String addharOtpRequestToJson(AddharOtpApiRequest data) => json.encode(data.toJson());

class AddharOtpApiRequest {
  String aadhaar;
  bool force;

  AddharOtpApiRequest({
    required this.aadhaar,
    required this.force,
  });

  factory AddharOtpApiRequest.fromJson(Map<String, dynamic> json) => AddharOtpApiRequest(
    aadhaar: json["aadhaar"],
    force: json["force"],
  );

  Map<String, dynamic> toJson() => {
    "aadhaar": aadhaar,
    "force": force,
  };
}
