import '../../../load_provider/lp_loads/model/lp_load_get_by_id_response.dart';

class LoadDetailModel {
  LoadDetailModel({
    required this.message,
    required this.data,
  });

  final String message;
  final LoadDetailModelData? data;

  LoadDetailModel copyWith({
    String? message,
    LoadDetailModelData? data,
  }) {
    return LoadDetailModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LoadDetailModel.fromJson(Map<String, dynamic> json){
    return LoadDetailModel(
      message: json["message"] ?? "",
      data: json["data"] == null ? null : LoadDetailModelData.fromJson(json["data"]),
    );
  }

}

class LoadDetailModelData {
  LoadDetailModelData({
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
    required this.consigneeId,
    required this.commodity,
    required this.truckType,
    required this.loadRoute,
    required this.loadStatusDetails,
    required this.loadPrice,
    required this.scheduleTripDetails,
    required this.consignee,
    required this.loadDocument,
    required this.damageShortage,
    required this.timeline,
    required this.customer,
    required this.vpCustomer,
    required this.weight,
    required this.paymentDetails,
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
  final String acceptedBy;
  final int createdPlatform;
  final int updatedPlatform;
  final int status;
  final DateTime? matchingStartDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final int consigneeId;
  final DataCommodity? commodity;
  final DataTruckType? truckType;
  final LoadRoute? loadRoute;
  final LoadStatusDetails? loadStatusDetails;
  final LoadPrice? loadPrice;
  final ScheduleTripDetails? scheduleTripDetails;
  final Consignee? consignee;
  final List<dynamic> loadDocument;
  final List<dynamic> damageShortage;
  final List<Timeline> timeline;
  final Customer? customer;
  final Customer? vpCustomer;
  final Weight? weight;
  final PaymentDetails? paymentDetails;

  LoadDetailModelData copyWith({
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
    String? acceptedBy,
    int? createdPlatform,
    int? updatedPlatform,
    int? status,
    DateTime? matchingStartDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
    int? consigneeId,
    DataCommodity? commodity,
    DataTruckType? truckType,
    LoadRoute? loadRoute,
    LoadStatusDetails? loadStatusDetails,
    LoadPrice? loadPrice,
    ScheduleTripDetails? scheduleTripDetails,
    Consignee? consignee,
    List<dynamic>? loadDocument,
    List<dynamic>? damageShortage,
    List<Timeline>? timeline,
    Customer? customer,
    Customer? vpCustomer,
    Weight? weight,
    PaymentDetails? paymentDetails,
  }) {
    return LoadDetailModelData(
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
      consigneeId: consigneeId ?? this.consigneeId,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      loadRoute: loadRoute ?? this.loadRoute,
      loadStatusDetails: loadStatusDetails ?? this.loadStatusDetails,
      loadPrice: loadPrice ?? this.loadPrice,
      scheduleTripDetails: scheduleTripDetails ?? this.scheduleTripDetails,
      consignee: consignee ?? this.consignee,
      loadDocument: loadDocument ?? this.loadDocument,
      damageShortage: damageShortage ?? this.damageShortage,
      timeline: timeline ?? this.timeline,
      customer: customer ?? this.customer,
      vpCustomer: vpCustomer ?? this.vpCustomer,
      weight: weight ?? this.weight,
      paymentDetails: paymentDetails ?? this.paymentDetails,
    );
  }

  factory LoadDetailModelData.fromJson(Map<String, dynamic> json){
    return LoadDetailModelData(
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
      acceptedBy: json["acceptedBy"] ?? "",
      createdPlatform: json["createdPlatform"] ?? 0,
      updatedPlatform: json["updatedPlatform"] ?? 0,
      status: json["status"] ?? 0,
      matchingStartDate: DateTime.tryParse(json["matchingStartDate"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      consigneeId: json["consigneeId"] ?? 0,
      commodity: json["commodity"] == null ? null : DataCommodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : DataTruckType.fromJson(json["truckType"]),
      loadRoute: json["loadRoute"] == null ? null : LoadRoute.fromJson(json["loadRoute"]),
      loadStatusDetails: json["loadStatusDetails"] == null ? null : LoadStatusDetails.fromJson(json["loadStatusDetails"]),
      loadPrice: json["loadPrice"] == null ? null : LoadPrice.fromJson(json["loadPrice"]),
      scheduleTripDetails: json["scheduleTripDetails"] == null ? null : ScheduleTripDetails.fromJson(json["scheduleTripDetails"]),
      consignee: json["consignee"] == null ? null : Consignee.fromJson(json["consignee"]),
      loadDocument: json["loadDocument"] == null ? [] : List<dynamic>.from(json["loadDocument"]!.map((x) => x)),
      damageShortage: json["damageShortage"] == null ? [] : List<dynamic>.from(json["damageShortage"]!.map((x) => x)),
      timeline: json["timeline"] == null ? [] : List<Timeline>.from(json["timeline"]!.map((x) => Timeline.fromJson(x))),
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      vpCustomer: json["vpCustomer"] == null ? null : Customer.fromJson(json["vpCustomer"]),
      weight: json["weight"] == null ? null : Weight.fromJson(json["weight"]),
      paymentDetails: json["paymentDetails"] == null ? null : PaymentDetails.fromJson(json["paymentDetails"]),
    );
  }

}

class DataCommodity {
  DataCommodity({
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

  DataCommodity copyWith({
    int? id,
    String? name,
    dynamic? description,
    dynamic? iconUrl,
    int? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return DataCommodity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory DataCommodity.fromJson(Map<String, dynamic> json){
    return DataCommodity(
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

class Consignee {
  Consignee({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
  });

  final int id;
  final String name;
  final String email;
  final String mobileNumber;

  Consignee copyWith({
    int? id,
    String? name,
    String? email,
    String? mobileNumber,
  }) {
    return Consignee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }

  factory Consignee.fromJson(Map<String, dynamic> json){
    return Consignee(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
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
    required this.kycVerificationDate,
    required this.createdAt,
    required this.deletedAt,
    required this.kycType,
    required this.companyType,
    required this.vehicle,
  });

  final String customerId;
  final String customerName;
  final String mobileNumber;
  final int companyTypeId;
  final String emailId;
  final String blueId;
  final dynamic kycRejectReason;
  final dynamic password;
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
  final DateTime? kycPendingDate;
  final DateTime? kycVerificationDate;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final Type? kycType;
  final Type? companyType;
  final List<VehicleElement> vehicle;

  Customer copyWith({
    String? customerId,
    String? customerName,
    String? mobileNumber,
    int? companyTypeId,
    String? emailId,
    String? blueId,
    dynamic? kycRejectReason,
    dynamic? password,
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
    DateTime? kycPendingDate,
    DateTime? kycVerificationDate,
    DateTime? createdAt,
    dynamic? deletedAt,
    Type? kycType,
    Type? companyType,
    List<VehicleElement>? vehicle,
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
      kycVerificationDate: kycVerificationDate ?? this.kycVerificationDate,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      kycType: kycType ?? this.kycType,
      companyType: companyType ?? this.companyType,
      vehicle: vehicle ?? this.vehicle,
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
      otp: json["otp"] ?? "",
      ememoOtp: json["ememo_otp"],
      otpAttempt: json["otpAttempt"] ?? "",
      isKyc: json["isKyc"] ?? 0,
      preferredLanes: json["preferredLanes"],
      roleId: json["roleId"] ?? 0,
      tempFlg: json["tempFlg"] ?? false,
      status: json["status"] ?? 0,
      isLogin: json["isLogin"] ?? false,
      kycPendingDate: DateTime.tryParse(json["kycPendingDate"] ?? ""),
      kycVerificationDate: DateTime.tryParse(json["kycVerificationDate"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      kycType: json["kycType"] == null ? null : Type.fromJson(json["kycType"]),
      companyType: json["companyType"] == null ? null : Type.fromJson(json["companyType"]),
      vehicle: json["vehicle"] == null ? [] : List<VehicleElement>.from(json["vehicle"]!.map((x) => VehicleElement.fromJson(x))),
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
    dynamic? deletedAt,
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

class VehicleElement {
  VehicleElement({
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
  final List<dynamic> truckType;
  final int ownedTrucks;
  final int attachedTrucks;
  final List<int> preferredLanes;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  VehicleElement copyWith({
    String? vpVehiclesId,
    String? customerId,
    List<dynamic>? truckType,
    int? ownedTrucks,
    int? attachedTrucks,
    List<int>? preferredLanes,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
  }) {
    return VehicleElement(
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

  factory VehicleElement.fromJson(Map<String, dynamic> json){
    return VehicleElement(
      vpVehiclesId: json["vp_vehicles_id"] ?? "",
      customerId: json["customer_id"] ?? "",
      truckType: json["truckType"] == null ? [] : List<dynamic>.from(json["truckType"]!.map((x) => x)),
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
  final String rate;
  final String maxRate;
  final String vpRate;
  final String vpMaxRate;
  final int handlingCharges;
  final int status;
  final DateTime? createAt;
  final DateTime? updateAt;
  final dynamic deletedAt;

  LoadPrice copyWith({
    String? loadPriceId,
    String? loadId,
    String? rate,
    String? maxRate,
    String? vpRate,
    String? vpMaxRate,
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
      rate: json["rate"]?.toString() ?? '0',
      maxRate: json["maxRate"]?.toString() ?? '0',
      vpRate: json["vpRate"]?.toString() ?? '0',
      vpMaxRate: json["vpMaxRate"]?.toString() ?? '0',
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

class PaymentDetails {
  PaymentDetails({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final PaymentDetailsData? data;

  PaymentDetails copyWith({
    int? status,
    String? message,
    PaymentDetailsData? data,
  }) {
    return PaymentDetails(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory PaymentDetails.fromJson(Map<String, dynamic> json){
    return PaymentDetails(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : PaymentDetailsData.fromJson(json["data"]),
    );
  }

}

class PaymentDetailsData {
  PaymentDetailsData({
    required this.logs,
    required this.payments,
  });

  final List<dynamic> logs;
  final List<dynamic> payments;

  PaymentDetailsData copyWith({
    List<dynamic>? logs,
    List<dynamic>? payments,
  }) {
    return PaymentDetailsData(
      logs: logs ?? this.logs,
      payments: payments ?? this.payments,
    );
  }

  factory PaymentDetailsData.fromJson(Map<String, dynamic> json){
    return PaymentDetailsData(
      logs: json["logs"] == null ? [] : List<dynamic>.from(json["logs"]!.map((x) => x)),
      payments: json["payments"] == null ? [] : List<dynamic>.from(json["payments"]!.map((x) => x)),
    );
  }

}

class ScheduleTripDetails {
  ScheduleTripDetails({
    required this.scheduleTripId,
    required this.vehicleId,
    required this.driverId,
    required this.acceptedBy,
    required this.etaForPickUp,
    required this.expectedDeliveryDate,
    required this.possibleDeliveryDate,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
    required this.loadId,
    required this.driver,
    required this.vehicle,
  });

  final String scheduleTripId;
  final String vehicleId;
  final String driverId;
  final String acceptedBy;
  final DateTime? etaForPickUp;
  final DateTime? expectedDeliveryDate;
  final DateTime? possibleDeliveryDate;
  final int status;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final String loadId;
  final Driver? driver;
  final ScheduleTripDetailsVehicle? vehicle;

  ScheduleTripDetails copyWith({
    String? scheduleTripId,
    String? vehicleId,
    String? driverId,
    String? acceptedBy,
    DateTime? etaForPickUp,
    DateTime? expectedDeliveryDate,
    DateTime? possibleDeliveryDate,
    int? status,
    DateTime? createdAt,
    dynamic? deletedAt,
    String? loadId,
    Driver? driver,
    ScheduleTripDetailsVehicle? vehicle,
  }) {
    return ScheduleTripDetails(
      scheduleTripId: scheduleTripId ?? this.scheduleTripId,
      vehicleId: vehicleId ?? this.vehicleId,
      driverId: driverId ?? this.driverId,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      etaForPickUp: etaForPickUp ?? this.etaForPickUp,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      possibleDeliveryDate: possibleDeliveryDate ?? this.possibleDeliveryDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      loadId: loadId ?? this.loadId,
      driver: driver ?? this.driver,
      vehicle: vehicle ?? this.vehicle,
    );
  }

  factory ScheduleTripDetails.fromJson(Map<String, dynamic> json){
    return ScheduleTripDetails(
      scheduleTripId: json["scheduleTripId"] ?? "",
      vehicleId: json["vehicleId"] ?? "",
      driverId: json["driverId"] ?? "",
      acceptedBy: json["acceptedBy"] ?? "",
      etaForPickUp: DateTime.tryParse(json["etaForPickUp"] ?? ""),
      expectedDeliveryDate: DateTime.tryParse(json["expectedDeliveryDate"] ?? ""),
      possibleDeliveryDate: DateTime.tryParse(json["possibleDeliveryDate"] ?? ""),
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      loadId: json["loadId"] ?? "",
      driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
      vehicle: json["vehicle"] == null ? null : ScheduleTripDetailsVehicle.fromJson(json["vehicle"]),
    );
  }

}

class Driver {
  Driver({
    required this.driverId,
    required this.name,
    required this.mobile,
    required this.email,
    required this.licenseNumber,
    required this.licenseDocLink,
    required this.licenseExpiryDate,
    required this.customerId,
    required this.dateOfBirth,
    required this.driverStatus,
    required this.experience,
    required this.bloodGroup,
    required this.licenseCategory,
    required this.specialLicense,
    required this.communicationPreference,
  });

  final String driverId;
  final String name;
  final String mobile;
  final String email;
  final String licenseNumber;
  final dynamic licenseDocLink;
  final DateTime? licenseExpiryDate;
  final String customerId;
  final DateTime? dateOfBirth;
  final int driverStatus;
  final String experience;
  final int bloodGroup;
  final int licenseCategory;
  final int specialLicense;
  final String communicationPreference;

  Driver copyWith({
    String? driverId,
    String? name,
    String? mobile,
    String? email,
    String? licenseNumber,
    dynamic? licenseDocLink,
    DateTime? licenseExpiryDate,
    String? customerId,
    DateTime? dateOfBirth,
    int? driverStatus,
    String? experience,
    int? bloodGroup,
    int? licenseCategory,
    int? specialLicense,
    String? communicationPreference,
  }) {
    return Driver(
      driverId: driverId ?? this.driverId,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseDocLink: licenseDocLink ?? this.licenseDocLink,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      customerId: customerId ?? this.customerId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      driverStatus: driverStatus ?? this.driverStatus,
      experience: experience ?? this.experience,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      licenseCategory: licenseCategory ?? this.licenseCategory,
      specialLicense: specialLicense ?? this.specialLicense,
      communicationPreference: communicationPreference ?? this.communicationPreference,
    );
  }

  factory Driver.fromJson(Map<String, dynamic> json){
    return Driver(
      driverId: json["driverId"] ?? "",
      name: json["name"] ?? "",
      mobile: json["mobile"] ?? "",
      email: json["email"] ?? "",
      licenseNumber: json["licenseNumber"] ?? "",
      licenseDocLink: json["licenseDocLink"],
      licenseExpiryDate: DateTime.tryParse(json["licenseExpiryDate"] ?? ""),
      customerId: json["customerId"] ?? "",
      dateOfBirth: DateTime.tryParse(json["dateOfBirth"] ?? ""),
      driverStatus: json["driverStatus"] ?? 0,
      experience: json["experience"] ?? "",
      bloodGroup: json["bloodGroup"] ?? 0,
      licenseCategory: json["licenseCategory"] ?? 0,
      specialLicense: json["specialLicense"] ?? 0,
      communicationPreference: json["communicationPreference"] ?? "",
    );
  }

}

class ScheduleTripDetailsVehicle {
  ScheduleTripDetailsVehicle({
    required this.vehicleId,
    required this.customerId,
    required this.truckNo,
    required this.ownerName,
    required this.registrationDate,
    required this.tonnage,
    required this.truckTypeId,
    required this.modelNumber,
    required this.insurancePolicyNumber,
    required this.insuranceValidityDate,
    required this.fcExpiryDate,
    required this.pucExpiryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String vehicleId;
  final String customerId;
  final String truckNo;
  final String ownerName;
  final DateTime? registrationDate;
  final String tonnage;
  final int truckTypeId;
  final String modelNumber;
  final String insurancePolicyNumber;
  final DateTime? insuranceValidityDate;
  final DateTime? fcExpiryDate;
  final DateTime? pucExpiryDate;
  final int status;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;

  ScheduleTripDetailsVehicle copyWith({
    String? vehicleId,
    String? customerId,
    String? truckNo,
    String? ownerName,
    DateTime? registrationDate,
    String? tonnage,
    int? truckTypeId,
    String? modelNumber,
    String? insurancePolicyNumber,
    DateTime? insuranceValidityDate,
    DateTime? fcExpiryDate,
    DateTime? pucExpiryDate,
    int? status,
    DateTime? createdAt,
    dynamic? updatedAt,
    dynamic? deletedAt,
  }) {
    return ScheduleTripDetailsVehicle(
      vehicleId: vehicleId ?? this.vehicleId,
      customerId: customerId ?? this.customerId,
      truckNo: truckNo ?? this.truckNo,
      ownerName: ownerName ?? this.ownerName,
      registrationDate: registrationDate ?? this.registrationDate,
      tonnage: tonnage ?? this.tonnage,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      modelNumber: modelNumber ?? this.modelNumber,
      insurancePolicyNumber: insurancePolicyNumber ?? this.insurancePolicyNumber,
      insuranceValidityDate: insuranceValidityDate ?? this.insuranceValidityDate,
      fcExpiryDate: fcExpiryDate ?? this.fcExpiryDate,
      pucExpiryDate: pucExpiryDate ?? this.pucExpiryDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory ScheduleTripDetailsVehicle.fromJson(Map<String, dynamic> json){
    return ScheduleTripDetailsVehicle(
      vehicleId: json["vehicleId"] ?? "",
      customerId: json["customerId"] ?? "",
      truckNo: json["truckNo"] ?? "",
      ownerName: json["ownerName"] ?? "",
      registrationDate: DateTime.tryParse(json["registrationDate"] ?? ""),
      tonnage: json["tonnage"] ?? "",
      truckTypeId: json["truckTypeId"] ?? 0,
      modelNumber: json["modelNumber"] ?? "",
      insurancePolicyNumber: json["insurancePolicyNumber"] ?? "",
      insuranceValidityDate: DateTime.tryParse(json["insuranceValidityDate"] ?? ""),
      fcExpiryDate: DateTime.tryParse(json["fcExpiryDate"] ?? ""),
      pucExpiryDate: DateTime.tryParse(json["pucExpiryDate"] ?? ""),
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: json["updatedAt"],
      deletedAt: json["deletedAt"],
    );
  }

}





class DataTruckType {
  DataTruckType({
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

  DataTruckType copyWith({
    int? id,
    String? type,
    String? subType,
    dynamic? iconUrl,
    int? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return DataTruckType(
      id: id ?? this.id,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory DataTruckType.fromJson(Map<String, dynamic> json){
    return DataTruckType(
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

class Weight {
  Weight({
    required this.weightageId,
    required this.measurementUnitId,
    required this.value,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int weightageId;
  final int measurementUnitId;
  final int value;
  final dynamic description;
  final int status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  Weight copyWith({
    int? weightageId,
    int? measurementUnitId,
    int? value,
    dynamic? description,
    int? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return Weight(
      weightageId: weightageId ?? this.weightageId,
      measurementUnitId: measurementUnitId ?? this.measurementUnitId,
      value: value ?? this.value,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Weight.fromJson(Map<String, dynamic> json){
    return Weight(
      weightageId: json["weightageId"] ?? 0,
      measurementUnitId: json["measurementUnitId"] ?? 0,
      value: json["value"] ?? 0,
      description: json["description"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}





