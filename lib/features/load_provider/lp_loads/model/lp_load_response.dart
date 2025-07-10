class LpLoadResponse {
  LpLoadResponse({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  final List<LpLoadItem> data;
  final int total;
  final PageMeta? pageMeta;

  LpLoadResponse copyWith({
    List<LpLoadItem>? data,
    int? total,
    PageMeta? pageMeta,
  }) {
    return LpLoadResponse(
      data: data ?? this.data,
      total: total ?? this.total,
      pageMeta: pageMeta ?? this.pageMeta,
    );
  }

  factory LpLoadResponse.fromJson(Map<String, dynamic> json){
    return LpLoadResponse(
      data: json["data"] == null ? [] : List<LpLoadItem>.from(json["data"]!.map((x) => LpLoadItem.fromJson(x))),
      total: json["total"] ?? 0,
      pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
    );
  }

}

class LpLoadItem {
  LpLoadItem({
    required this.loadId,
    required this.loadSeriesId,
    required this.laneId,
    required this.rateId,
    required this.customerId,
    required this.commodityId,
    required this.pickUpDateTime,
    required this.truckTypeId,
    required this.consignmentWeight,
    required this.notes,
    required this.loadStatusId,
    required this.expectedDeliveryDateTime,
    required this.isAgreed,
    required this.acceptedBy,
    required this.createdPlatform,
    required this.updatedPlatform,
    required this.status,
    required this.matchingStartDate,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.commodity,
    required this.truckType,
    required this.loadRoute,
    required this.loadStatusDetails,
    required this.loadStatusLogs,
    required this.loadPrice,
    required this.customer,
  });

  final String loadId;
  final String loadSeriesId;
  final int laneId;
  final int rateId;
  final String customerId;
  final int commodityId;
  final DateTime? pickUpDateTime;
  final int truckTypeId;
  final int consignmentWeight;
  final String notes;
  final int loadStatusId;
  final DateTime? expectedDeliveryDateTime;
  final int isAgreed;
  final dynamic acceptedBy;
  final int createdPlatform;
  final int updatedPlatform;
  final int status;
  final DateTime? matchingStartDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final Commodity? commodity;
  final TruckType? truckType;
  final LoadRoute? loadRoute;
  final LoadStatusDetails? loadStatusDetails;
  final List<LoadStatusLog> loadStatusLogs;
  final LoadPrice? loadPrice;
  final DatumCustomer? customer;

  LpLoadItem copyWith({
    String? loadId,
    String? loadSeriesId,
    int? laneId,
    int? rateId,
    String? customerId,
    int? commodityId,
    DateTime? pickUpDateTime,
    int? truckTypeId,
    int? consignmentWeight,
    String? notes,
    int? loadStatusId,
    DateTime? expectedDeliveryDateTime,
    int? isAgreed,
    dynamic? acceptedBy,
    int? createdPlatform,
    int? updatedPlatform,
    int? status,
    DateTime? matchingStartDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
    Commodity? commodity,
    TruckType? truckType,
    LoadRoute? loadRoute,
    LoadStatusDetails? loadStatusDetails,
    List<LoadStatusLog>? loadStatusLogs,
    LoadPrice? loadPrice,
    DatumCustomer? customer,
  }) {
    return LpLoadItem(
      loadId: loadId ?? this.loadId,
      loadSeriesId: loadSeriesId ?? this.loadSeriesId,
      laneId: laneId ?? this.laneId,
      rateId: rateId ?? this.rateId,
      customerId: customerId ?? this.customerId,
      commodityId: commodityId ?? this.commodityId,
      pickUpDateTime: pickUpDateTime ?? this.pickUpDateTime,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      consignmentWeight: consignmentWeight ?? this.consignmentWeight,
      notes: notes ?? this.notes,
      loadStatusId: loadStatusId ?? this.loadStatusId,
      expectedDeliveryDateTime: expectedDeliveryDateTime ?? this.expectedDeliveryDateTime,
      isAgreed: isAgreed ?? this.isAgreed,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      createdPlatform: createdPlatform ?? this.createdPlatform,
      updatedPlatform: updatedPlatform ?? this.updatedPlatform,
      status: status ?? this.status,
      matchingStartDate: matchingStartDate ?? this.matchingStartDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      loadRoute: loadRoute ?? this.loadRoute,
      loadStatusDetails: loadStatusDetails ?? this.loadStatusDetails,
      loadStatusLogs: loadStatusLogs ?? this.loadStatusLogs,
      loadPrice: loadPrice ?? this.loadPrice,
      customer: customer ?? this.customer,
    );
  }

  factory LpLoadItem.fromJson(Map<String, dynamic> json){
    return LpLoadItem(
      loadId: json["loadId"] ?? "",
      loadSeriesId: json["loadSeriesId"] ?? "",
      laneId: json["laneId"] ?? 0,
      rateId: json["rateId"] ?? 0,
      customerId: json["customerId"] ?? "",
      commodityId: json["commodityId"] ?? 0,
      pickUpDateTime: DateTime.tryParse(json["pickUpDateTime"] ?? ""),
      truckTypeId: json["truckTypeId"] ?? 0,
      consignmentWeight: json["consignmentWeight"] ?? 0,
      notes: json["notes"] ?? "",
      loadStatusId: json["loadStatusId"] ?? 0,
      expectedDeliveryDateTime: DateTime.tryParse(json["expectedDeliveryDateTime"] ?? ""),
      isAgreed: json["isAgreed"] ?? 0,
      acceptedBy: json["acceptedBy"],
      createdPlatform: json["createdPlatform"] ?? 0,
      updatedPlatform: json["updatedPlatform"] ?? 0,
      status: json["status"] ?? 0,
      matchingStartDate: DateTime.tryParse(json["matchingStartDate"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      commodity: json["commodity"] == null ? null : Commodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
      loadRoute: json["loadRoute"] == null ? null : LoadRoute.fromJson(json["loadRoute"]),
      loadStatusDetails: json["loadStatusDetails"] == null ? null : LoadStatusDetails.fromJson(json["loadStatusDetails"]),
      loadStatusLogs: json["loadStatusLogs"] == null ? [] : List<LoadStatusLog>.from(json["loadStatusLogs"]!.map((x) => LoadStatusLog.fromJson(x))),
      loadPrice: json["loadPrice"] == null ? null : LoadPrice.fromJson(json["loadPrice"]),
      customer: json["customer"] == null ? null : DatumCustomer.fromJson(json["customer"]),
    );
  }

}

class Commodity {
  Commodity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String name;
  final dynamic description;
  final dynamic iconUrl;
  final int status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  Commodity copyWith({
    int? id,
    String? name,
    dynamic? description,
    dynamic? iconUrl,
    int? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return Commodity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Commodity.fromJson(Map<String, dynamic> json){
    return Commodity(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"],
      iconUrl: json["iconUrl"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class DatumCustomer {
  DatumCustomer({
    required this.customer,
    required this.address,
    required this.bankDetails,
    required this.kycDocs,
    required this.vehicles,
  });

  final CustomerCustomer? customer;
  final Address? address;
  final BankDetails? bankDetails;
  final List<KycDoc> kycDocs;
  final List<Vehicle> vehicles;

  DatumCustomer copyWith({
    CustomerCustomer? customer,
    Address? address,
    BankDetails? bankDetails,
    List<KycDoc>? kycDocs,
    List<Vehicle>? vehicles,
  }) {
    return DatumCustomer(
      customer: customer ?? this.customer,
      address: address ?? this.address,
      bankDetails: bankDetails ?? this.bankDetails,
      kycDocs: kycDocs ?? this.kycDocs,
      vehicles: vehicles ?? this.vehicles,
    );
  }

  factory DatumCustomer.fromJson(Map<String, dynamic> json){
    return DatumCustomer(
      customer: json["customer"] == null ? null : CustomerCustomer.fromJson(json["customer"]),
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
  final String addressName;
  final String fullAddress;
  final String city;
  final String state;
  final String pincode;
  final dynamic status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Address copyWith({
    String? customersAddressId,
    String? customerId,
    String? addressName,
    String? fullAddress,
    String? city,
    String? state,
    String? pincode,
    dynamic? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
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
      addressName: json["addressName"] ?? "",
      fullAddress: json["fullAddress"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
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
  final String bankAccount;
  final String bankName;
  final String branchName;
  final String ifscCode;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  BankDetails copyWith({
    String? bankDetailsId,
    String? customerId,
    String? bankAccount,
    String? bankName,
    String? branchName,
    String? ifscCode,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
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
      bankAccount: json["bankAccount"] ?? "",
      bankName: json["bankName"] ?? "",
      branchName: json["branchName"] ?? "",
      ifscCode: json["ifscCode"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class CustomerCustomer {
  CustomerCustomer({
    required this.customerId,
    required this.customerName,
    required this.mobileNumber,
    required this.companyTypeId,
    required this.emailId,
    required this.blueId,
    required this.kycRejectReason,
    required this.password,
    required this.companyName,
    required this.otp,
    required this.ememoOtp,
    required this.otpAttempt,
    required this.isKyc,
    required this.preferredLanes,
    required this.roleId,
    required this.tempFlg,
    required this.status,
    required this.isLogin,
    required this.kycPendingDate,
    required this.createdAt,
    required this.deletedAt,
    required this.kycType,
    required this.companyType,
  });

  final String customerId;
  final String customerName;
  final String mobileNumber;
  final int companyTypeId;
  final String emailId;
  final String blueId;
  final dynamic kycRejectReason;
  final String password;
  final String companyName;
  final String otp;
  final dynamic ememoOtp;
  final String otpAttempt;
  final int isKyc;
  final dynamic preferredLanes;
  final int roleId;
  final bool tempFlg;
  final int status;
  final bool isLogin;
  final dynamic kycPendingDate;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final dynamic kycType;
  final CompanyType? companyType;

  CustomerCustomer copyWith({
    String? customerId,
    String? customerName,
    String? mobileNumber,
    int? companyTypeId,
    String? emailId,
    String? blueId,
    dynamic? kycRejectReason,
    String? password,
    String? companyName,
    String? otp,
    dynamic? ememoOtp,
    String? otpAttempt,
    int? isKyc,
    dynamic? preferredLanes,
    int? roleId,
    bool? tempFlg,
    int? status,
    bool? isLogin,
    dynamic? kycPendingDate,
    DateTime? createdAt,
    dynamic? deletedAt,
    dynamic? kycType,
    CompanyType? companyType,
  }) {
    return CustomerCustomer(
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      companyTypeId: companyTypeId ?? this.companyTypeId,
      emailId: emailId ?? this.emailId,
      blueId: blueId ?? this.blueId,
      kycRejectReason: kycRejectReason ?? this.kycRejectReason,
      password: password ?? this.password,
      companyName: companyName ?? this.companyName,
      otp: otp ?? this.otp,
      ememoOtp: ememoOtp ?? this.ememoOtp,
      otpAttempt: otpAttempt ?? this.otpAttempt,
      isKyc: isKyc ?? this.isKyc,
      preferredLanes: preferredLanes ?? this.preferredLanes,
      roleId: roleId ?? this.roleId,
      tempFlg: tempFlg ?? this.tempFlg,
      status: status ?? this.status,
      isLogin: isLogin ?? this.isLogin,
      kycPendingDate: kycPendingDate ?? this.kycPendingDate,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      kycType: kycType ?? this.kycType,
      companyType: companyType ?? this.companyType,
    );
  }

  factory CustomerCustomer.fromJson(Map<String, dynamic> json){
    return CustomerCustomer(
      customerId: json["customer_id"] ?? "",
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      companyTypeId: json["companyTypeId"] ?? 0,
      emailId: json["emailId"] ?? "",
      blueId: json["blueId"] ?? "",
      kycRejectReason: json["kycRejectReason"],
      password: json["password"] ?? "",
      companyName: json["companyName"] ?? "",
      otp: json["otp"] ?? "",
      ememoOtp: json["ememo_otp"],
      otpAttempt: json["otpAttempt"] ?? "",
      isKyc: json["isKyc"] ?? 0,
      preferredLanes: json["preferredLanes"],
      roleId: json["roleId"] ?? 0,
      tempFlg: json["tempFlg"] ?? false,
      status: json["status"] ?? 0,
      isLogin: json["isLogin"] ?? false,
      kycPendingDate: json["kycPendingDate"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      kycType: json["kycType"],
      companyType: json["companyType"] == null ? null : CompanyType.fromJson(json["companyType"]),
    );
  }

}

class CompanyType {
  CompanyType({
    required this.id,
    required this.companyType,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String companyType;
  final int status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  CompanyType copyWith({
    int? id,
    String? companyType,
    int? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return CompanyType(
      id: id ?? this.id,
      companyType: companyType ?? this.companyType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory CompanyType.fromJson(Map<String, dynamic> json){
    return CompanyType(
      id: json["id"] ?? 0,
      companyType: json["companyType"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
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
  final String uploadRc;
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
    dynamic? docType,
    dynamic? docNo,
    dynamic? docLink,
    String? uploadRc,
    bool? isApproved,
    dynamic? approvedBy,
    dynamic? approvedAt,
    int? status,
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
    bool? isAadhar,
    bool? isGstin,
    bool? isTan,
    bool? isPan,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
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
      uploadRc: json["upload_rc"] ?? "",
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
  final List<int> truckType;
  final int ownedTrucks;
  final int attachedTrucks;
  final List<int> preferredLanes;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Vehicle copyWith({
    String? vpVehiclesId,
    String? customerId,
    List<int>? truckType,
    int? ownedTrucks,
    int? attachedTrucks,
    List<int>? preferredLanes,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
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
      truckType: json["truckType"] == null ? [] : List<int>.from(json["truckType"]!.map((x) => x)),
      ownedTrucks: json["ownedTrucks"] ?? 0,
      attachedTrucks: json["attachedTrucks"] ?? 0,
      preferredLanes: json["preferredLanes"] == null ? [] : List<int>.from(json["preferredLanes"]!.map((x) => x)),
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
    );
  }

}

class LoadPrice {
  LoadPrice({
    required this.loadPriceId,
    required this.loadId,
    required this.rate,
    required this.maxRate,
    required this.vpRate,
    required this.vpMaxRate,
    required this.handlingCharges,
    required this.status,
    required this.createAt,
    required this.updateAt,
    required this.deletedAt,
  });

  final String loadPriceId;
  final String loadId;
  final int rate;
  final int maxRate;
  final int vpRate;
  final int vpMaxRate;
  final int handlingCharges;
  final int status;
  final DateTime? createAt;
  final DateTime? updateAt;
  final dynamic deletedAt;

  LoadPrice copyWith({
    String? loadPriceId,
    String? loadId,
    int? rate,
    int? maxRate,
    int? vpRate,
    int? vpMaxRate,
    int? handlingCharges,
    int? status,
    DateTime? createAt,
    DateTime? updateAt,
    dynamic? deletedAt,
  }) {
    return LoadPrice(
      loadPriceId: loadPriceId ?? this.loadPriceId,
      loadId: loadId ?? this.loadId,
      rate: rate ?? this.rate,
      maxRate: maxRate ?? this.maxRate,
      vpRate: vpRate ?? this.vpRate,
      vpMaxRate: vpMaxRate ?? this.vpMaxRate,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      status: status ?? this.status,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadPrice.fromJson(Map<String, dynamic> json){
    return LoadPrice(
      loadPriceId: json["loadPriceId"] ?? "",
      loadId: json["loadId"] ?? "",
      rate: json["rate"] ?? 0,
      maxRate: json["maxRate"] ?? 0,
      vpRate: json["vpRate"] ?? 0,
      vpMaxRate: json["vpMaxRate"] ?? 0,
      handlingCharges: json["handlingCharges"] ?? 0,
      status: json["status"] ?? 0,
      createAt: DateTime.tryParse(json["createAt"] ?? ""),
      updateAt: DateTime.tryParse(json["updateAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class LoadRoute {
  LoadRoute({
    required this.loadRouteId,
    required this.loadId,
    required this.pickUpAddr,
    required this.pickUpLocation,
    required this.pickUpLatlon,
    required this.dropAddr,
    required this.dropLocation,
    required this.dropLatlon,
    required this.pickUpWholeAddr,
    required this.dropWholeAddr,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String loadRouteId;
  final String loadId;
  final String pickUpAddr;
  final String pickUpLocation;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropLocation;
  final String dropLatlon;
  final String pickUpWholeAddr;
  final String dropWholeAddr;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  LoadRoute copyWith({
    String? loadRouteId,
    String? loadId,
    String? pickUpAddr,
    String? pickUpLocation,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropLocation,
    String? dropLatlon,
    String? pickUpWholeAddr,
    String? dropWholeAddr,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
  }) {
    return LoadRoute(
      loadRouteId: loadRouteId ?? this.loadRouteId,
      loadId: loadId ?? this.loadId,
      pickUpAddr: pickUpAddr ?? this.pickUpAddr,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      pickUpLatlon: pickUpLatlon ?? this.pickUpLatlon,
      dropAddr: dropAddr ?? this.dropAddr,
      dropLocation: dropLocation ?? this.dropLocation,
      dropLatlon: dropLatlon ?? this.dropLatlon,
      pickUpWholeAddr: pickUpWholeAddr ?? this.pickUpWholeAddr,
      dropWholeAddr: dropWholeAddr ?? this.dropWholeAddr,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadRoute.fromJson(Map<String, dynamic> json){
    return LoadRoute(
      loadRouteId: json["loadRouteId"] ?? "",
      loadId: json["loadId"] ?? "",
      pickUpAddr: json["pickUpAddr"] ?? "",
      pickUpLocation: json["pickUpLocation"] ?? "",
      pickUpLatlon: json["pickUpLatlon"] ?? "",
      dropAddr: json["dropAddr"] ?? "",
      dropLocation: json["dropLocation"] ?? "",
      dropLatlon: json["dropLatlon"] ?? "",
      pickUpWholeAddr: json["pickUpWholeAddr"] ?? "",
      dropWholeAddr: json["dropWholeAddr"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class LoadStatusDetails {
  LoadStatusDetails({
    required this.id,
    required this.loadStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int id;
  final String loadStatus;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  LoadStatusDetails copyWith({
    int? id,
    String? loadStatus,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
  }) {
    return LoadStatusDetails(
      id: id ?? this.id,
      loadStatus: loadStatus ?? this.loadStatus,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadStatusDetails.fromJson(Map<String, dynamic> json){
    return LoadStatusDetails(
      id: json["id"] ?? 0,
      loadStatus: json["loadStatus"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class LoadStatusLog {
  LoadStatusLog({
    required this.loadStatusLogId,
    required this.loadStatus,
    required this.loadId,
    required this.changedBy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String loadStatusLogId;
  final int loadStatus;
  final String loadId;
  final String changedBy;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  LoadStatusLog copyWith({
    String? loadStatusLogId,
    int? loadStatus,
    String? loadId,
    String? changedBy,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
  }) {
    return LoadStatusLog(
      loadStatusLogId: loadStatusLogId ?? this.loadStatusLogId,
      loadStatus: loadStatus ?? this.loadStatus,
      loadId: loadId ?? this.loadId,
      changedBy: changedBy ?? this.changedBy,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadStatusLog.fromJson(Map<String, dynamic> json){
    return LoadStatusLog(
      loadStatusLogId: json["loadStatusLogId"] ?? "",
      loadStatus: json["loadStatus"] ?? 0,
      loadId: json["loadId"] ?? "",
      changedBy: json["changedBy"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class TruckType {
  TruckType({
    required this.id,
    required this.type,
    required this.subType,
    required this.iconUrl,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String type;
  final String subType;
  final dynamic iconUrl;
  final int status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  TruckType copyWith({
    int? id,
    String? type,
    String? subType,
    dynamic? iconUrl,
    int? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return TruckType(
      id: id ?? this.id,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory TruckType.fromJson(Map<String, dynamic> json){
    return TruckType(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
      iconUrl: json["iconUrl"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class PageMeta {
  PageMeta({
    required this.page,
    required this.pageCount,
    required this.nextPage,
    required this.pageSize,
    required this.total,
  });

  final int page;
  final int pageCount;
  final dynamic nextPage;
  final int pageSize;
  final int total;

  PageMeta copyWith({
    int? page,
    int? pageCount,
    dynamic? nextPage,
    int? pageSize,
    int? total,
  }) {
    return PageMeta(
      page: page ?? this.page,
      pageCount: pageCount ?? this.pageCount,
      nextPage: nextPage ?? this.nextPage,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
    );
  }

  factory PageMeta.fromJson(Map<String, dynamic> json){
    return PageMeta(
      page: int.tryParse(json["page"].toString()) ?? 0,
      pageCount: json["pageCount"] ?? 0,
      nextPage: json["nextPage"],
      pageSize: json["pageSize"] ?? 0,
      total: json["total"] ?? 0,
    );
  }

}
