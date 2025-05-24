class VpCreationModel {
  VpCreationModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  factory VpCreationModel.fromJson(Map<String, dynamic> json){
    return VpCreationModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.customer,
    required this.details,
  });

  final Customer? customer;
  final Details? details;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      details: json["details"] == null ? null : Details.fromJson(json["details"]),
    );
  }

}

class Customer {
  Customer({
    required this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.emailId,
    required this.blueId,
    required this.password,
    required this.otp,
    required this.otpAttempt,
    required this.isKyc,
    required this.roleId,
    required this.tempFlg,
    required this.status,
    required this.isLogin,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String customerName;
  final String mobileNumber;
  final dynamic emailId;
  final dynamic blueId;
  final dynamic password;
  final num otp;
  final num otpAttempt;
  final bool isKyc;
  final num roleId;
  final bool tempFlg;
  final num status;
  final bool isLogin;
  final DateTime? createdAt;
  final dynamic deletedAt;

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      id: json["id"] ?? 0,
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      emailId: json["emailId"],
      blueId: json["blueId"],
      password: json["password"],
      otp: json["otp"] ?? 0,
      otpAttempt: json["otpAttempt"] ?? 0,
      isKyc: json["isKyc"] ?? false,
      roleId: json["roleId"] ?? 0,
      tempFlg: json["tempFlg"] ?? false,
      status: json["status"] ?? 0,
      isLogin: json["isLogin"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class Details {
  Details({
    required this.isAadhar,
    required this.isGstin,
    required this.isTan,
    required this.isPan,
    required this.createdAt,
    required this.id,
    required this.customerId,
    required this.companyName,
    required this.status,
    required this.truckType,
    required this.ownedTrucks,
    required this.attachedTrucks,
    required this.preferredLanes,
    required this.uploadRc,
    required this.companyTypeId,
    required this.gstin,
    required this.gstinDocLink,
    required this.aadhar,
    required this.aadharDocLink,
    required this.pan,
    required this.panDocLink,
    required this.cheque,
    required this.chequeDocLink,
    required this.drivingLicense,
    required this.drivingLicenseDocLink,
    required this.tds,
    required this.tdsDocLink,
    required this.tan,
    required this.tanDocLink,
    required this.bankAccount,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
    required this.pincode,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.deletedAt,
  });

  final bool isAadhar;
  final bool isGstin;
  final bool isTan;
  final bool isPan;
  final DateTime? createdAt;
  final int id;
  final num customerId;
  final String companyName;
  final num status;
  final List<num> truckType;
  final num ownedTrucks;
  final num attachedTrucks;
  final List<num> preferredLanes;
  final String uploadRc;
  final dynamic companyTypeId;
  final dynamic gstin;
  final dynamic gstinDocLink;
  final dynamic aadhar;
  final dynamic aadharDocLink;
  final dynamic pan;
  final dynamic panDocLink;
  final dynamic cheque;
  final dynamic chequeDocLink;
  final dynamic drivingLicense;
  final dynamic drivingLicenseDocLink;
  final dynamic tds;
  final dynamic tdsDocLink;
  final dynamic tan;
  final dynamic tanDocLink;
  final dynamic bankAccount;
  final dynamic bankName;
  final dynamic branchName;
  final dynamic ifscCode;
  final dynamic pincode;
  final dynamic address1;
  final dynamic address2;
  final dynamic address3;
  final dynamic deletedAt;

  factory Details.fromJson(Map<String, dynamic> json){
    return Details(
      isAadhar: json["isAadhar"] ?? false,
      isGstin: json["isGstin"] ?? false,
      isTan: json["isTan"] ?? false,
      isPan: json["isPan"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      companyName: json["companyName"] ?? "",
      status: json["status"] ?? 0,
      truckType: json["truckType"] == null ? [] : List<num>.from(json["truckType"]!.map((x) => x)),
      ownedTrucks: json["ownedTrucks"] ?? 0,
      attachedTrucks: json["attachedTrucks"] ?? 0,
      preferredLanes: json["preferredLanes"] == null ? [] : List<num>.from(json["preferredLanes"]!.map((x) => x)),
      uploadRc: json["uploadRc"] ?? "",
      companyTypeId: json["companyTypeId"],
      gstin: json["gstin"],
      gstinDocLink: json["gstinDocLink"],
      aadhar: json["aadhar"],
      aadharDocLink: json["aadharDocLink"],
      pan: json["pan"],
      panDocLink: json["panDocLink"],
      cheque: json["cheque"],
      chequeDocLink: json["chequeDocLink"],
      drivingLicense: json["drivingLicense"],
      drivingLicenseDocLink: json["drivingLicenseDocLink"],
      tds: json["tds"],
      tdsDocLink: json["tdsDocLink"],
      tan: json["tan"],
      tanDocLink: json["tanDocLink"],
      bankAccount: json["bankAccount"],
      bankName: json["bankName"],
      branchName: json["branchName"],
      ifscCode: json["ifscCode"],
      pincode: json["pincode"],
      address1: json["address1"],
      address2: json["address2"],
      address3: json["address3"],
      deletedAt: json["deletedAt"],
    );
  }

}
