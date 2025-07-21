// To parse this JSON data, do
//
//     final createRequest = createRequestFromJson(jsonString);

import 'dart:convert';


String createRequestToJson(LpCreateApiRequest data) => json.encode(data.toJson());

class LpCreateApiRequest {
  String customerName;
  String mobileNumber;
  String companyName;
  String email;
  int companyTypeId;
  int roleId;
  String pincode;

  LpCreateApiRequest({
    required this.customerName,
    required this.mobileNumber,
    required this.companyName,
    required this.email,
    required this.companyTypeId,
    required this.roleId,
    required this.pincode,
  });


  Map<String, dynamic> toJson() => {
    "customerName": customerName,
    "mobileNumber": mobileNumber,
    "companyName": companyName,
    "companyTypeId": companyTypeId,
    "emailId": email,
    "pincode": pincode,
    "roleId": roleId,
  };
}
