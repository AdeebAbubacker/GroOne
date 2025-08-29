import 'lp_load_get_by_id_response.dart';
class LpLoadResponse {
  LpLoadResponse({
    required this.data,
    required this.total,
    required this.pageMeta,
    this.message,
  });

  final List<LpLoadItem> data;
  final int total;
  final PageMeta? pageMeta;
  final String? message;

  LpLoadResponse copyWith({
    List<LpLoadItem>? data,
    int? total,
    PageMeta? pageMeta,
    String? message,
  }) {
    return LpLoadResponse(
      data: data ?? this.data,
      total: total ?? this.total,
      pageMeta: pageMeta ?? this.pageMeta,
      message: message ?? this.message,
    );
  }

  factory LpLoadResponse.fromJson(Map<String, dynamic> json) {
    // Case 1: data is an object containing another "data" array
    if (json["data"] is Map<String, dynamic>) {
      final inner = json["data"];
      return LpLoadResponse(
        data: inner["data"] == null
            ? []
            : List<LpLoadItem>.from(inner["data"].map((x) => LpLoadItem.fromJson(x))),
        total: inner["total"] ?? 0,
        pageMeta: inner["pageMeta"] == null ? null : PageMeta.fromJson(inner["pageMeta"]),
        message: json["message"],
      );
    }

    // Case 2: data is already a list
    else if (json["data"] is List) {
      return LpLoadResponse(
        data: json["data"] == null
            ? []
            : List<LpLoadItem>.from(json["data"].map((x) => LpLoadItem.fromJson(x))),
        total: json["total"] ?? 0,
        pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
        message: json["message"],
      );
    }

    // Fallback
    return LpLoadResponse(data: [], total: 0, pageMeta: null, message: json["message"]);
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
    required this.loadOnhold,
    required this.loadRoute,
    required this.scheduleTripDetails,
    required this.loadStatusDetails,
    required this.loadPrice,
    required this.customer,
    required this.lpPaymentsData,
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
  final dynamic matchingStartDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final bool loadOnhold;
  final LoadRoute? loadRoute;
  final LoadStatusDetails? loadStatusDetails;
  final ScheduleTripDetails? scheduleTripDetails;
  final LoadPrice? loadPrice;
  final Customer? customer;
  final LpPaymentDetails? lpPaymentsData;


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
    dynamic acceptedBy,
    int? createdPlatform,
    int? updatedPlatform,
    int? status,
    dynamic matchingStartDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    bool? loadOnhold,
    LoadRoute? loadRoute,
    ScheduleTripDetails? scheduleTripDetails,
    LoadStatusDetails? loadStatusDetails,
    LoadPrice? loadPrice,
    Customer? customer,
    LpPaymentDetails? lpPaymentsData
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
      loadOnhold: loadOnhold ?? this.loadOnhold,
      loadRoute: loadRoute ?? this.loadRoute,
      scheduleTripDetails: scheduleTripDetails ?? this.scheduleTripDetails,
      loadStatusDetails: loadStatusDetails ?? this.loadStatusDetails,
      loadPrice: loadPrice ?? this.loadPrice,
      customer: customer ?? this.customer,
      lpPaymentsData: lpPaymentsData ?? this.lpPaymentsData,
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
      matchingStartDate: json["matchingStartDate"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      loadOnhold: json["loadOnhold"],
      loadRoute: json["loadRoute"] == null ? null : LoadRoute.fromJson(json["loadRoute"]),
      scheduleTripDetails: json["scheduleTripDetails"] == null ? null : ScheduleTripDetails.fromJson(json["scheduleTripDetails"]),
      loadStatusDetails: json["loadStatusDetails"] == null ? null : LoadStatusDetails.fromJson(json["loadStatusDetails"]),
      loadPrice: json["loadPrice"] == null ? null : LoadPrice.fromJson(json["loadPrice"]),
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      lpPaymentsData: json["paymentDetails"] == null ? null : LpPaymentDetails.fromJson(json["paymentDetails"]),
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

  Customer copyWith({
    String? customerId,
    String? customerName,
    String? mobileNumber,
    int? companyTypeId,
    String? emailId,
    String? blueId,
    dynamic kycRejectReason,
    dynamic password,
    String? companyName,
    String? otp,
    dynamic ememoOtp,
    String? otpAttempt,
    int? isKyc,
    dynamic preferredLanes,
    int? roleId,
    bool? tempFlg,
    int? status,
    bool? isLogin,
    DateTime? kycPendingDate,
    DateTime? kycVerificationDate,
    DateTime? createdAt,
    dynamic deletedAt,
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

class LoadStatusDetails {
  LoadStatusDetails({
    required this.id,
    required this.loadStatus,
    required this.status,
    required this.statusBgColor,
    required this.statusTxtColor,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int id;
  final String loadStatus;
  final int status;
  final String statusBgColor;
  final String statusTxtColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  LoadStatusDetails copyWith({
    int? id,
    String? loadStatus,
    int? status,
    String? statusBgColor,
    String? statusTxtColor,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) {
    return LoadStatusDetails(
      id: id ?? this.id,
      loadStatus: loadStatus ?? this.loadStatus,
      status: status ?? this.status,
      statusBgColor: statusBgColor ?? this.statusBgColor,
      statusTxtColor: statusTxtColor ?? this.statusTxtColor,
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
      statusBgColor: json["statusBgColor"] ?? "",
      statusTxtColor: json["statusTxtColor"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
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
  final Vehicle? vehicle;

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
    Vehicle? vehicle,
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
      vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "scheduleTripId": scheduleTripId,
    "vehicleId": vehicleId,
    "driverId": driverId,
    "acceptedBy": acceptedBy,
    "etaForPickUp": etaForPickUp?.toIso8601String(),
    "expectedDeliveryDate": expectedDeliveryDate?.toIso8601String(),
    "possibleDeliveryDate": possibleDeliveryDate?.toIso8601String(),
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
    "loadId": loadId,
    "driver": driver?.toJson(),
    "vehicle": vehicle?.toJson(),
  };

}

class Driver {
  Driver({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.customerId,
  });

  final String id;
  final String name;
  final String mobile;
  final String email;
  final String customerId;

  Driver copyWith({
    String? id,
    String? name,
    String? mobile,
    String? email,
    String? customerId,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      customerId: customerId ?? this.customerId,
    );
  }

  factory Driver.fromJson(Map<String, dynamic> json){
    return Driver(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      mobile: json["mobile"] ?? "",
      email: json["email"] ?? "",
      customerId: json["customerId"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile": mobile,
    "email": email,
    "customerId": customerId,
  };

}

class Vehicle {
  Vehicle({
    required this.truckNo,
    required this.customerId,
    required this.vehicleId,
    required this.truckTypeId,
  });

  final String truckNo;
  final String customerId;
  final String vehicleId;
  final int truckTypeId;

  Vehicle copyWith({
    String? truckNo,
    String? customerId,
    String? vehicleId,
    int? truckTypeId,
  }) {
    return Vehicle(
      truckNo: truckNo ?? this.truckNo,
      customerId: customerId ?? this.customerId,
      vehicleId: vehicleId ?? this.vehicleId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json){
    return Vehicle(
      truckNo: json["truckNo"] ?? "",
      customerId: json["customerId"] ?? "",
      vehicleId: json["vehicleId"] ?? "",
      truckTypeId: json["truckTypeId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "truckNo": truckNo,
    "customerId": customerId,
    "vehicleId": vehicleId,
    "truckTypeId": truckTypeId,
  };

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
    dynamic nextPage,
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
