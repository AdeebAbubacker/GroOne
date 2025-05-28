class ProfileDetailResponse {
  ProfileDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final AllProfileDetails? data;

  factory ProfileDetailResponse.fromJson(Map<String, dynamic> json){
    return ProfileDetailResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : AllProfileDetails.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };

}

class AllProfileDetails {
  AllProfileDetails({
    required this.customer,
    required this.details,
  });

  final Customer? customer;
  final Details? details;

  factory AllProfileDetails.fromJson(Map<String, dynamic> json){
    return AllProfileDetails(
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      details: json["details"] == null ? null : Details.fromJson(json["details"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "customer": customer?.toJson(),
    "details": details?.toJson(),
  };

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

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerName": customerName,
    "mobileNumber": mobileNumber,
    "emailId": emailId,
    "blueId": blueId,
    "password": password,
    "otp": otp,
    "otpAttempt": otpAttempt,
    "isKyc": isKyc,
    "roleId": roleId,
    "tempFlg": tempFlg,
    "status": status,
    "isLogin": isLogin,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}

class Details {
  Details({
    required this.id,
    required this.customerId,
    required this.companyName,
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
    required this.isAadhar,
    required this.isGstin,
    required this.isTan,
    required this.isPan,
    required this.bankAccount,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
    required this.status,
    required this.truckType,
    required this.ownedTrucks,
    required this.attachedTrucks,
    required this.preferredLanes,
    required this.uploadRc,
    required this.pincode,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.createdAt,
    required this.deletedAt,
    required this.detailsCustomerId,
    required this.detailsCompanyTypeId,
  });

  final int id;
  final num customerId;
  final String companyName;
  final num companyTypeId;
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
  final bool isAadhar;
  final bool isGstin;
  final bool isTan;
  final bool isPan;
  final dynamic bankAccount;
  final dynamic bankName;
  final dynamic branchName;
  final dynamic ifscCode;
  final num status;
  final dynamic truckType;
  final dynamic ownedTrucks;
  final dynamic attachedTrucks;
  final dynamic preferredLanes;
  final dynamic uploadRc;
  final String pincode;
  final dynamic address1;
  final dynamic address2;
  final dynamic address3;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final int detailsCustomerId;
  final int detailsCompanyTypeId;

  factory Details.fromJson(Map<String, dynamic> json){
    return Details(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      companyName: json["companyName"] ?? "",
      companyTypeId: json["companyTypeId"] ?? 0,
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
      isAadhar: json["isAadhar"] ?? false,
      isGstin: json["isGstin"] ?? false,
      isTan: json["isTan"] ?? false,
      isPan: json["isPan"] ?? false,
      bankAccount: json["bankAccount"],
      bankName: json["bankName"],
      branchName: json["branchName"],
      ifscCode: json["ifscCode"],
      status: json["status"] ?? 0,
      truckType: json["truckType"],
      ownedTrucks: json["ownedTrucks"],
      attachedTrucks: json["attachedTrucks"],
      preferredLanes: json["preferredLanes"],
      uploadRc: json["uploadRc"],
      pincode: json["pincode"] ?? "",
      address1: json["address1"],
      address2: json["address2"],
      address3: json["address3"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      detailsCustomerId: json["customer_id"] ?? 0,
      detailsCompanyTypeId: json["company_type_id"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "companyName": companyName,
    "companyTypeId": companyTypeId,
    "gstin": gstin,
    "gstinDocLink": gstinDocLink,
    "aadhar": aadhar,
    "aadharDocLink": aadharDocLink,
    "pan": pan,
    "panDocLink": panDocLink,
    "cheque": cheque,
    "chequeDocLink": chequeDocLink,
    "drivingLicense": drivingLicense,
    "drivingLicenseDocLink": drivingLicenseDocLink,
    "tds": tds,
    "tdsDocLink": tdsDocLink,
    "tan": tan,
    "tanDocLink": tanDocLink,
    "isAadhar": isAadhar,
    "isGstin": isGstin,
    "isTan": isTan,
    "isPan": isPan,
    "bankAccount": bankAccount,
    "bankName": bankName,
    "branchName": branchName,
    "ifscCode": ifscCode,
    "status": status,
    "truckType": truckType,
    "ownedTrucks": ownedTrucks,
    "attachedTrucks": attachedTrucks,
    "preferredLanes": preferredLanes,
    "uploadRc": uploadRc,
    "pincode": pincode,
    "address1": address1,
    "address2": address2,
    "address3": address3,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
    "customer_id": detailsCustomerId,
    "company_type_id": detailsCompanyTypeId,
  };

}
