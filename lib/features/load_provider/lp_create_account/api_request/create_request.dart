// To parse this JSON data, do
//
//     final createRequest = createRequestFromJson(jsonString);

import 'dart:convert';

CreateRequest createRequestFromJson(String str) => CreateRequest.fromJson(json.decode(str));

String createRequestToJson(CreateRequest data) => json.encode(data.toJson());

class CreateRequest {
  String customerName;
  String mobileNumber;
  String companyName;
  int companyTypeId;
  String pincode;

  CreateRequest({
    required this.customerName,
    required this.mobileNumber,
    required this.companyName,
    required this.companyTypeId,
    required this.pincode,
  });

  factory CreateRequest.fromJson(Map<String, dynamic> json) => CreateRequest(
    customerName: json["customerName"],
    mobileNumber: json["mobileNumber"],
    companyName: json["companyName"],
    companyTypeId: json["companyTypeId"],
    pincode: json["pincode"],
  );

  Map<String, dynamic> toJson() => {
    "customerName": customerName,
    "mobileNumber": mobileNumber,
    "companyName": companyName,
    "companyTypeId": companyTypeId,
    "pincode": pincode,
  };
}
