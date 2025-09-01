class ProfileDetailModel {
  ProfileDetailModel({
    required this.customer,
    required this.address,
    required this.bankDetails,
    required this.kycDocs,
    required this.vehicles,
  });

  final Customer? customer;
  final Address? address;
  final BankDetails? bankDetails;
  final List<KycDoc> kycDocs;
  final List<Vehicle> vehicles;

  ProfileDetailModel copyWith({
    Customer? customer,
    Address? address,
    BankDetails? bankDetails,
    List<KycDoc>? kycDocs,
    List<Vehicle>? vehicles,
  }) {
    return ProfileDetailModel(
      customer: customer ?? this.customer,
      address: address ?? this.address,
      bankDetails: bankDetails ?? this.bankDetails,
      kycDocs: kycDocs ?? this.kycDocs,
      vehicles: vehicles ?? this.vehicles,
    );
  }

  factory ProfileDetailModel.fromJson(Map<String, dynamic> json){
    return ProfileDetailModel(
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      address: json["address"] == null ? null : Address.fromJson(json["address"]),
      bankDetails: json["bankDetails"] == null ? null : BankDetails.fromJson(json["bankDetails"]),
      kycDocs: json["kycDocs"] == null ? [] : List<KycDoc>.from(json["kycDocs"]!.map((x) => KycDoc.fromJson(x))),
      vehicles: json["vehicles"] == null ? [] : List<Vehicle>.from(json["vehicles"]!.map((x) => Vehicle.fromJson(x))),
    );
  }

}

class Address {
  Address({
    required this.customersAddressId,
    required this.customerId,
    required this.addressName,
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.pincode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String customersAddressId;
  final String customerId;
  final dynamic addressName;
  final dynamic fullAddress;
  final dynamic city;
  final dynamic state;
  final String pincode;
  final dynamic status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Address copyWith({
    String? customersAddressId,
    String? customerId,
    dynamic addressName,
    dynamic fullAddress,
    dynamic city,
    dynamic state,
    String? pincode,
    dynamic status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) {
    return Address(
      customersAddressId: customersAddressId ?? this.customersAddressId,
      customerId: customerId ?? this.customerId,
      addressName: addressName ?? this.addressName,
      fullAddress: fullAddress ?? this.fullAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      customersAddressId: json["customers_address_id"] ?? "",
      customerId: json["customer_id"] ?? "",
      addressName: json["addressName"],
      fullAddress: json["fullAddress"],
      city: json["city"],
      state: json["state"],
      pincode: json["pincode"] ?? "",
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
    );
  }

}

class BankDetails {
  BankDetails({
    required this.bankDetailsId,
    required this.customerId,
    required this.bankAccount,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String bankDetailsId;
  final String customerId;
  final dynamic bankAccount;
  final dynamic bankName;
  final dynamic branchName;
  final dynamic ifscCode;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  BankDetails copyWith({
    String? bankDetailsId,
    String? customerId,
    dynamic bankAccount,
    dynamic bankName,
    dynamic branchName,
    dynamic ifscCode,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) {
    return BankDetails(
      bankDetailsId: bankDetailsId ?? this.bankDetailsId,
      customerId: customerId ?? this.customerId,
      bankAccount: bankAccount ?? this.bankAccount,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      ifscCode: ifscCode ?? this.ifscCode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory BankDetails.fromJson(Map<String, dynamic> json){
    return BankDetails(
      bankDetailsId: json["bank_details_id"] ?? "",
      customerId: json["customer_id"] ?? "",
      bankAccount: json["bankAccount"],
      bankName: json["bankName"],
      branchName: json["branchName"],
      ifscCode: json["ifscCode"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class Customer {
  Customer({
    required this.customerId,
    required this.customerName,
    required this.mobileNumber,
    required this.companyTypeId,
    required this.emailId,
    required this.blueId,
    required this.kycRejectReason,
    required this.password,
    required this.companyName,
    required this.isKyc,
    required this.preferredLanes,
    required this.roleId,
    required this.tempFlg,
    required this.status,
    required this.isLogin,
    required this.blueIdFlg,
    required this.createdAt,
    required this.deletedAt,
    required this.kycType,
    required this.companyType,
      this.customerSeriesNo,
  });

  final String customerId;
  final String customerName;
  final String mobileNumber;
  final int companyTypeId;
  final String emailId;
  final dynamic blueId;
  final dynamic kycRejectReason;
  final dynamic password;
  final String companyName;

  final int isKyc;
  final dynamic preferredLanes;
  final int roleId;
  final bool tempFlg;
  final int status;
  final bool isLogin;
  final bool blueIdFlg;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final Type? kycType;
  final Type? companyType;
  final int? customerSeriesNo;

  Customer copyWith({
    String? customerId,
    String? customerName,
    String? mobileNumber,
    int? companyTypeId,
    String? emailId,
    dynamic blueId,
    dynamic kycRejectReason,
    dynamic password,
    String? companyName,
    String? otp,
    dynamic otpAttempt,
    int? isKyc,
    dynamic preferredLanes,
    int? roleId,
    bool? tempFlg,
    int? status,
    bool? isLogin,
    bool? blueIdFlg,
    DateTime? createdAt,
    dynamic deletedAt,
    Type? kycType,
    Type? companyType,
  }) {
    return Customer(
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      companyTypeId: companyTypeId ?? this.companyTypeId,
      emailId: emailId ?? this.emailId,
      blueId: blueId ?? this.blueId,
      kycRejectReason: kycRejectReason ?? this.kycRejectReason,
      password: password ?? this.password,
      companyName: companyName ?? this.companyName,

      isKyc: isKyc ?? this.isKyc,
      preferredLanes: preferredLanes ?? this.preferredLanes,
      roleId: roleId ?? this.roleId,
      tempFlg: tempFlg ?? this.tempFlg,
      status: status ?? this.status,
      isLogin: isLogin ?? this.isLogin,
      blueIdFlg: blueIdFlg ?? this.blueIdFlg,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      kycType: kycType ?? this.kycType,
      companyType: companyType ?? this.companyType,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      customerId: json["customer_id"] ?? "",
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      companyTypeId: json["companyTypeId"] ?? 0,
      emailId: json["emailId"] ?? "",
      blueId: json["blueId"] ?? "",
      kycRejectReason: json["kycRejectReason"],
      password: json["password"],
      companyName: json["companyName"] ?? "",


      isKyc: json["isKyc"] ?? 0,
      preferredLanes: json["preferredLanes"],
      roleId: json["roleId"] ?? 0,
      tempFlg: json["tempFlg"] ?? false,
      status: json["status"] ?? 0,
      isLogin: json["isLogin"] ?? false,
      blueIdFlg: json["blueIdFlg"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      kycType: json["kycType"] == null ? null : Type.fromJson(json["kycType"]),
      companyType: json["companyType"] == null ? null : Type.fromJson(json["companyType"]),
      customerSeriesNo: json['customerSeriesNo']?? 0
    );
  }

}

class Type {
  Type({
    required this.id,
    required this.companyType,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
    required this.kycType,
  });

  final int id;
  final String companyType;
  final int status;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final String kycType;

  Type copyWith({
    int? id,
    String? companyType,
    int? status,
    DateTime? createdAt,
    dynamic deletedAt,
    String? kycType,
  }) {
    return Type(
      id: id ?? this.id,
      companyType: companyType ?? this.companyType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      kycType: kycType ?? this.kycType,
    );
  }

  factory Type.fromJson(Map<String, dynamic> json){
    return Type(
      id: json["id"] ?? 0,
      companyType: json["companyType"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      kycType: json["kycType"] ?? "",
    );
  }

}

class KycDoc {
  KycDoc({
    required this.kycDocsId,
    required this.customerId,
    required this.docType,
    required this.docNo,
    required this.docLink,
    required this.uploadRc,
    required this.isApproved,
    required this.approvedBy,
    required this.approvedAt,
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
    required this.isAadhar,
    required this.isGstin,
    required this.isTan,
    required this.isPan,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String kycDocsId;
  final String customerId;
  final dynamic docType;
  final dynamic docNo;
  final dynamic docLink;
  final dynamic uploadRc;
  final bool isApproved;
  final dynamic approvedBy;
  final dynamic approvedAt;
  final int status;
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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  KycDoc copyWith({
    String? kycDocsId,
    String? customerId,
    dynamic docType,
    dynamic docNo,
    dynamic docLink,
    dynamic uploadRc,
    bool? isApproved,
    dynamic approvedBy,
    dynamic approvedAt,
    int? status,
    dynamic gstin,
    dynamic gstinDocLink,
    dynamic aadhar,
    dynamic aadharDocLink,
    dynamic pan,
    dynamic panDocLink,
    dynamic cheque,
    dynamic chequeDocLink,
    dynamic drivingLicense,
    dynamic drivingLicenseDocLink,
    dynamic tds,
    dynamic tdsDocLink,
    dynamic tan,
    dynamic tanDocLink,
    bool? isAadhar,
    bool? isGstin,
    bool? isTan,
    bool? isPan,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) {
    return KycDoc(
      kycDocsId: kycDocsId ?? this.kycDocsId,
      customerId: customerId ?? this.customerId,
      docType: docType ?? this.docType,
      docNo: docNo ?? this.docNo,
      docLink: docLink ?? this.docLink,
      uploadRc: uploadRc ?? this.uploadRc,
      isApproved: isApproved ?? this.isApproved,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
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
      isAadhar: isAadhar ?? this.isAadhar,
      isGstin: isGstin ?? this.isGstin,
      isTan: isTan ?? this.isTan,
      isPan: isPan ?? this.isPan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory KycDoc.fromJson(Map<String, dynamic> json){
    return KycDoc(
      kycDocsId: json["kyc_docs_id"] ?? "",
      customerId: json["customer_id"] ?? "",
      docType: json["doc_type"],
      docNo: json["doc_no"],
      docLink: json["doc_link"],
      uploadRc: json["upload_rc"],
      isApproved: json["is_approved"] ?? false,
      approvedBy: json["approved_by"],
      approvedAt: json["approved_at"],
      status: json["status"] ?? 0,
      gstin: json["gstin"],
      gstinDocLink: json["gstin_doc_link"],
      aadhar: json["aadhar"],
      aadharDocLink: json["aadhar_doc_link"],
      pan: json["pan"],
      panDocLink: json["pan_doc_link"],
      cheque: json["cheque"],
      chequeDocLink: json["cheque_doc_link"],
      drivingLicense: json["driving_license"],
      drivingLicenseDocLink: json["driving_license_doc_link"],
      tds: json["tds"],
      tdsDocLink: json["tds_doc_link"],
      tan: json["tan"],
      tanDocLink: json["tan_doc_link"],
      isAadhar: json["is_aadhar"] ?? false,
      isGstin: json["is_gstin"] ?? false,
      isTan: json["is_tan"] ?? false,
      isPan: json["is_pan"] ?? false,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
    );
  }

}

class Vehicle {
  Vehicle({
    required this.vpVehiclesId,
    required this.customerId,
    required this.truckType,
    required this.ownedTrucks,
    required this.attachedTrucks,
    required this.preferredLanes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String vpVehiclesId;
  final String customerId;
  final dynamic truckType;
  final dynamic ownedTrucks;
  final dynamic attachedTrucks;
  final List<int>? preferredLanes;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Vehicle copyWith({
    String? vpVehiclesId,
    String? customerId,
    dynamic truckType,
    dynamic ownedTrucks,
    dynamic attachedTrucks,
    dynamic preferredLanes,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) {
    return Vehicle(
      vpVehiclesId: vpVehiclesId ?? this.vpVehiclesId,
      customerId: customerId ?? this.customerId,
      truckType: truckType ?? this.truckType,
      ownedTrucks: ownedTrucks ?? this.ownedTrucks,
      attachedTrucks: attachedTrucks ?? this.attachedTrucks,
      preferredLanes: preferredLanes ?? this.preferredLanes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json){

    return Vehicle(
      vpVehiclesId: json["vp_vehicles_id"] ?? "",
      customerId: json["customer_id"] ?? "",
      truckType: json["truckType"],
      ownedTrucks: json["ownedTrucks"],
      attachedTrucks: json["attachedTrucks"],
      preferredLanes: List<int>.from(json["preferredLanes"].map((x)=>x)),
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
    );
  }

}
