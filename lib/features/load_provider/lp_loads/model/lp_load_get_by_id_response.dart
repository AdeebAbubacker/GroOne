import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart' hide LoadStatusDetails;
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';

import 'lp_load_response.dart';

class LoadGetByIdResponse {
  LoadGetByIdResponse({
    required this.message,
    required this.data,
  });

  final String message;
  final LoadData? data;

  LoadGetByIdResponse copyWith({
    String? message,
    LoadData? data,
  }) {
    return LoadGetByIdResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LoadGetByIdResponse.fromJson(Map<String, dynamic> json){
    return LoadGetByIdResponse(
      message: json["message"] ?? "",
      data: json["data"] == null ? null : LoadData.fromJson(json["data"]),
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
    required this.driverConsent,
    required this.matchingStartDate,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.loadOnhold,
    required this.commodity,
    required this.truckType,
    required this.loadRoute,
    required this.loadStatusDetails,
    required this.loadPrice,
    required this.scheduleTripDetails,
    this.loadMemoDetails,
    required this.consigneeDetails,
    required this.loadDocument,
    required this.trackingDetails,
    required this.damageShortage,
    required this.timeline,
    required this.loadApproval,
    required this.podDispatch,
    required this.loadSettlement,
    required this.customer,
    required this.vpCustomer,
    required this.weight,
    required this.bankDetails,
    required this.lpPaymentsData,
    required this.consignees,
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
  final int driverConsent;
  final DateTime? matchingStartDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final bool loadOnhold;
  final DataCommodity? commodity;
  final DataTruckType? truckType;
  final LoadRoute? loadRoute;
  final LoadStatusDetails? loadStatusDetails;
  final LoadPrice? loadPrice;
  final ScheduleTripDetails? scheduleTripDetails;
  final LoadMemoDetails? loadMemoDetails;
  final ConsigneeDetails? consigneeDetails;
  final List<LoadDocumentData> loadDocument;
  final LoadApproval? loadApproval;
  final PodDispatch? podDispatch;
  final LoadSettlement? loadSettlement;
  final TrackingDetails? trackingDetails;
  final List<Timeline> timeline;
  final List<DamageReport>? damageShortage;
  final Customer? customer;
  final Customer? vpCustomer;
  final Weight? weight;
  final LpPaymentDetails? lpPaymentsData;
  final List<Consignee> consignees;
  final BankDetails? bankDetails;

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
    String? acceptedBy,
    int? createdPlatform,
    int? updatedPlatform,
    int? status,
    int? driverConsent,
    DateTime? matchingStartDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    bool? loadOnhold,
    DataCommodity? commodity,
    DataTruckType? truckType,
    LoadRoute? loadRoute,
    LoadStatusDetails? loadStatusDetails,
    LoadPrice? loadPrice,
    ScheduleTripDetails? scheduleTripDetails,
    ConsigneeDetails? consigneeDetails,
    List<LoadDocumentData>? loadDocument,
    TrackingDetails? trackingDetails,
    LoadApproval? loadApproval,
    PodDispatch? podDispatch,
    LoadSettlement? loadSettlement,
    List<Timeline>? timeline,
    List<DamageReport>? damageShortage,
    Customer? customer,
    Customer? vpCustomer,
    Weight? weight,
    BankDetails? bankDetails,
    LpPaymentDetails? lpPaymentsData,
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
      driverConsent: driverConsent ?? this.driverConsent,
      matchingStartDate: matchingStartDate ?? this.matchingStartDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      loadOnhold: loadOnhold ?? this.loadOnhold,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      loadRoute: loadRoute ?? this.loadRoute,
      loadStatusDetails: loadStatusDetails ?? this.loadStatusDetails,
      loadPrice: loadPrice ?? this.loadPrice,
      scheduleTripDetails: scheduleTripDetails ?? this.scheduleTripDetails,
      loadMemoDetails: loadMemoDetails ?? loadMemoDetails,
      consigneeDetails: consigneeDetails ?? this.consigneeDetails,
      loadDocument: loadDocument ?? this.loadDocument,
      trackingDetails: trackingDetails ?? this.trackingDetails,
      timeline: timeline ?? this.timeline,
      loadApproval: loadApproval ?? this.loadApproval,
      podDispatch: podDispatch ?? this.podDispatch,
      loadSettlement: loadSettlement ?? this.loadSettlement,
      damageShortage: damageShortage ?? this.damageShortage,
      customer: customer ?? this.customer,
      vpCustomer: vpCustomer ?? this.vpCustomer,
      weight: weight ?? this.weight,
      bankDetails: bankDetails ?? this.bankDetails,
      lpPaymentsData: lpPaymentsData ?? this.lpPaymentsData,
      consignees: consignees,
    );
  }

  factory LoadData.fromJson(Map<String, dynamic> json){
    final rawPodDispatch = json['podDispatch'];

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
      acceptedBy: json["acceptedBy"] ?? "",
      createdPlatform: json["createdPlatform"] ?? 0,
      updatedPlatform: json["updatedPlatform"] ?? 0,
      status: json["status"] ?? 0,
      driverConsent: json["driverConsent"] ?? 0,
      matchingStartDate: DateTime.tryParse(json["matchingStartDate"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      loadOnhold: json["loadOnhold"],
      commodity: json["commodity"] == null ? null : DataCommodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : DataTruckType.fromJson(json["truckType"]),
      loadRoute: json["loadRoute"] == null ? null : LoadRoute.fromJson(json["loadRoute"]),
      loadStatusDetails: json["loadStatusDetails"] == null ? null : LoadStatusDetails.fromJson(json["loadStatusDetails"]),
      loadPrice: json["loadPrice"] == null ? null : LoadPrice.fromJson(json["loadPrice"]),
      scheduleTripDetails: json["scheduleTripDetails"] == null ? null : ScheduleTripDetails.fromJson(json["scheduleTripDetails"]),
      loadMemoDetails: json["loadMemo"] == null ? null : LoadMemoDetails.fromJson(json["loadMemo"]),
      consigneeDetails: json["consigneeDetails"] == null ? null : ConsigneeDetails.fromJson(json["consigneeDetails"]),
      loadDocument: json["loadDocument"] == null ? [] : List<LoadDocumentData>.from(json["loadDocument"]!.map((x) => LoadDocumentData.fromJson(x))),
      trackingDetails: json["trackingDetails"] == null ? null : TrackingDetails.fromJson(json["trackingDetails"]),
      loadApproval: json["loadApproval"] == null ? null : LoadApproval.fromJson(json["loadApproval"]),
      podDispatch: (rawPodDispatch != null && rawPodDispatch is Map)
          ? PodDispatch.fromJson(Map<String, dynamic>.from(rawPodDispatch))
          : null,
      loadSettlement: json["loadSettlement"] == null ? null : LoadSettlement.fromJson(json["loadSettlement"]),
      timeline: json["timeline"] == null ? [] : List<Timeline>.from(json["timeline"]!.map((x) => Timeline.fromJson(x))),
      damageShortage: json["damageShortage"] == null ? [] : List<DamageReport>.from(json["damageShortage"]!.map((x) => DamageReport.fromJson(x))),
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      vpCustomer: json["vpCustomer"] == null ? null : Customer.fromJson(json["vpCustomer"]),
      weight: json["weight"] == null ? null : Weight.fromJson(json["weight"]),
      bankDetails: json["bankDetails"] == null ? null : BankDetails.fromJson(json["bankDetails"]),
      lpPaymentsData: json["paymentDetails"] == null ? null : LpPaymentDetails.fromJson(json["paymentDetails"]),
      consignees: json["consignees"] == null
          ? []
          : List<Consignee>.from(json["consignees"].map((x) => Consignee.fromJson(x))),
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
    dynamic description,
    dynamic iconUrl,
    int? status,
    DateTime? createdAt,
    dynamic deletedAt,
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

// class Customer {
//   Customer({
//     required this.customerId,
//     required this.customerName,
//     required this.mobileNumber,
//     required this.companyTypeId,
//     required this.emailId,
//     required this.blueId,
//     required this.kycRejectReason,
//     required this.password,
//     required this.companyName,
//     required this.otp,
//     required this.ememoOtp,
//     required this.otpAttempt,
//     required this.isKyc,
//     required this.preferredLanes,
//     required this.roleId,
//     required this.tempFlg,
//     required this.status,
//     required this.isLogin,
//     required this.kycPendingDate,
//     required this.kycVerificationDate,
//     required this.createdAt,
//     required this.deletedAt,
//     required this.kycType,
//     required this.companyType,
//     required this.vehicle,
//   });

//   final String customerId;
//   final String customerName;
//   final String mobileNumber;
//   final int companyTypeId;
//   final String emailId;
//   final dynamic blueId;
//   final dynamic kycRejectReason;
//   final dynamic password;
//   final String companyName;
//   final String otp;
//   final dynamic ememoOtp;
//   final String otpAttempt;
//   final int isKyc;
//   final List<int> preferredLanes;
//   final int roleId;
//   final bool tempFlg;
//   final int status;
//   final bool isLogin;
//   final DateTime? kycPendingDate;
//   final DateTime? kycVerificationDate;
//   final DateTime? createdAt;
//   final dynamic deletedAt;
//   final Type? kycType;
//   final Type? companyType;
//   final List<VehicleElement> vehicle;

//   Customer copyWith({
//     String? customerId,
//     String? customerName,
//     String? mobileNumber,
//     int? companyTypeId,
//     String? emailId,
//     dynamic? blueId,
//     dynamic? kycRejectReason,
//     dynamic? password,
//     String? companyName,
//     String? otp,
//     dynamic? ememoOtp,
//     String? otpAttempt,
//     int? isKyc,
//     List<int>? preferredLanes,
//     int? roleId,
//     bool? tempFlg,
//     int? status,
//     bool? isLogin,
//     DateTime? kycPendingDate,
//     DateTime? kycVerificationDate,
//     DateTime? createdAt,
//     dynamic? deletedAt,
//     Type? kycType,
//     Type? companyType,
//     List<VehicleElement>? vehicle,
//   }) {
//     return Customer(
//       customerId: customerId ?? this.customerId,
//       customerName: customerName ?? this.customerName,
//       mobileNumber: mobileNumber ?? this.mobileNumber,
//       companyTypeId: companyTypeId ?? this.companyTypeId,
//       emailId: emailId ?? this.emailId,
//       blueId: blueId ?? this.blueId,
//       kycRejectReason: kycRejectReason ?? this.kycRejectReason,
//       password: password ?? this.password,
//       companyName: companyName ?? this.companyName,
//       otp: otp ?? this.otp,
//       ememoOtp: ememoOtp ?? this.ememoOtp,
//       otpAttempt: otpAttempt ?? this.otpAttempt,
//       isKyc: isKyc ?? this.isKyc,
//       preferredLanes: preferredLanes ?? this.preferredLanes,
//       roleId: roleId ?? this.roleId,
//       tempFlg: tempFlg ?? this.tempFlg,
//       status: status ?? this.status,
//       isLogin: isLogin ?? this.isLogin,
//       kycPendingDate: kycPendingDate ?? this.kycPendingDate,
//       kycVerificationDate: kycVerificationDate ?? this.kycVerificationDate,
//       createdAt: createdAt ?? this.createdAt,
//       deletedAt: deletedAt ?? this.deletedAt,
//       kycType: kycType ?? this.kycType,
//       companyType: companyType ?? this.companyType,
//       vehicle: vehicle ?? this.vehicle,
//     );
//   }

//   factory Customer.fromJson(Map<String, dynamic> json){
//     return Customer(
//       customerId: json["customer_id"] ?? "",
//       customerName: json["customerName"] ?? "",
//       mobileNumber: json["mobileNumber"] ?? "",
//       companyTypeId: json["companyTypeId"] ?? 0,
//       emailId: json["emailId"] ?? "",
//       blueId: json["blueId"],
//       kycRejectReason: json["kycRejectReason"],
//       password: json["password"],
//       companyName: json["companyName"] ?? "",
//       otp: json["otp"] ?? "",
//       ememoOtp: json["ememo_otp"],
//       otpAttempt: json["otpAttempt"] ?? "",
//       isKyc: json["isKyc"] ?? 0,
//       preferredLanes: json["preferredLanes"] == null ? [] : List<int>.from(json["preferredLanes"]!.map((x) => x)),
//       roleId: json["roleId"] ?? 0,
//       tempFlg: json["tempFlg"] ?? false,
//       status: json["status"] ?? 0,
//       isLogin: json["isLogin"] ?? false,
//       kycPendingDate: DateTime.tryParse(json["kycPendingDate"] ?? ""),
//       kycVerificationDate: DateTime.tryParse(json["kycVerificationDate"] ?? ""),
//       createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
//       deletedAt: json["deletedAt"],
//       kycType: json["kycType"] == null ? null : Type.fromJson(json["kycType"]),
//       companyType: json["companyType"] == null ? null : Type.fromJson(json["companyType"]),
//       vehicle: json["vehicle"] == null ? [] : List<VehicleElement>.from(json["vehicle"]!.map((x) => VehicleElement.fromJson(x))),
//     );
//   }

// }



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
    dynamic deletedAt,
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


class ScheduleTripDetails {
  ScheduleTripDetails({
    required this.scheduleTripId,
    // required this.vehicleId,
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
  // final String vehicleId;
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
    // String? vehicleId,
    String? driverId,
    String? acceptedBy,
    DateTime? etaForPickUp,
    DateTime? expectedDeliveryDate,
    DateTime? possibleDeliveryDate,
    int? status,
    DateTime? createdAt,
    dynamic deletedAt,
    String? loadId,
    Driver? driver,
    ScheduleTripDetailsVehicle? vehicle,
  }) {
    return ScheduleTripDetails(
      scheduleTripId: scheduleTripId ?? this.scheduleTripId,
      // vehicleId: vehicleId ?? this.vehicleId,
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
      // vehicleId: json["vehicleId"]['vehicleId'] ?? "",
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

class ConsigneeDetails {
  ConsigneeDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
  });

  final int id;
  final String name;
  final String email;
  final String mobileNumber;

  ConsigneeDetails copyWith({
    int? id,
    String? name,
    String? email,
    String? mobileNumber,
  }) {
    return ConsigneeDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }

  factory ConsigneeDetails.fromJson(Map<String, dynamic> json){
    return ConsigneeDetails(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
    );
  }

}

class LoadDocumentData {
  LoadDocumentData({
    required this.loadDocumentId,
    required this.loadId,
    required this.documentId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.documentDetails,
    required this.documentError,
  });

  final String loadDocumentId;
  final String loadId;
  final String documentId;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final DocumentDetails? documentDetails;
  final String documentError;

  LoadDocumentData copyWith({
    String? loadDocumentId,
    String? loadId,
    String? documentId,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    DocumentDetails? documentDetails,
    String? documentError,
  }) {
    return LoadDocumentData(
      loadDocumentId: loadDocumentId ?? this.loadDocumentId,
      loadId: loadId ?? this.loadId,
      documentId: documentId ?? this.documentId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      documentDetails: documentDetails ?? this.documentDetails,
      documentError: documentError ?? this.documentError,
    );
  }

  factory LoadDocumentData.fromJson(Map<String, dynamic> json){
    return LoadDocumentData(
      loadDocumentId: json["loadDocumentId"] ?? "",
      loadId: json["loadId"] ?? "",
      documentId: json["documentId"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      documentDetails: json["documentDetails"] == null ? null : DocumentDetails.fromJson(json["documentDetails"]),
      documentError: json["documentError"] ?? "",
    );
  }

}

class LoadSettlement {
  final String? settlementId;
  final String? vehicleId;
  final String? loadId;
  final int? noOfDays;
  final int? amountPerDay;
  final int? loadingCharge;
  final int? unLoadingCharge;
  final int? debitDamages;
  final int? debitShortages;
  final int? debitPenalities;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  LoadSettlement({
    this.settlementId,
    this.vehicleId,
    this.loadId,
    this.noOfDays,
    this.amountPerDay,
    this.loadingCharge,
    this.unLoadingCharge,
    this.debitDamages,
    this.debitShortages,
    this.debitPenalities,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory LoadSettlement.fromJson(Map<String, dynamic> json) {
    return LoadSettlement(
      settlementId: json['settlementId'] as String?,
      vehicleId: json['vehicleId'] as String?,
      loadId: json['loadId'] as String?,
      noOfDays: json['noOfDays'] as int?,
      amountPerDay: json['amountPerDay'] as int?,
      loadingCharge: json['loadingCharge'] as int?,
      unLoadingCharge: json['unloadingCharge'] as int?,
      debitDamages: json['debitDamages'] as int?,
      debitShortages: json['debitShortages'] as int?,
      debitPenalities: json['debitPenalities'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : null,
    );
  }
}

class TrackingDetails {
  TrackingDetails({
    required this.uuid,
    required this.shipperId,
    required this.supplierId,
    required this.tripId,
    required this.trackMode,
    required this.tripStatus,
    required this.currentLat,
    required this.currentLong,
    required this.currentAddress,
    required this.originLat,
    required this.originLong,
    required this.destinationLat,
    required this.destinationLong,
    required this.intugineId,
    required this.driverName,
    required this.driverNumber,
    required this.truckNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.lastTrackDt,
    required this.flaggedTrip,
  });

  final String uuid;
  final String shipperId;
  final String supplierId;
  final String tripId;
  final String trackMode;
  final String tripStatus;
  final dynamic currentLat;
  final dynamic currentLong;
  final dynamic currentAddress;
  final double originLat;
  final double originLong;
  final double destinationLat;
  final double destinationLong;
  final String intugineId;
  final String driverName;
  final String driverNumber;
  final String truckNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic lastTrackDt;
  final bool flaggedTrip;

  TrackingDetails copyWith({
    String? uuid,
    String? shipperId,
    String? supplierId,
    String? tripId,
    String? trackMode,
    String? tripStatus,
    dynamic currentLat,
    dynamic currentLong,
    dynamic currentAddress,
    double? originLat,
    double? originLong,
    double? destinationLat,
    double? destinationLong,
    String? intugineId,
    String? driverName,
    String? driverNumber,
    String? truckNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic lastTrackDt,
    bool? flaggedTrip,
  }) {
    return TrackingDetails(
      uuid: uuid ?? this.uuid,
      shipperId: shipperId ?? this.shipperId,
      supplierId: supplierId ?? this.supplierId,
      tripId: tripId ?? this.tripId,
      trackMode: trackMode ?? this.trackMode,
      tripStatus: tripStatus ?? this.tripStatus,
      currentLat: currentLat ?? this.currentLat,
      currentLong: currentLong ?? this.currentLong,
      currentAddress: currentAddress ?? this.currentAddress,
      originLat: originLat ?? this.originLat,
      originLong: originLong ?? this.originLong,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLong: destinationLong ?? this.destinationLong,
      intugineId: intugineId ?? this.intugineId,
      driverName: driverName ?? this.driverName,
      driverNumber: driverNumber ?? this.driverNumber,
      truckNumber: truckNumber ?? this.truckNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastTrackDt: lastTrackDt ?? this.lastTrackDt,
      flaggedTrip: flaggedTrip ?? this.flaggedTrip,
    );
  }

  factory TrackingDetails.fromJson(Map<String, dynamic> json){
    return TrackingDetails(
      uuid: json["uuid"] ?? "",
      shipperId: json["shipperId"] ?? "",
      supplierId: json["supplierId"] ?? "",
      tripId: json["tripId"] ?? "",
      trackMode: json["trackMode"] ?? "",
      tripStatus: json["tripStatus"] ?? "",
      currentLat: json["currentLat"],
      currentLong: json["currentLong"],
      currentAddress: json["currentAddress"],
      originLat: json["originLat"] ?? 0.0,
      originLong: json["originLong"] ?? 0.0,
      destinationLat: json["destinationLat"] ?? 0.0,
      destinationLong: json["destinationLong"] ?? 0.0,
      intugineId: json["intugineId"] ?? "",
      driverName: json["driverName"] ?? "",
      driverNumber: json["driverNumber"] ?? "",
      truckNumber: json["truckNumber"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      lastTrackDt: json["lastTrackDt"],
      flaggedTrip: json["flaggedTrip"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "shipperId": shipperId,
    "supplierId": supplierId,
    "tripId": tripId,
    "trackMode": trackMode,
    "tripStatus": tripStatus,
    "currentLat": currentLat,
    "currentLong": currentLong,
    "currentAddress": currentAddress,
    "originLat": originLat,
    "originLong": originLong,
    "destinationLat": destinationLat,
    "destinationLong": destinationLong,
    "intugineId": intugineId,
    "driverName": driverName,
    "driverNumber": driverNumber,
    "truckNumber": truckNumber,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "lastTrackDt": lastTrackDt,
    "flaggedTrip": flaggedTrip,
  };

}


class DocumentDetails {
  DocumentDetails({
    required this.documentId,
    required this.title,
    required this.documentType,
    required this.fileSize,
    required this.filePath,
    required this.originalFilename,
  });

  final String documentId;
  final String title;
  final String documentType;
  final String fileSize;
  final String filePath;
  final String originalFilename;

  DocumentDetails copyWith({
    String? documentId,
    String? title,
    String? documentType,
    String? fileSize,
    String? filePath,
    String? originalFilename,
  }) {
    return DocumentDetails(
      documentId: documentId ?? this.documentId,
      title: title ?? this.title,
      documentType: documentType ?? this.documentType,
      fileSize: fileSize ?? this.fileSize,
      filePath: filePath ?? this.filePath,
      originalFilename: originalFilename ?? this.originalFilename,
    );
  }

  factory DocumentDetails.fromJson(Map<String, dynamic> json){
    return DocumentDetails(
      documentId: json["documentId"] ?? "",
      title: json["title"] ?? "",
      documentType: json["documentType"] ?? "",
      fileSize: json["fileSize"] ?? "",
      filePath: json["filePath"] ?? "",
      originalFilename: json["originalFilename"] ?? "",
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
    dynamic licenseDocLink,
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
    required this.vehicle,
    required this.companyName,
    required this.truckType,
  });

  final Vehicle? vehicle;
  final String companyName;
  final TruckType? truckType;

  ScheduleTripDetailsVehicle copyWith({
    Vehicle? vehicle,
    String? companyName,
    TruckType? truckType,
  }) {
    return ScheduleTripDetailsVehicle(
      vehicle: vehicle ?? this.vehicle,
      companyName: companyName ?? this.companyName,
      truckType: truckType ?? this.truckType,
    );
  }

  factory ScheduleTripDetailsVehicle.fromJson(Map<String, dynamic> json){
    return ScheduleTripDetailsVehicle(
      vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
      companyName: json["companyName"] ?? "",
      truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "vehicle": vehicle?.toJson(),
    "companyName": companyName,
    "truckType": truckType?.toJson(),
  };

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

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "subType": subType,
    "iconUrl": iconUrl,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}

class Vehicle {
  Vehicle({
    required this.vehicleId,
    required this.customerId,
    required this.truckNo,
    required this.ownerName,
    required this.registrationDate,
    required this.tonnage,
    required this.truckTypeId,
    required this.modelNumber,
    required this.rcNumber,
    required this.rcDocLink,
    required this.insurancePolicyNumber,
    required this.insuranceValidityDate,
    required this.fcExpiryDate,
    required this.pucExpiryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.customer,
  });

  final String vehicleId;
  final String customerId;
  final String truckNo;
  final String ownerName;
  final DateTime? registrationDate;
  final String tonnage;
  final int truckTypeId;
  final String modelNumber;
  final dynamic rcNumber;
  final dynamic rcDocLink;
  final String insurancePolicyNumber;
  final DateTime? insuranceValidityDate;
  final DateTime? fcExpiryDate;
  final DateTime? pucExpiryDate;
  final int status;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final Customer? customer;

  Vehicle copyWith({
    String? vehicleId,
    String? customerId,
    String? truckNo,
    String? ownerName,
    DateTime? registrationDate,
    String? tonnage,
    int? truckTypeId,
    String? modelNumber,
    dynamic rcNumber,
    dynamic rcDocLink,
    String? insurancePolicyNumber,
    DateTime? insuranceValidityDate,
    DateTime? fcExpiryDate,
    DateTime? pucExpiryDate,
    int? status,
    DateTime? createdAt,
    dynamic updatedAt,
    dynamic deletedAt,
    Customer? customer,
  }) {
    return Vehicle(
      vehicleId: vehicleId ?? this.vehicleId,
      customerId: customerId ?? this.customerId,
      truckNo: truckNo ?? this.truckNo,
      ownerName: ownerName ?? this.ownerName,
      registrationDate: registrationDate ?? this.registrationDate,
      tonnage: tonnage ?? this.tonnage,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      modelNumber: modelNumber ?? this.modelNumber,
      rcNumber: rcNumber ?? this.rcNumber,
      rcDocLink: rcDocLink ?? this.rcDocLink,
      insurancePolicyNumber: insurancePolicyNumber ?? this.insurancePolicyNumber,
      insuranceValidityDate: insuranceValidityDate ?? this.insuranceValidityDate,
      fcExpiryDate: fcExpiryDate ?? this.fcExpiryDate,
      pucExpiryDate: pucExpiryDate ?? this.pucExpiryDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      customer: customer ?? this.customer,
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json){
    return Vehicle(
      vehicleId: json["vehicleId"] ?? "",
      customerId: json["customerId"] ?? "",
      truckNo: json["truckNo"] ?? "",
      ownerName: json["ownerName"] ?? "",
      registrationDate: DateTime.tryParse(json["registrationDate"] ?? ""),
      tonnage: json["tonnage"] ?? "",
      truckTypeId: json["truckTypeId"] ?? 0,
      modelNumber: json["modelNumber"] ?? "",
      rcNumber: json["rcNumber"],
      rcDocLink: json["rcDocLink"],
      insurancePolicyNumber: json["insurancePolicyNumber"] ?? "",
      insuranceValidityDate: DateTime.tryParse(json["insuranceValidityDate"] ?? ""),
      fcExpiryDate: DateTime.tryParse(json["fcExpiryDate"] ?? ""),
      pucExpiryDate: DateTime.tryParse(json["pucExpiryDate"] ?? ""),
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: json["updatedAt"],
      deletedAt: json["deletedAt"],
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    "customerId": customerId,
    "truckNo": truckNo,
    "ownerName": ownerName,
    "registrationDate": registrationDate,
    "tonnage": tonnage,
    "truckTypeId": truckTypeId,
    "modelNumber": modelNumber,
    "rcNumber": rcNumber,
    "rcDocLink": rcDocLink,
    "insurancePolicyNumber": insurancePolicyNumber,
    "insuranceValidityDate": insuranceValidityDate,
    "fcExpiryDate": fcExpiryDate,
    "pucExpiryDate": pucExpiryDate,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt,
    "deletedAt": deletedAt,
    "customer": customer,
  };

}


class Timeline {
  Timeline({
    required this.id,
    required this.label,
    required this.status,
    required this.statusBgColor,
    required this.timestamp,
    required this.commodity,
    required this.truckType,
    required this.loadProvider,
    required this.latestTransitData,
  });

  final int id;
  final String label;
  final String status;
  final String statusBgColor;
  final DateTime? timestamp;
  final TimelineCommodity? commodity;
  final TimelineTruckType? truckType;
  final LoadProvider? loadProvider;
  final LatestTransitData? latestTransitData;

  Timeline copyWith({
    int? id,
    String? label,
    String? status,
    String? statusBgColor,
    DateTime? timestamp,
    TimelineCommodity? commodity,
    TimelineTruckType? truckType,
    LoadProvider? loadProvider,
    LatestTransitData? latestTransitData,
  }) {
    return Timeline(
      id: id ?? this.id,
      label: label ?? this.label,
      status: status ?? this.status,
      statusBgColor: statusBgColor ?? this.statusBgColor,
      timestamp: timestamp ?? this.timestamp,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      loadProvider: loadProvider ?? this.loadProvider,
      latestTransitData: latestTransitData ?? this.latestTransitData,
    );
  }

  factory Timeline.fromJson(Map<String, dynamic> json){
    return Timeline(
      id: json["id"] ?? 0,
      label: json["label"] ?? "",
      status: json["status"] ?? "",
      statusBgColor: json["statusBgColor"] ?? "",
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
      commodity: json["commodity"] == null ? null : TimelineCommodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : TimelineTruckType.fromJson(json["truckType"]),
      loadProvider: json["loadProvider"] == null ? null : LoadProvider.fromJson(json["loadProvider"]),
      latestTransitData: json["latestTransitData"] == null ? null : LatestTransitData.fromJson(json["latestTransitData"]),
    );
  }

}

class LatestTransitData {
  LatestTransitData({
    required this.location,
    required this.latestDate,
  });

  final String location;
  final DateTime? latestDate;

  LatestTransitData copyWith({
    String? location,
    DateTime? latestDate,
  }) {
    return LatestTransitData(
      location: location ?? this.location,
      latestDate: latestDate ?? this.latestDate,
    );
  }

  factory LatestTransitData.fromJson(Map<String, dynamic> json){
    return LatestTransitData(
      location: json["location"] ?? "",
      latestDate: DateTime.tryParse(json["latestDate"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "location": location,
    "latestDate": latestDate?.toIso8601String(),
  };

}

class TimelineCommodity {
  TimelineCommodity({
    required this.id,
    required this.name,
    required this.description,
  });

  final int id;
  final String name;
  final dynamic description;

  TimelineCommodity copyWith({
    int? id,
    String? name,
    dynamic description,
  }) {
    return TimelineCommodity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  factory TimelineCommodity.fromJson(Map<String, dynamic> json){
    return TimelineCommodity(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"],
    );
  }

}

class LoadProvider {
  LoadProvider({
    required this.companyName,
  });

  final String companyName;

  LoadProvider copyWith({
    String? companyName,
  }) {
    return LoadProvider(
      companyName: companyName ?? this.companyName,
    );
  }

  factory LoadProvider.fromJson(Map<String, dynamic> json){
    return LoadProvider(
      companyName: json["companyName"] ?? "",
    );
  }

}

class TimelineTruckType {
  TimelineTruckType({
    required this.id,
    required this.type,
    required this.subType,
  });

  final int id;
  final String type;
  final String subType;

  TimelineTruckType copyWith({
    int? id,
    String? type,
    String? subType,
  }) {
    return TimelineTruckType(
      id: id ?? this.id,
      type: type ?? this.type,
      subType: subType ?? this.subType,
    );
  }

  factory TimelineTruckType.fromJson(Map<String, dynamic> json){
    return TimelineTruckType(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
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
    dynamic iconUrl,
    int? status,
    DateTime? createdAt,
    dynamic deletedAt,
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
    dynamic description,
    int? status,
    DateTime? createdAt,
    dynamic deletedAt,
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

class BankDetails {
  BankDetails({
    required this.id,
    required this.beneficiaryName,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.branchName,
    required this.status,
    required this.createAt,
    required this.deletedAt,
  });

  final int id;
  final String beneficiaryName;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String branchName;
  final int status;
  final DateTime? createAt;
  final dynamic deletedAt;

  BankDetails copyWith({
    int? id,
    String? beneficiaryName,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? branchName,
    int? status,
    DateTime? createAt,
    dynamic deletedAt,
  }) {
    return BankDetails(
      id: id ?? this.id,
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      branchName: branchName ?? this.branchName,
      status: status ?? this.status,
      createAt: createAt ?? this.createAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory BankDetails.fromJson(Map<String, dynamic> json){
    return BankDetails(
      id: json["id"] ?? 0,
      beneficiaryName: json["beneficiaryName"] ?? "",
      bankName: json["bankName"] ?? "",
      accountNumber: json["accountNumber"] ?? "",
      ifscCode: json["ifscCode"] ?? "",
      branchName: json["branchName"] ?? "",
      status: json["status"] ?? 0,
      createAt: DateTime.tryParse(json["createAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "beneficiaryName": beneficiaryName,
    "bankName": bankName,
    "accountNumber": accountNumber,
    "ifscCode": ifscCode,
    "branchName": branchName,
    "status": status,
    "createAt": createAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}


class Consignee {
    Consignee({
        required this.id,
        required this.name,
        required this.email,
        required this.mobileNumber,
        required this.loadId,
    });

    final String id;
    final String name;
    final String email;
    final String mobileNumber;
    final String loadId;

    Consignee copyWith({
        String? id,
        String? name,
        String? email,
        String? mobileNumber,
        String? loadId,
    }) {
        return Consignee(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            loadId: loadId ?? this.loadId,
        );
    }

    factory Consignee.fromJson(Map<String, dynamic> json){ 
        return Consignee(
            id: json["id"] ?? "",
            name: json["name"] ?? "",
            email: json["email"] ?? "",
            mobileNumber: json["mobileNumber"] ?? "",
            loadId: json["loadId"] ?? "",
        );
    }

}

class LpPaymentDetails {
  LpPaymentDetails({
    required this.id,
    required this.seriesNo,
    required this.loadSeriesId,
    required this.loadId,
    required this.lpId,
    required this.vpId,
    required this.agreedPrice,
    required this.receivableAdvance,
    required this.receivableBalance,
    required this.receivableAdvancePercentage,
    required this.receivableBalancePercentage,
    required this.receivableAdvancePaid,
    required this.receivableBalancePaid,
    required this.payableAdvance,
    required this.payableBalance,
    required this.payableAdvancePercentage,
    required this.payableBalancePercentage,
    required this.payableAdvancePaid,
    required this.payableBalancePaid,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.payableAgreedPrice,
    required this.receivableAdvancePaidFlg,
    required this.receivableBalancePaidFlg,
    required this.receivableAdvancePaidDate,
    required this.receivableBalancePaidDate,
    required this.payableAdvancePaidFlg,
    required this.payableBalancePaidFlg,
    required this.payableAdvancePaidDate,
    required this.payableBalancePaidDate,
    required this.payableAdvanceErpReqFlg,
    required this.payableBalanceErpReqFlg,
    required this.balanceToBeReceivable,
    required this.balanceToBePayable,
    required this.platformFee,
    required this.lpLogs,
    required this.vpLogs,
    required this.loadPayout,
  });

  final String id;
  final int seriesNo;
  final String loadSeriesId;
  final String loadId;
  final String lpId;
  final String vpId;
  final String agreedPrice;
  final String receivableAdvance;
  final String receivableBalance;
  final String receivableAdvancePercentage;
  final String receivableBalancePercentage;
  final String receivableAdvancePaid;
  final String receivableBalancePaid;
  final String payableAdvance;
  final String payableBalance;
  final String payableAdvancePercentage;
  final String payableBalancePercentage;
  final String payableAdvancePaid;
  final String payableBalancePaid;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String payableAgreedPrice;
  final bool receivableAdvancePaidFlg;
  final bool receivableBalancePaidFlg;
  final dynamic receivableAdvancePaidDate;
  final dynamic receivableBalancePaidDate;
  final bool payableAdvancePaidFlg;
  final bool payableBalancePaidFlg;
  final dynamic payableAdvancePaidDate;
  final DateTime? payableBalancePaidDate;
  final bool payableAdvanceErpReqFlg;
  final bool payableBalanceErpReqFlg;
  final String balanceToBeReceivable;
  final String balanceToBePayable;
  final String platformFee;
  final List<VpLog> lpLogs;
  final List<VpLog> vpLogs;
  final List<LoadPayout> loadPayout;

  LpPaymentDetails copyWith({
    String? id,
    int? seriesNo,
    String? loadSeriesId,
    String? loadId,
    String? lpId,
    String? vpId,
    String? agreedPrice,
    String? receivableAdvance,
    String? receivableBalance,
    String? receivableAdvancePercentage,
    String? receivableBalancePercentage,
    String? receivableAdvancePaid,
    String? receivableBalancePaid,
    String? payableAdvance,
    String? payableBalance,
    String? payableAdvancePercentage,
    String? payableBalancePercentage,
    String? payableAdvancePaid,
    String? payableBalancePaid,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
    String? payableAgreedPrice,
    bool? receivableAdvancePaidFlg,
    bool? receivableBalancePaidFlg,
    dynamic? receivableAdvancePaidDate,
    dynamic? receivableBalancePaidDate,
    bool? payableAdvancePaidFlg,
    bool? payableBalancePaidFlg,
    dynamic? payableAdvancePaidDate,
    DateTime? payableBalancePaidDate,
    bool? payableAdvanceErpReqFlg,
    bool? payableBalanceErpReqFlg,
    String? balanceToBeReceivable,
    String? balanceToBePayable,
    String? platformFee,
    List<VpLog>? lpLogs,
    List<VpLog>? vpLogs,
    List<LoadPayout>? loadPayout,
  }) {
    return LpPaymentDetails(
      id: id ?? this.id,
      seriesNo: seriesNo ?? this.seriesNo,
      loadSeriesId: loadSeriesId ?? this.loadSeriesId,
      loadId: loadId ?? this.loadId,
      lpId: lpId ?? this.lpId,
      vpId: vpId ?? this.vpId,
      agreedPrice: agreedPrice ?? this.agreedPrice,
      receivableAdvance: receivableAdvance ?? this.receivableAdvance,
      receivableBalance: receivableBalance ?? this.receivableBalance,
      receivableAdvancePercentage: receivableAdvancePercentage ?? this.receivableAdvancePercentage,
      receivableBalancePercentage: receivableBalancePercentage ?? this.receivableBalancePercentage,
      receivableAdvancePaid: receivableAdvancePaid ?? this.receivableAdvancePaid,
      receivableBalancePaid: receivableBalancePaid ?? this.receivableBalancePaid,
      payableAdvance: payableAdvance ?? this.payableAdvance,
      payableBalance: payableBalance ?? this.payableBalance,
      payableAdvancePercentage: payableAdvancePercentage ?? this.payableAdvancePercentage,
      payableBalancePercentage: payableBalancePercentage ?? this.payableBalancePercentage,
      payableAdvancePaid: payableAdvancePaid ?? this.payableAdvancePaid,
      payableBalancePaid: payableBalancePaid ?? this.payableBalancePaid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      payableAgreedPrice: payableAgreedPrice ?? this.payableAgreedPrice,
      receivableAdvancePaidFlg: receivableAdvancePaidFlg ?? this.receivableAdvancePaidFlg,
      receivableBalancePaidFlg: receivableBalancePaidFlg ?? this.receivableBalancePaidFlg,
      receivableAdvancePaidDate: receivableAdvancePaidDate ?? this.receivableAdvancePaidDate,
      receivableBalancePaidDate: receivableBalancePaidDate ?? this.receivableBalancePaidDate,
      payableAdvancePaidFlg: payableAdvancePaidFlg ?? this.payableAdvancePaidFlg,
      payableBalancePaidFlg: payableBalancePaidFlg ?? this.payableBalancePaidFlg,
      payableAdvancePaidDate: payableAdvancePaidDate ?? this.payableAdvancePaidDate,
      payableBalancePaidDate: payableBalancePaidDate ?? this.payableBalancePaidDate,
      payableAdvanceErpReqFlg: payableAdvanceErpReqFlg ?? this.payableAdvanceErpReqFlg,
      payableBalanceErpReqFlg: payableBalanceErpReqFlg ?? this.payableBalanceErpReqFlg,
      balanceToBeReceivable: balanceToBeReceivable ?? this.balanceToBeReceivable,
      balanceToBePayable: balanceToBePayable ?? this.balanceToBePayable,
      platformFee: platformFee ?? this.platformFee,
      lpLogs: lpLogs ?? this.lpLogs,
      vpLogs: vpLogs ?? this.vpLogs,
      loadPayout: loadPayout ?? this.loadPayout,
    );
  }

  factory LpPaymentDetails.fromJson(Map<String, dynamic> json){
    return LpPaymentDetails(
      id: json["id"] ?? "",
      seriesNo: json["seriesNo"] ?? 0,
      loadSeriesId: json["loadSeriesId"] ?? "",
      loadId: json["loadId"] ?? "",
      lpId: json["lpId"] ?? "",
      vpId: json["vpId"] ?? "",
      agreedPrice: json["agreedPrice"] ?? "",
      receivableAdvance: json["receivableAdvance"] ?? "",
      receivableBalance: json["receivableBalance"] ?? "",
      receivableAdvancePercentage: json["receivableAdvancePercentage"] ?? "",
      receivableBalancePercentage: json["receivableBalancePercentage"] ?? "",
      receivableAdvancePaid: json["receivableAdvancePaid"] ?? "",
      receivableBalancePaid: json["receivableBalancePaid"] ?? "",
      payableAdvance: json["payableAdvance"] ?? "",
      payableBalance: json["payableBalance"] ?? "",
      payableAdvancePercentage: json["payableAdvancePercentage"] ?? "",
      payableBalancePercentage: json["payableBalancePercentage"] ?? "",
      payableAdvancePaid: json["payableAdvancePaid"] ?? "",
      payableBalancePaid: json["payableBalancePaid"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      payableAgreedPrice: json["payableAgreedPrice"] ?? "",
      receivableAdvancePaidFlg: json["receivableAdvancePaidFlg"] ?? false,
      receivableBalancePaidFlg: json["receivableBalancePaidFlg"] ?? false,
      receivableAdvancePaidDate: json["receivableAdvancePaidDate"],
      receivableBalancePaidDate: json["receivableBalancePaidDate"],
      payableAdvancePaidFlg: json["payableAdvancePaidFlg"] ?? false,
      payableBalancePaidFlg: json["payableBalancePaidFlg"] ?? false,
      payableAdvancePaidDate: json["payableAdvancePaidDate"],
      payableBalancePaidDate: DateTime.tryParse(json["payableBalancePaidDate"] ?? ""),
      payableAdvanceErpReqFlg: json["payableAdvanceErpReqFlg"] ?? false,
      payableBalanceErpReqFlg: json["payableBalanceErpReqFlg"] ?? false,
      balanceToBeReceivable: json["balanceToBeReceivable"] ?? "",
      balanceToBePayable: json["balanceToBePayable"] ?? "",
      platformFee: json["platformFee"] ?? "",
      lpLogs: json['lpLogs']!=null &&  (json['lpLogs'] as List).isNotEmpty ? List<VpLog>.from(json['lpLogs']!.map((x)=>VpLog.fromJson(x))).toList():[],
      vpLogs: json['vpLogs']!=null &&  (json['vpLogs'] as List).isNotEmpty ? List<VpLog>.from(json['vpLogs']!.map((x)=>VpLog.fromJson(x))).toList():[],
      loadPayout: json["loadPayout"] == null ? [] : List<LoadPayout>.from(json["loadPayout"]!.map((x) => LoadPayout.fromJson(x))),
    );
  }

}

class LoadPayout {
  LoadPayout({
    required this.id,
    required this.loadId,
    required this.voucherCode,
    required this.error,
    required this.createdBy,
    required this.type,
    required this.amount,
    required this.createdAt,
  });

  final String id;
  final String loadId;
  final String voucherCode;
  final dynamic error;
  final String createdBy;
  final String type;
  final String amount;
  final DateTime? createdAt;

  LoadPayout copyWith({
    String? id,
    String? loadId,
    String? voucherCode,
    dynamic? error,
    String? createdBy,
    String? type,
    String? amount,
    DateTime? createdAt,
  }) {
    return LoadPayout(
      id: id ?? this.id,
      loadId: loadId ?? this.loadId,
      voucherCode: voucherCode ?? this.voucherCode,
      error: error ?? this.error,
      createdBy: createdBy ?? this.createdBy,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory LoadPayout.fromJson(Map<String, dynamic> json){
    return LoadPayout(
      id: json["id"] ?? "",
      loadId: json["loadId"] ?? "",
      voucherCode: json["voucherCode"] ?? "",
      error: json["error"],
      createdBy: json["createdBy"] ?? "",
      type: json["type"] ?? "",
      amount: json["amount"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "loadId": loadId,
    "voucherCode": voucherCode,
    "error": error,
    "createdBy": createdBy,
    "type": type,
    "amount": amount,
    "createdAt": createdAt?.toIso8601String(),
  };

}

class Customer {
    Customer({
        required this.customerId,
        required this.customerName,
        required this.mobileNumber,
        required this.companyTypeId,
        required this.customerSeriesNo,
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
        required this.customerAddress,
    });

    final String customerId;
    final String customerName;
    final String mobileNumber;
    final int companyTypeId;
    final int customerSeriesNo;
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
    final KycType? kycType;
    final CompanyType? companyType;
    final CustomerAddress? customerAddress;

    Customer copyWith({
        String? customerId,
        String? customerName,
        String? mobileNumber,
        int? companyTypeId,
        int? customerSeriesNo,
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
        KycType? kycType,
        CompanyType? companyType,
        CustomerAddress? customerAddress,
    }) {
        return Customer(
            customerId: customerId ?? this.customerId,
            customerName: customerName ?? this.customerName,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            companyTypeId: companyTypeId ?? this.companyTypeId,
            customerSeriesNo: customerSeriesNo ?? this.customerSeriesNo,
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
            customerAddress: customerAddress ?? this.customerAddress,
        );
    }

    factory Customer.fromJson(Map<String, dynamic> json){ 
        return Customer(
            customerId: json["customer_id"] ?? "",
            customerName: json["customerName"] ?? "",
            mobileNumber: json["mobileNumber"] ?? "",
            companyTypeId: json["companyTypeId"] ?? 0,
            customerSeriesNo: json["customerSeriesNo"] ?? 0,
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
            kycType: json["kycType"] == null ? null : KycType.fromJson(json["kycType"]),
            companyType: json["companyType"] == null ? null : CompanyType.fromJson(json["companyType"]),
            customerAddress: json["customerAddress"] == null ? null : CustomerAddress.fromJson(json["customerAddress"]),
        );
    }

}

class CompanyType{
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

class KycType {
    KycType({
        required this.id,
        required this.kycType,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
    });

    final int id;
    final String kycType;
    final int status;
    final dynamic createdAt;
    final dynamic deletedAt;

    KycType copyWith({
        int? id,
        String? kycType,
        int? status,
        dynamic createdAt,
        dynamic deletedAt,
    }) {
        return KycType(
            id: id ?? this.id,
            kycType: kycType ?? this.kycType,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory KycType.fromJson(Map<String, dynamic> json){ 
        return KycType(
            id: json["id"] ?? 0,
            kycType: json["kycType"] ?? "",
            status: json["status"] ?? 0,
            createdAt: json["createdAt"],
            deletedAt: json["deletedAt"],
        );
    }

}


class CustomerAddress {
    CustomerAddress({
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

    CustomerAddress copyWith({
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
        return CustomerAddress(
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

    factory CustomerAddress.fromJson(Map<String, dynamic> json){ 
        return CustomerAddress(
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

class LoadMemoDetails {
    LoadMemoDetails({
        required this.id,
        required this.loadId,
        required this.memoNumber,
        required this.vpAmount,
        required this.netFreight,
        required this.advance,
        required this.advancePercentage,
        required this.balance,
        required this.balancePercentage,
        required this.vpAdvance,
        required this.vpAdvancePercentage,
        required this.vpBalance,
        required this.vpBalancePercentage,
        required this.status,
        required this.createAt,
        required this.deletedAt,
    });

    final String id;
    final String loadId;
    final String memoNumber;
    final String vpAmount;
    final String netFreight;
    final String advance;
    final String advancePercentage;
    final String balance;
    final String balancePercentage;
    final String vpAdvance;
    final String vpAdvancePercentage;
    final String vpBalance;
    final String vpBalancePercentage;
    final int status;
    final DateTime? createAt;
    final dynamic deletedAt;

    LoadMemoDetails copyWith({
        String? id,
        String? loadId,
        String? memoNumber,
        String? vpAmount,
        String? netFreight,
        String? advance,
        String? advancePercentage,
        String? balance,
        String? balancePercentage,
        String? vpAdvance,
        String? vpAdvancePercentage,
        String? vpBalance,
        String? vpBalancePercentage,
        int? status,
        DateTime? createAt,
        dynamic deletedAt,
    }) {
        return LoadMemoDetails(
            id: id ?? this.id,
            loadId: loadId ?? this.loadId,
            memoNumber: memoNumber ?? this.memoNumber,
            vpAmount: vpAmount ?? this.vpAmount,
            netFreight: netFreight ?? this.netFreight,
            advance: advance ?? this.advance,
            advancePercentage: advancePercentage ?? this.advancePercentage,
            balance: balance ?? this.balance,
            balancePercentage: balancePercentage ?? this.balancePercentage,
            vpAdvance: vpAdvance ?? this.vpAdvance,
            vpAdvancePercentage: vpAdvancePercentage ?? this.vpAdvancePercentage,
            vpBalance: balance ?? this.vpBalance,
            vpBalancePercentage: vpBalancePercentage ?? this.vpBalancePercentage,
            status: status ?? this.status,
            createAt: createAt ?? this.createAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory LoadMemoDetails.fromJson(Map<String, dynamic> json){ 
        return LoadMemoDetails(
            id: json["id"] ?? "",
            loadId: json["loadId"] ?? "",
            memoNumber: json["memoNumber"] ?? "",
            vpAmount: json["vpAmount"] ?? "",
            netFreight: json["netFreight"] ?? "",
            advance: json["advance"] ?? "",
            advancePercentage: json["advancePercentage"] ?? "",
            balance: json["balance"] ?? "",
            balancePercentage: json["balancePercentage"] ?? "",
            vpAdvance: json["vpAdvance"] ?? "",
            vpAdvancePercentage: json["vpAdvancePercentage"] ?? "",
            vpBalance: json["vpBalance"] ?? "",
            vpBalancePercentage: json["vpBalancePercentage"] ?? "",
            status: json["status"] ?? 0,
            createAt: DateTime.tryParse(json["createAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }
}
