class CreateResponse {
  CreateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  CreateResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return CreateResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory CreateResponse.fromJson(Map<String, dynamic> json){
    return CreateResponse(
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

  final CustomerModelLp? customer;
  final Details? details;

  Data copyWith({
    CustomerModelLp? customer,
    Details? details,
  }) {
    return Data(
      customer: customer ?? this.customer,
      details: details ?? this.details,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      customer: json["customer"] == null ? null : CustomerModelLp.fromJson(json["customer"]),
      details: json["details"] == null ? null : Details.fromJson(json["details"]),
    );
  }

}

class CustomerModelLp {
  CustomerModelLp({
    required this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.emailId,
    required this.blueId,
    required this.password,
    required this.otp,
    required this.emailOtp,
    required this.otpAttempt,
    required this.roleId,
    required this.isKyc,
    required this.tempFlg,
    required this.status,
    required this.isLogin,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String customerName;
  final String mobileNumber;
  final String emailId;
  final dynamic blueId;
  final dynamic password;
  final num otp;
  final String emailOtp;
  final num otpAttempt;
  final num roleId;
  final num isKyc;
  final bool tempFlg;
  final num status;
  final bool isLogin;
  final DateTime? createdAt;
  final dynamic deletedAt;

  CustomerModelLp copyWith({
    int? id,
    String? customerName,
    String? mobileNumber,
    String? emailId,
    dynamic? blueId,
    dynamic? password,
    num? otp,
    String? emailOtp,
    num? otpAttempt,
    num? roleId,
    num? isKyc,
    bool? tempFlg,
    num? status,
    bool? isLogin,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return CustomerModelLp(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailId: emailId ?? this.emailId,
      blueId: blueId ?? this.blueId,
      password: password ?? this.password,
      otp: otp ?? this.otp,
      emailOtp: emailOtp ?? this.emailOtp,
      otpAttempt: otpAttempt ?? this.otpAttempt,
      roleId: roleId ?? this.roleId,
      isKyc: isKyc ?? this.isKyc,
      tempFlg: tempFlg ?? this.tempFlg,
      status: status ?? this.status,
      isLogin: isLogin ?? this.isLogin,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory CustomerModelLp.fromJson(Map<String, dynamic> json){
    return CustomerModelLp(
      id: json["id"] ?? 0,
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      emailId: json["emailId"] ?? "",
      blueId: json["blueId"],
      password: json["password"],
      otp: json["otp"] ?? 0,
      emailOtp: json["email_otp"] ?? "",
      otpAttempt: json["otpAttempt"] ?? 0,
      roleId: json["roleId"] ?? 0,
      isKyc: json["isKyc"] ?? 0,
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
    required this.companyTypeId,
    required this.pincode,
    required this.status,
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
    required this.truckType,
    required this.ownedTrucks,
    required this.attachedTrucks,
    required this.preferredLanes,
    required this.uploadRc,
    required this.address1,
    required this.fullAddress,
    required this.addressName,
    required this.city,
    required this.state,
    required this.address2,
    required this.address3,
    required this.profileImageUrl,
    required this.location,
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
  final num companyTypeId;
  final String pincode;
  final num status;
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
  final dynamic truckType;
  final dynamic ownedTrucks;
  final dynamic attachedTrucks;
  final dynamic preferredLanes;
  final dynamic uploadRc;
  final dynamic address1;
  final dynamic fullAddress;
  final dynamic addressName;
  final dynamic city;
  final dynamic state;
  final dynamic address2;
  final dynamic address3;
  final dynamic profileImageUrl;
  final dynamic location;
  final dynamic deletedAt;

  Details copyWith({
    bool? isAadhar,
    bool? isGstin,
    bool? isTan,
    bool? isPan,
    DateTime? createdAt,
    int? id,
    num? customerId,
    String? companyName,
    num? companyTypeId,
    String? pincode,
    num? status,
    dynamic? gstin,
    dynamic? gstinDocLink,
    dynamic? aadhar,
    dynamic? aadharDocLink,
    dynamic? pan,
    dynamic? panDocLink,
    dynamic? cheque,
    dynamic? chequeDocLink,
    dynamic? drivingLicense,
    dynamic? drivingLicenseDocLink,
    dynamic? tds,
    dynamic? tdsDocLink,
    dynamic? tan,
    dynamic? tanDocLink,
    dynamic? bankAccount,
    dynamic? bankName,
    dynamic? branchName,
    dynamic? ifscCode,
    dynamic? truckType,
    dynamic? ownedTrucks,
    dynamic? attachedTrucks,
    dynamic? preferredLanes,
    dynamic? uploadRc,
    dynamic? address1,
    dynamic? fullAddress,
    dynamic? addressName,
    dynamic? city,
    dynamic? state,
    dynamic? address2,
    dynamic? address3,
    dynamic? profileImageUrl,
    dynamic? location,
    dynamic? deletedAt,
  }) {
    return Details(
      isAadhar: isAadhar ?? this.isAadhar,
      isGstin: isGstin ?? this.isGstin,
      isTan: isTan ?? this.isTan,
      isPan: isPan ?? this.isPan,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      companyName: companyName ?? this.companyName,
      companyTypeId: companyTypeId ?? this.companyTypeId,
      pincode: pincode ?? this.pincode,
      status: status ?? this.status,
      gstin: gstin ?? this.gstin,
      gstinDocLink: gstinDocLink ?? this.gstinDocLink,
      aadhar: aadhar ?? this.aadhar,
      aadharDocLink: aadharDocLink ?? this.aadharDocLink,
      pan: pan ?? this.pan,
      panDocLink: panDocLink ?? this.panDocLink,
      cheque: cheque ?? this.cheque,
      chequeDocLink: chequeDocLink ?? this.chequeDocLink,
      drivingLicense: drivingLicense ?? this.drivingLicense,
      drivingLicenseDocLink: drivingLicenseDocLink ?? this.drivingLicenseDocLink,
      tds: tds ?? this.tds,
      tdsDocLink: tdsDocLink ?? this.tdsDocLink,
      tan: tan ?? this.tan,
      tanDocLink: tanDocLink ?? this.tanDocLink,
      bankAccount: bankAccount ?? this.bankAccount,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      ifscCode: ifscCode ?? this.ifscCode,
      truckType: truckType ?? this.truckType,
      ownedTrucks: ownedTrucks ?? this.ownedTrucks,
      attachedTrucks: attachedTrucks ?? this.attachedTrucks,
      preferredLanes: preferredLanes ?? this.preferredLanes,
      uploadRc: uploadRc ?? this.uploadRc,
      address1: address1 ?? this.address1,
      fullAddress: fullAddress ?? this.fullAddress,
      addressName: addressName ?? this.addressName,
      city: city ?? this.city,
      state: state ?? this.state,
      address2: address2 ?? this.address2,
      address3: address3 ?? this.address3,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

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
      companyTypeId: json["companyTypeId"] ?? 0,
      pincode: json["pincode"] ?? "",
      status: json["status"] ?? 0,
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
      truckType: json["truckType"],
      ownedTrucks: json["ownedTrucks"],
      attachedTrucks: json["attachedTrucks"],
      preferredLanes: json["preferredLanes"],
      uploadRc: json["uploadRc"],
      address1: json["address1"],
      fullAddress: json["fullAddress"],
      addressName: json["addressName"],
      city: json["city"],
      state: json["state"],
      address2: json["address2"],
      address3: json["address3"],
      profileImageUrl: json["profileImageUrl"],
      location: json["location"],
      deletedAt: json["deletedAt"],
    );
  }

}
