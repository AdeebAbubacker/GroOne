class LpLoadResponse {
  LpLoadResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final LpLoadData? data;

  LpLoadResponse copyWith({
    bool? success,
    String? message,
    LpLoadData? data,
  }) {
    return LpLoadResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LpLoadResponse.fromJson(Map<String, dynamic> json){
    return LpLoadResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : LpLoadData.fromJson(json["data"]),
    );
  }

}

class LpLoadData {
  LpLoadData({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  final List<LpLoadItem> data;
  final num total;
  final PageMeta? pageMeta;

  LpLoadData copyWith({
    List<LpLoadItem>? data,
    num? total,
    PageMeta? pageMeta,
  }) {
    return LpLoadData(
      data: data ?? this.data,
      total: total ?? this.total,
      pageMeta: pageMeta ?? this.pageMeta,
    );
  }

  factory LpLoadData.fromJson(Map<String, dynamic> json){
    return LpLoadData(
      data: json["data"] == null ? [] : List<LpLoadItem>.from(json["data"]!.map((x) => LpLoadItem.fromJson(x))),
      total: json["total"] ?? 0,
      pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
    );
  }

}

class LpLoadItem {
  LpLoadItem({
    required this.id,
    required this.loadId,
    required this.laneId,
    required this.rateId,
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.pickUpAddr,
    required this.pickUpWholeAddr,
    required this.pickUpLocation,
    required this.assignStatus,
    required this.pickUpLatlon,
    required this.dropAddr,
    required this.dropWholeAddr,
    required this.dropLocation,
    required this.dropLatlon,
    required this.dueDate,
    required this.consignmentWeight,
    required this.isAgreed,
    required this.notes,
    required this.rate,
    required this.maxRate,
    required this.status,
    required this.loadStatus,
    required this.vehicleLength,
    required this.pickUpDateTime,
    required this.expectedDeliveryDateTime,
    required this.handlingCharges,
    required this.acceptedBy,
    required this.matchingStartDate,
    required this.agreedPrice,
    required this.acceptedVehicleId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.commodity,
    required this.truckType,
    required this.customer,
    required this.acceptedCustomer,
    required this.customerDetail,
    required this.loadStatusDetails,
    required this.acceptedVehicle,
    required this.vehicleProvider,
    required this.consigneeDetails,
    required this.timeline,


    required this.vpRate,
  });


  /// regarding rate master
  final String? pickUpWholeAddr;
  final String? dropWholeAddr;
  final String? vpRate;

  final int id;
  final String loadId;
  final num laneId;
  final num rateId;
  final num customerId;
  final num commodityId;
  final num truckTypeId;
  final String pickUpAddr;
  final String pickUpLocation;
  final num assignStatus;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropLocation;
  final String dropLatlon;
  final DateTime? dueDate;
  final num consignmentWeight;
  final int isAgreed;
  final String notes;
  final String rate;
  final String? maxRate;
  final num status;
  final num loadStatus;
  final String vehicleLength;
  final DateTime? pickUpDateTime;
  final DateTime? expectedDeliveryDateTime;
  final num handlingCharges;
  final num acceptedBy;
  final DateTime? matchingStartDate;
  final dynamic agreedPrice;
  final num acceptedVehicleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final DatumCommodity? commodity;
  final DatumTruckType? truckType;
  final Customer? customer;
  final AcceptedCustomerClass? acceptedCustomer;
  final CustomerDetail? customerDetail;
  final LoadStatusDetails? loadStatusDetails;
  final AcceptedVehicle? acceptedVehicle;
  final VehicleProvider? vehicleProvider;
  final ConsigneeDetails? consigneeDetails;
  final List<Timeline> timeline;




  LpLoadItem copyWith({
    int? id,
    String? loadId,
    num? laneId,
    num? rateId,
    num? customerId,
    num? commodityId,
    num? truckTypeId,
    String? pickUpAddr,
    String? pickUpWholeAddr,
    String? pickUpLocation,
    num? assignStatus,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropWholeAddr,
    String? dropLocation,
    String? dropLatlon,
    DateTime? dueDate,
    num? consignmentWeight,
    int? isAgreed,
    String? notes,
    String? rate,
    String? maxRate,
    num? status,
    num? loadStatus,
    String? vehicleLength,
    DateTime? pickUpDateTime,
    DateTime? expectedDeliveryDateTime,
    num? handlingCharges,
    num? acceptedBy,
    DateTime? matchingStartDate,
    dynamic? agreedPrice,
    num? acceptedVehicleId,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
    DatumCommodity? commodity,
    DatumTruckType? truckType,
    Customer? customer,
    AcceptedCustomerClass? acceptedCustomer,
    CustomerDetail? customerDetail,
    LoadStatusDetails? loadStatusDetails,
    AcceptedVehicle? acceptedVehicle,
    VehicleProvider? vehicleProvider,
    ConsigneeDetails? consigneeDetails,
    List<Timeline>? timeline,
    String? vpRate,
  }) {
    return LpLoadItem(
      pickUpWholeAddr:pickUpWholeAddr??this.pickUpWholeAddr ,
      dropWholeAddr:dropWholeAddr??this.dropWholeAddr ,
      vpRate:vpRate??this.vpRate ,
      id: id ?? this.id,
      loadId: loadId ?? this.loadId,
      laneId: laneId ?? this.laneId,
      rateId: rateId ?? this.rateId,
      customerId: customerId ?? this.customerId,
      commodityId: commodityId ?? this.commodityId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      pickUpAddr: pickUpAddr ?? this.pickUpAddr,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      assignStatus: assignStatus ?? this.assignStatus,
      pickUpLatlon: pickUpLatlon ?? this.pickUpLatlon,
      dropAddr: dropAddr ?? this.dropAddr,
      dropLocation: dropLocation ?? this.dropLocation,
      dropLatlon: dropLatlon ?? this.dropLatlon,
      dueDate: dueDate ?? this.dueDate,
      consignmentWeight: consignmentWeight ?? this.consignmentWeight,
      isAgreed: isAgreed ?? this.isAgreed,
      notes: notes ?? this.notes,
      rate: rate ?? this.rate,
      maxRate: maxRate ?? this.maxRate,
      status: status ?? this.status,
      loadStatus: loadStatus ?? this.loadStatus,
      vehicleLength: vehicleLength ?? this.vehicleLength,
      pickUpDateTime: pickUpDateTime ?? this.pickUpDateTime,
      expectedDeliveryDateTime: expectedDeliveryDateTime ?? this.expectedDeliveryDateTime,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      matchingStartDate: matchingStartDate ?? this.matchingStartDate,
      agreedPrice: agreedPrice ?? this.agreedPrice,
      acceptedVehicleId: acceptedVehicleId ?? this.acceptedVehicleId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      customer: customer ?? this.customer,
      loadStatusDetails: loadStatusDetails ?? this.loadStatusDetails,
      acceptedCustomer: acceptedCustomer ?? this.acceptedCustomer,
      customerDetail: customerDetail ?? this.customerDetail,
      acceptedVehicle: acceptedVehicle ?? this.acceptedVehicle,
      vehicleProvider: vehicleProvider ?? this.vehicleProvider,
      consigneeDetails: consigneeDetails ?? this.consigneeDetails,
      timeline: timeline ?? this.timeline,
    );
  }

  factory LpLoadItem.fromJson(Map<String, dynamic> json){
    return LpLoadItem(
      vpRate:json['vpRate']?.toString()??"" ,
      dropWholeAddr: json['dropWholeAddr']?.toString()??"",
      pickUpWholeAddr: json['pickUpWholeAddr']?.toString()??"",
      id: json["id"] ?? 0,
      loadId: json["loadId"] ?? "",
      laneId: json["laneId"] ?? 0,
      rateId: json["rateId"] ?? 0,
      customerId: json["customerId"] ?? 0,
      commodityId: json["commodityId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      pickUpAddr: json["pickUpAddr"] ?? "",
      pickUpLocation: json["pickUpLocation"] ?? "",
      assignStatus: json["assignStatus"] ?? 0,
      pickUpLatlon: json["pickUpLatlon"] ?? "",
      dropAddr: json["dropAddr"] ?? "",
      dropLocation: json["dropLocation"] ?? "",
      dropLatlon: json["dropLatlon"] ?? "",
      dueDate: DateTime.tryParse(json["dueDate"] ?? ""),
      consignmentWeight: json["consignmentWeight"] ?? 0,
      isAgreed: json["isAgreed"] ?? 0,
      notes: json["notes"] ?? "",
      rate: json["rate"] ?? "",
      maxRate: json["maxRate"],
      status: json["status"] ?? 0,
      loadStatus: json["loadStatus"] ?? 0,
      vehicleLength: json["vehicleLength"] ?? "",
      pickUpDateTime: DateTime.tryParse(json["pickUpDateTime"] ?? ""),
      expectedDeliveryDateTime: DateTime.tryParse(json["expectedDeliveryDateTime"] ?? ""),
      handlingCharges: json["handlingCharges"] ?? 0,
      acceptedBy: json["acceptedBy"] ?? 0,
      matchingStartDate: DateTime.tryParse(json["matchingStartDate"] ?? ""),
      agreedPrice: json["agreedPrice"],
      acceptedVehicleId: json["acceptedVehicleId"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      commodity: json["commodity"] == null ? null : DatumCommodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : DatumTruckType.fromJson(json["truckType"]),
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      acceptedCustomer: json["acceptedCustomer"] == null ? null : AcceptedCustomerClass.fromJson(json["acceptedCustomer"]),
      customerDetail: json["customerDetail"] == null ? null : CustomerDetail.fromJson(json["customerDetail"]),
      loadStatusDetails: json["loadStatusDetails"] == null ? null : LoadStatusDetails.fromJson(json["loadStatusDetails"]),
      acceptedVehicle: json["acceptedVehicle"] == null ? null : AcceptedVehicle.fromJson(json["acceptedVehicle"]),
      vehicleProvider: json["vehicleProvider"] == null ? null : VehicleProvider.fromJson(json["vehicleProvider"]),
      consigneeDetails: json["consigneeDetails"] == null ? null : ConsigneeDetails.fromJson(json["consigneeDetails"]),
      timeline: json["timeline"] == null ? [] : List<Timeline>.from(json["timeline"]!.map((x) => Timeline.fromJson(x))),
    );
  }

}

class Customer {
  Customer({
    required this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.emailId,
    required this.kycPendingDate,
    required this.isKyc,
  });

  final int id;
  final String customerName;
  final String mobileNumber;
  final String emailId;
  final DateTime? kycPendingDate;
  final num isKyc;

  Customer copyWith({
    int? id,
    String? customerName,
    String? mobileNumber,
    String? emailId,
    DateTime? kycPendingDate,
    num? isKyc,
  }) {
    return Customer(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailId: emailId ?? this.emailId,
      kycPendingDate: kycPendingDate ?? this.kycPendingDate,
      isKyc: isKyc ?? this.isKyc,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      id: json["id"] ?? 0,
      customerName: json["customerName"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      emailId: json["emailId"] ?? "",
      kycPendingDate: DateTime.tryParse(json["kycPendingDate"] ?? ""),
      isKyc: json["isKyc"] ?? 0,
    );
  }

}


class AcceptedCustomerClass {
  AcceptedCustomerClass({
    required this.id,
    required this.customerName,
  });

  final int id;
  final String customerName;

  AcceptedCustomerClass copyWith({
    int? id,
    String? customerName,
  }) {
    return AcceptedCustomerClass(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
    );
  }

  factory AcceptedCustomerClass.fromJson(Map<String, dynamic> json){
    return AcceptedCustomerClass(
      id: json["id"] ?? 0,
      customerName: json["customerName"] ?? "",
    );
  }

}

class AcceptedVehicle {
  AcceptedVehicle({
    required this.id,
    required this.customerId,
    required this.vehicleNumber,
    required this.vehicleTypeId,
    required this.commodityId,
    required this.rcNumber,
    required this.rcDocLink,
    required this.capacity,
    required this.assignStatus,
    required this.status,
    required this.consigneeName,
    required this.consigneeContact,
    required this.consigneeEmail,
    required this.driverId,
    required this.acceptedVpPrice,
    required this.acceptedVpAdvance,
    required this.vpFeedback,
    required this.createdAt,
    required this.deletedAt,
    required this.customer,
    required this.truckType,
    required this.driver,
  });

  final int id;
  final num customerId;
  final String vehicleNumber;
  final num vehicleTypeId;
  final dynamic commodityId;
  final dynamic rcNumber;
  final dynamic rcDocLink;
  final dynamic capacity;
  final num assignStatus;
  final num status;
  final dynamic consigneeName;
  final dynamic consigneeContact;
  final dynamic consigneeEmail;
  final dynamic driverId;
  final dynamic acceptedVpPrice;
  final dynamic acceptedVpAdvance;
  final dynamic vpFeedback;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final AcceptedVehicleCustomer? customer;
  final AcceptedVehicleTruckType? truckType;
  final dynamic driver;

  AcceptedVehicle copyWith({
    int? id,
    num? customerId,
    String? vehicleNumber,
    num? vehicleTypeId,
    dynamic? commodityId,
    dynamic? rcNumber,
    dynamic? rcDocLink,
    dynamic? capacity,
    num? assignStatus,
    num? status,
    dynamic? consigneeName,
    dynamic? consigneeContact,
    dynamic? consigneeEmail,
    dynamic? driverId,
    dynamic? acceptedVpPrice,
    dynamic? acceptedVpAdvance,
    dynamic? vpFeedback,
    DateTime? createdAt,
    dynamic? deletedAt,
    AcceptedVehicleCustomer? customer,
    AcceptedVehicleTruckType? truckType,
    dynamic? driver,
  }) {
    return AcceptedVehicle(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleTypeId: vehicleTypeId ?? this.vehicleTypeId,
      commodityId: commodityId ?? this.commodityId,
      rcNumber: rcNumber ?? this.rcNumber,
      rcDocLink: rcDocLink ?? this.rcDocLink,
      capacity: capacity ?? this.capacity,
      assignStatus: assignStatus ?? this.assignStatus,
      status: status ?? this.status,
      consigneeName: consigneeName ?? this.consigneeName,
      consigneeContact: consigneeContact ?? this.consigneeContact,
      consigneeEmail: consigneeEmail ?? this.consigneeEmail,
      driverId: driverId ?? this.driverId,
      acceptedVpPrice: acceptedVpPrice ?? this.acceptedVpPrice,
      acceptedVpAdvance: acceptedVpAdvance ?? this.acceptedVpAdvance,
      vpFeedback: vpFeedback ?? this.vpFeedback,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      customer: customer ?? this.customer,
      truckType: truckType ?? this.truckType,
      driver: driver ?? this.driver,
    );
  }

  factory AcceptedVehicle.fromJson(Map<String, dynamic> json){
    return AcceptedVehicle(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      vehicleNumber: json["vehicleNumber"] ?? "",
      vehicleTypeId: json["vehicleTypeId"] ?? 0,
      commodityId: json["commodityId"],
      rcNumber: json["rcNumber"],
      rcDocLink: json["rcDocLink"],
      capacity: json["capacity"],
      assignStatus: json["assignStatus"] ?? 0,
      status: json["status"] ?? 0,
      consigneeName: json["consigneeName"],
      consigneeContact: json["consigneeContact"],
      consigneeEmail: json["consigneeEmail"],
      driverId: json["driverId"],
      acceptedVpPrice: json["acceptedVpPrice"],
      acceptedVpAdvance: json["acceptedVpAdvance"],
      vpFeedback: json["vpFeedback"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      customer: json["customer"] == null ? null : AcceptedVehicleCustomer.fromJson(json["customer"]),
      truckType: json["truckType"] == null ? null : AcceptedVehicleTruckType.fromJson(json["truckType"]),
      driver: json["driver"],
    );
  }

}

class AcceptedVehicleCustomer {
  AcceptedVehicleCustomer({
    required this.id,
    required this.customerName,
    required this.ememoOtp,
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
    required this.customerDetails,
  });

  final int id;
  final String customerName;
  final dynamic ememoOtp;
  final String mobileNumber;
  final String emailId;
  final String blueId;
  final dynamic password;
  final num otp;
  final num otpAttempt;
  final num isKyc;
  final num roleId;
  final bool tempFlg;
  final num status;
  final bool isLogin;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final CustomerDetail? customerDetails;

  AcceptedVehicleCustomer copyWith({
    int? id,
    String? customerName,
    dynamic? ememoOtp,
    String? mobileNumber,
    String? emailId,
    String? blueId,
    dynamic? password,
    num? otp,
    num? otpAttempt,
    num? isKyc,
    num? roleId,
    bool? tempFlg,
    num? status,
    bool? isLogin,
    DateTime? createdAt,
    dynamic? deletedAt,
    CustomerDetail? customerDetails,
  }) {
    return AcceptedVehicleCustomer(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      ememoOtp: ememoOtp ?? this.ememoOtp,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailId: emailId ?? this.emailId,
      blueId: blueId ?? this.blueId,
      password: password ?? this.password,
      otp: otp ?? this.otp,
      otpAttempt: otpAttempt ?? this.otpAttempt,
      isKyc: isKyc ?? this.isKyc,
      roleId: roleId ?? this.roleId,
      tempFlg: tempFlg ?? this.tempFlg,
      status: status ?? this.status,
      isLogin: isLogin ?? this.isLogin,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      customerDetails: customerDetails ?? this.customerDetails,
    );
  }

  factory AcceptedVehicleCustomer.fromJson(Map<String, dynamic> json){
    return AcceptedVehicleCustomer(
      id: json["id"] ?? 0,
      customerName: json["customerName"] ?? "",
      ememoOtp: json["ememo_otp"],
      mobileNumber: json["mobileNumber"] ?? "",
      emailId: json["emailId"] ?? "",
      blueId: json["blueId"] ?? "",
      password: json["password"],
      otp: json["otp"] ?? 0,
      otpAttempt: json["otpAttempt"] ?? 0,
      isKyc: json["isKyc"] ?? 0,
      roleId: json["roleId"] ?? 0,
      tempFlg: json["tempFlg"] ?? false,
      status: json["status"] ?? 0,
      isLogin: json["isLogin"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      customerDetails: json["customerDetails"] == null ? null : CustomerDetail.fromJson(json["customerDetails"]),
    );
  }

}

class CustomerDetail {
  CustomerDetail({
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
    required this.profileImageUrl,
    required this.location,
    required this.createdAt,
    required this.deletedAt,
    required this.customerDetailCustomerId,
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
  final List<num> truckType;
  final num ownedTrucks;
  final num attachedTrucks;
  final List<num> preferredLanes;
  final String uploadRc;
  final String pincode;
  final String address1;
  final String address2;
  final String address3;
  final dynamic profileImageUrl;
  final dynamic location;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final int customerDetailCustomerId;

  CustomerDetail copyWith({
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
    List<num>? truckType,
    num? ownedTrucks,
    num? attachedTrucks,
    List<num>? preferredLanes,
    String? uploadRc,
    String? pincode,
    String? address1,
    String? address2,
    String? address3,
    dynamic? profileImageUrl,
    dynamic? location,
    DateTime? createdAt,
    dynamic? deletedAt,
    int? customerDetailCustomerId,
  }) {
    return CustomerDetail(
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
      address2: address2 ?? this.address2,
      address3: address3 ?? this.address3,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      customerDetailCustomerId: customerDetailCustomerId ?? this.customerDetailCustomerId,
    );
  }

  factory CustomerDetail.fromJson(Map<String, dynamic> json){
    return CustomerDetail(
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
      truckType: json["truckType"] == null ? [] : List<num>.from(json["truckType"]!.map((x) => x)),
      ownedTrucks: json["ownedTrucks"] ?? 0,
      attachedTrucks: json["attachedTrucks"] ?? 0,
      preferredLanes: json["preferredLanes"] == null ? [] : List<num>.from(json["preferredLanes"]!.map((x) => x)),
      uploadRc: json["uploadRc"] ?? "",
      pincode: json["pincode"] ?? "",
      address1: json["address1"] ?? "",
      address2: json["address2"] ?? "",
      address3: json["address3"] ?? "",
      profileImageUrl: json["profileImageUrl"],
      location: json["location"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      customerDetailCustomerId: json["customer_id"] ?? 0,
    );
  }

}

class LoadStatusDetails {
  LoadStatusDetails({
    required this.id,
    required this.loadType,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String loadType;
  final num status;
  final dynamic createdAt;
  final dynamic deletedAt;

  LoadStatusDetails copyWith({
    int? id,
    String? loadType,
    num? status,
    dynamic? createdAt,
    dynamic? deletedAt,
  }) {
    return LoadStatusDetails(
      id: id ?? this.id,
      loadType: loadType ?? this.loadType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadStatusDetails.fromJson(Map<String, dynamic> json){
    return LoadStatusDetails(
      id: json["id"] ?? 0,
      loadType: json["loadType"] ?? "",
      status: json["status"] ?? 0,
      createdAt: json["createdAt"],
      deletedAt: json["deletedAt"],
    );
  }

}

class AcceptedVehicleTruckType {
  AcceptedVehicleTruckType({
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
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  AcceptedVehicleTruckType copyWith({
    int? id,
    String? type,
    String? subType,
    dynamic? iconUrl,
    num? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return AcceptedVehicleTruckType(
      id: id ?? this.id,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory AcceptedVehicleTruckType.fromJson(Map<String, dynamic> json){
    return AcceptedVehicleTruckType(
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

class DatumCommodity {
  DatumCommodity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  DatumCommodity copyWith({
    int? id,
    String? name,
  }) {
    return DatumCommodity(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory DatumCommodity.fromJson(Map<String, dynamic> json){
    return DatumCommodity(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
    );
  }

}

class ConsigneeDetails {
  ConsigneeDetails({
    required this.name,
    required this.contact,
    required this.email,
  });

  final dynamic name;
  final dynamic contact;
  final dynamic email;

  ConsigneeDetails copyWith({
    dynamic? name,
    dynamic? contact,
    dynamic? email,
  }) {
    return ConsigneeDetails(
      name: name ?? this.name,
      contact: contact ?? this.contact,
      email: email ?? this.email,
    );
  }

  factory ConsigneeDetails.fromJson(Map<String, dynamic> json){
    return ConsigneeDetails(
      name: json["name"],
      contact: json["contact"],
      email: json["email"],
    );
  }

}

class Timeline {
  Timeline({
    required this.id,
    required this.label,
    required this.status,
    required this.timestamp,
    required this.commodity,
    required this.truckType,
    required this.loadProvider,
  });

  final int id;
  final String label;
  final String status;
  final DateTime? timestamp;
  final TruckTypeClass? commodity;
  final TruckTypeClass? truckType;
  final dynamic loadProvider;

  Timeline copyWith({
    int? id,
    String? label,
    String? status,
    DateTime? timestamp,
    TruckTypeClass? commodity,
    TruckTypeClass? truckType,
    dynamic? loadProvider,
  }) {
    return Timeline(
      id: id ?? this.id,
      label: label ?? this.label,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      loadProvider: loadProvider ?? this.loadProvider,
    );
  }

  factory Timeline.fromJson(Map<String, dynamic> json){
    return Timeline(
      id: json["id"] ?? 0,
      label: json["label"] ?? "",
      status: json["status"] ?? "",
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
      commodity: json["commodity"] == null ? null : TruckTypeClass.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : TruckTypeClass.fromJson(json["truckType"]),
      loadProvider: json["loadProvider"],
    );
  }

}

class TruckTypeClass {
  TruckTypeClass({
    required this.id,
  });

  final int id;

  TruckTypeClass copyWith({
    int? id,
  }) {
    return TruckTypeClass(
      id: id ?? this.id,
    );
  }

  factory TruckTypeClass.fromJson(Map<String, dynamic> json){
    return TruckTypeClass(
      id: json["id"] ?? 0,
    );
  }

}

class DatumTruckType {
  DatumTruckType({
    required this.id,
    required this.type,
  });

  final int id;
  final String type;

  DatumTruckType copyWith({
    int? id,
    String? type,
  }) {
    return DatumTruckType(
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }

  factory DatumTruckType.fromJson(Map<String, dynamic> json){
    return DatumTruckType(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
    );
  }

}

class VehicleProvider {
  VehicleProvider({
    required this.companyName,
    required this.vehicleNumber,
    required this.truckType,
    required this.driver,
  });

  final String companyName;
  final String vehicleNumber;
  final String truckType;
  final dynamic driver;

  VehicleProvider copyWith({
    String? companyName,
    String? vehicleNumber,
    String? truckType,
    dynamic? driver,
  }) {
    return VehicleProvider(
      companyName: companyName ?? this.companyName,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      truckType: truckType ?? this.truckType,
      driver: driver ?? this.driver,
    );
  }

  factory VehicleProvider.fromJson(Map<String, dynamic> json){
    return VehicleProvider(
      companyName: json["companyName"] ?? "",
      vehicleNumber: json["vehicleNumber"] ?? "",
      truckType: json["truckType"] ?? "",
      driver: json["driver"],
    );
  }

}

class PageMeta {
  PageMeta({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.pageCount,
    required this.nextPage,
  });

  final int page;
  final num pageSize;
  final num total;
  final int pageCount;
  final dynamic nextPage;

  PageMeta copyWith({
    int? page,
    num? pageSize,
    num? total,
    int? pageCount,
    dynamic? nextPage,
  }) {
    return PageMeta(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      pageCount: pageCount ?? this.pageCount,
      nextPage: nextPage ?? this.nextPage,
    );
  }

  factory PageMeta.fromJson(Map<String, dynamic> json){
    return PageMeta(
      page: json["page"] ?? 0,
      pageSize: json["pageSize"] ?? 0,
      total: json["total"] ?? 0,
      pageCount: json["pageCount"] ?? 0,
      nextPage: json["nextPage"],
    );
  }

}
