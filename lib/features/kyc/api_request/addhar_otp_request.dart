// To parse this JSON data, do
//
//     final addharOtpRequest = addharOtpRequestFromJson(jsonString);

import 'dart:convert';

AddharOtpRequest addharOtpRequestFromJson(String str) => AddharOtpRequest.fromJson(json.decode(str));

String addharOtpRequestToJson(AddharOtpRequest data) => json.encode(data.toJson());

class AddharOtpRequest {
  String aadhaar;
  bool force;

  AddharOtpRequest({
    required this.aadhaar,
    required this.force,
  });

  factory AddharOtpRequest.fromJson(Map<String, dynamic> json) => AddharOtpRequest(
    aadhaar: json["aadhaar"],
    force: json["force"],
  );

  Map<String, dynamic> toJson() => {
    "aadhaar": aadhaar,
    "force": force,
  };
}
