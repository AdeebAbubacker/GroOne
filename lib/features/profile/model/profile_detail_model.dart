class ProfileDetailModel {
  ProfileDetailModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final ProfileDetailsData? data;

  ProfileDetailModel copyWith({
    bool? success,
    String? message,
    ProfileDetailsData? data,
  }) {
    return ProfileDetailModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory ProfileDetailModel.fromJson(Map<String, dynamic> json){
    return ProfileDetailModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : ProfileDetailsData.fromJson(json["data"]),
    );
  }

}

class ProfileDetailsData {
  ProfileDetailsData({
    required this.customer,
    required this.details,
  });

  final Customer? customer;
  final Details? details;

  ProfileDetailsData copyWith({
    Customer? customer,
    Details? details,
  }) {
    return ProfileDetailsData(
      customer: customer ?? this.customer,
      details: details ?? this.details,
    );
  }

  factory ProfileDetailsData.fromJson(Map<String, dynamic> json){
    return ProfileDetailsData(
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
    required this.emailOtp,
    required this.otpAttempt,
    required this.roleId,
    required this.isKyc,
    required this.kycRejectReason,
    required this.tempFlg,
    required this.status,
    required this.isLogin,
    required this.createdAt,
    required this.deletedAt,
    required this.kycType,
    required this.accountType,
  });

  final int id;
  final String customerName;
  final String mobileNumber;
  final String emailId;
  final String blueId;
  final dynamic password;
  final num otp;
  final String emailOtp;
  final num otpAttempt;
  final num roleId;
  final num isKyc;
  final dynamic kycRejectReason;
  final bool tempFlg;
  final num status;
  final bool isLogin;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final KycType? kycType;
  final String accountType;

  Customer copyWith({
    int? id,
    String? customerName,
    String? mobileNumber,
    String? emailId,
    String? blueId,
    dynamic? password,
    num? otp,
    String? emailOtp,
    num? otpAttempt,
    num? roleId,
    num? isKyc,
    dynamic? kycRejectReason,
    bool? tempFlg,
    num? status,
    bool? isLogin,
    DateTime? createdAt,
    dynamic? deletedAt,
    KycType? kycType,
    String? accountType,
  }) {
    return Customer(
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
      kycRejectReason: kycRejectReason ?? this.kycRejectReason,
      tempFlg: tempFlg ?? this.tempFlg,
      status: status ?? this.status,
      isLogin: isLogin ?? this.isLogin,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      kycType: kycType ?? this.kycType,
      accountType: accountType ?? this.accountType,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      id: json["id"] ?? 0,
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      emailId: json["emailId"] ?? "",
      blueId: json["blueId"] ?? "",
      password: json["password"],
      otp: json["otp"] ?? 0,
      emailOtp: json["email_otp"] ?? "",
      otpAttempt: json["otpAttempt"] ?? 0,
      roleId: json["roleId"] ?? 0,
      isKyc: json["isKyc"] ?? 0,
      kycRejectReason: json["kycRejectReason"],
      tempFlg: json["tempFlg"] ?? false,
      status: json["status"] ?? 0,
      isLogin: json["isLogin"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      kycType: json["kycType"] == null ? null : KycType.fromJson(json["kycType"]),
      accountType: json["accountType"] ?? "",
    );
  }

}

class KycType {
  KycType({
    required this.id,
    required this.kycType,
  });

  final int id;
  final String kycType;

  KycType copyWith({
    int? id,
    String? kycType,
  }) {
    return KycType(
      id: id ?? this.id,
      kycType: kycType ?? this.kycType,
    );
  }

  factory KycType.fromJson(Map<String, dynamic> json){
    return KycType(
      id: json["id"] ?? 0,
      kycType: json["kyc_type"] ?? "",
    );
  }

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
    required this.fullAddress,
    required this.addressName,
    required this.city,
    required this.state,
    required this.address2,
    required this.address3,
    required this.profileImageUrl,
    required this.location,
    required this.createdAt,
    required this.deletedAt,
    required this.detailsCustomerId,
    required this.detailsCompanyTypeId,
  });

  final int id;
  final num customerId;
  final String companyName;
  final num companyTypeId;
  final String gstin;
  final String gstinDocLink;
  final String aadhar;
  final dynamic aadharDocLink;
  final String pan;
  final String panDocLink;
  final dynamic cheque;
  final String chequeDocLink;
  final dynamic drivingLicense;
  final dynamic drivingLicenseDocLink;
  final dynamic tds;
  final String tdsDocLink;
  final String tan;
  final String tanDocLink;
  final bool isAadhar;
  final bool isGstin;
  final bool isTan;
  final bool isPan;
  final String bankAccount;
  final String bankName;
  final String branchName;
  final String ifscCode;
  final num status;
  final dynamic truckType;
  final dynamic ownedTrucks;
  final dynamic attachedTrucks;
  final dynamic preferredLanes;
  final dynamic uploadRc;
  final String pincode;
  final String address1;
  final dynamic fullAddress;
  final dynamic addressName;
  final dynamic city;
  final dynamic state;
  final String address2;
  final String address3;
  final dynamic profileImageUrl;
  final dynamic location;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final int detailsCustomerId;
  final int detailsCompanyTypeId;

  Details copyWith({
    int? id,
    num? customerId,
    String? companyName,
    num? companyTypeId,
    String? gstin,
    String? gstinDocLink,
    String? aadhar,
    dynamic? aadharDocLink,
    String? pan,
    String? panDocLink,
    dynamic? cheque,
    String? chequeDocLink,
    dynamic? drivingLicense,
    dynamic? drivingLicenseDocLink,
    dynamic? tds,
    String? tdsDocLink,
    String? tan,
    String? tanDocLink,
    bool? isAadhar,
    bool? isGstin,
    bool? isTan,
    bool? isPan,
    String? bankAccount,
    String? bankName,
    String? branchName,
    String? ifscCode,
    num? status,
    dynamic? truckType,
    dynamic? ownedTrucks,
    dynamic? attachedTrucks,
    dynamic? preferredLanes,
    dynamic? uploadRc,
    String? pincode,
    String? address1,
    dynamic? fullAddress,
    dynamic? addressName,
    dynamic? city,
    dynamic? state,
    String? address2,
    String? address3,
    dynamic? profileImageUrl,
    dynamic? location,
    DateTime? createdAt,
    dynamic? deletedAt,
    int? detailsCustomerId,
    int? detailsCompanyTypeId,
  }) {
    return Details(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      companyName: companyName ?? this.companyName,
      companyTypeId: companyTypeId ?? this.companyTypeId,
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
      isAadhar: isAadhar ?? this.isAadhar,
      isGstin: isGstin ?? this.isGstin,
      isTan: isTan ?? this.isTan,
      isPan: isPan ?? this.isPan,
      bankAccount: bankAccount ?? this.bankAccount,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      ifscCode: ifscCode ?? this.ifscCode,
      status: status ?? this.status,
      truckType: truckType ?? this.truckType,
      ownedTrucks: ownedTrucks ?? this.ownedTrucks,
      attachedTrucks: attachedTrucks ?? this.attachedTrucks,
      preferredLanes: preferredLanes ?? this.preferredLanes,
      uploadRc: uploadRc ?? this.uploadRc,
      pincode: pincode ?? this.pincode,
      address1: address1 ?? this.address1,
      fullAddress: fullAddress ?? this.fullAddress,
      addressName: addressName ?? this.addressName,
      city: city ?? this.city,
      state: state ?? this.state,
      address2: address2 ?? this.address2,
      address3: address3 ?? this.address3,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      detailsCustomerId: detailsCustomerId ?? this.detailsCustomerId,
      detailsCompanyTypeId: detailsCompanyTypeId ?? this.detailsCompanyTypeId,
    );
  }

  factory Details.fromJson(Map<String, dynamic> json){
    return Details(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      companyName: json["companyName"] ?? "",
      companyTypeId: json["companyTypeId"] ?? 0,
      gstin: json["gstin"] ?? "",
      gstinDocLink: json["gstinDocLink"] ?? "",
      aadhar: json["aadhar"] ?? "",
      aadharDocLink: json["aadharDocLink"],
      pan: json["pan"] ?? "",
      panDocLink: json["panDocLink"] ?? "",
      cheque: json["cheque"],
      chequeDocLink: json["chequeDocLink"] ?? "",
      drivingLicense: json["drivingLicense"],
      drivingLicenseDocLink: json["drivingLicenseDocLink"],
      tds: json["tds"],
      tdsDocLink: json["tdsDocLink"] ?? "",
      tan: json["tan"] ?? "",
      tanDocLink: json["tanDocLink"] ?? "",
      isAadhar: json["isAadhar"] ?? false,
      isGstin: json["isGstin"] ?? false,
      isTan: json["isTan"] ?? false,
      isPan: json["isPan"] ?? false,
      bankAccount: json["bankAccount"] ?? "",
      bankName: json["bankName"] ?? "",
      branchName: json["branchName"] ?? "",
      ifscCode: json["ifscCode"] ?? "",
      status: json["status"] ?? 0,
      truckType: json["truckType"],
      ownedTrucks: json["ownedTrucks"],
      attachedTrucks: json["attachedTrucks"],
      preferredLanes: json["preferredLanes"],
      uploadRc: json["uploadRc"],
      pincode: json["pincode"] ?? "",
      address1: json["address1"] ?? "",
      fullAddress: json["fullAddress"],
      addressName: json["addressName"],
      city: json["city"],
      state: json["state"],
      address2: json["address2"] ?? "",
      address3: json["address3"] ?? "",
      profileImageUrl: json["profileImageUrl"],
      location: json["location"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      detailsCustomerId: json["customer_id"] ?? 0,
      detailsCompanyTypeId: json["company_type_id"] ?? 0,
    );
  }

}
