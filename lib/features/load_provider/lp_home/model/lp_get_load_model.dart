import '../../lp_loads/model/lp_load_response.dart';

class LpGetLoadModel {
  LpGetLoadModel({
    required this.message,
    required this.data,
  });

  final String message;
  final List<LoadData> data;

  LpGetLoadModel copyWith({
    String? message,
    List<LoadData>? data,
  }) {
    return LpGetLoadModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LpGetLoadModel.fromJson(Map<String, dynamic> json){
    return LpGetLoadModel(
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<LoadData>.from(json["data"]!.map((x) => LoadData.fromJson(x))),
    );
  }

}

class LoadData {
  LoadData({
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
    required this.loadOnhold,
    required this.loadRoute,
    required this.truckType,
    required this.commodity,
    required this.loadStatusDetails,
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
  final bool loadOnhold;
  final LoadRoute? loadRoute;
  final TruckType? truckType;
  final Commodity? commodity;
  final LoadStatusDetails? loadStatusDetails;
  final LoadPrice? loadPrice;
  final DatumCustomer? customer;

  LoadData copyWith({
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
    dynamic acceptedBy,
    int? createdPlatform,
    int? updatedPlatform,
    int? status,
    DateTime? matchingStartDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    bool? loadOnhold,
    LoadRoute? loadRoute,
    TruckType? truckType,
    Commodity? commodity,
    LoadStatusDetails? loadStatusDetails,
    LoadPrice? loadPrice,
    DatumCustomer? customer,
  }) {
    return LoadData(
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
      loadOnhold: loadOnhold ?? this.loadOnhold,
      loadRoute: loadRoute ?? this.loadRoute,
      truckType: truckType ?? this.truckType,
      commodity: commodity ?? this.commodity,
      loadStatusDetails: loadStatusDetails ?? this.loadStatusDetails,
      loadPrice: loadPrice ?? this.loadPrice,
      customer: customer ?? this.customer,
    );
  }

  factory LoadData.fromJson(Map<String, dynamic> json){
    return LoadData(
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
      loadOnhold: json["loadOnhold"],
      loadRoute: json["loadRoute"] == null ? null : LoadRoute.fromJson(json["loadRoute"]),
      truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
      commodity: json["commodity"] == null ? null : Commodity.fromJson(json["commodity"]),
      loadStatusDetails: json["loadStatusDetails"] == null ? null : LoadStatusDetails.fromJson(json["loadStatusDetails"]),
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
    dynamic description,
    dynamic iconUrl,
    int? status,
    DateTime? createdAt,
    dynamic deletedAt,
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
    required this.vehicles,
  });

  final CustomerCustomer? customer;
  final Address? address;
  final BankDetails? bankDetails;
  final List<Vehicle> vehicles;

  DatumCustomer copyWith({
    CustomerCustomer? customer,
    Address? address,
    BankDetails? bankDetails,
    List<Vehicle>? vehicles,
  }) {
    return DatumCustomer(
      customer: customer ?? this.customer,
      address: address ?? this.address,
      bankDetails: bankDetails ?? this.bankDetails,
      vehicles: vehicles ?? this.vehicles,
    );
  }

  factory DatumCustomer.fromJson(Map<String, dynamic> json){
    return DatumCustomer(
      customer: json["customer"] == null ? null : CustomerCustomer.fromJson(json["customer"]),
      address: json["address"] == null ? null : Address.fromJson(json["address"]),
      bankDetails: json["bankDetails"] == null ? null : BankDetails.fromJson(json["bankDetails"]),
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
    dynamic kycRejectReason,
    String? password,
    String? companyName,
    String? otp,
    String? otpAttempt,
    int? isKyc,
    dynamic preferredLanes,
    int? roleId,
    bool? tempFlg,
    int? status,
    bool? isLogin,
    dynamic kycPendingDate,
    DateTime? createdAt,
    dynamic deletedAt,
    dynamic kycType,
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
    dynamic deletedAt,
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
    dynamic deletedAt,
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
    dynamic deletedAt,
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
    dynamic iconUrl,
    int? status,
    DateTime? createdAt,
    dynamic deletedAt,
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
