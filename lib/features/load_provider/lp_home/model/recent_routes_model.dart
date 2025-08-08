class RecentRoutesModel {
  RecentRoutesModel({
    required this.message,
    required this.data,
  });

  final String message;
  final List<RecentRouteData> data;

  RecentRoutesModel copyWith({
    String? message,
    List<RecentRouteData>? data,
  }) {
    return RecentRoutesModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory RecentRoutesModel.fromJson(Map<String, dynamic> json){
    return RecentRoutesModel(
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<RecentRouteData>.from(json["data"]!.map((x) => RecentRouteData.fromJson(x))),
    );
  }

}

class RecentRouteData {
  RecentRouteData({
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
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.loadRoute,
    required this.loadStatusLogs,
    required this.loadPrice,
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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final LoadRoute? loadRoute;
  final List<LoadStatusLog> loadStatusLogs;
  final LoadPrice? loadPrice;

  RecentRouteData copyWith({
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
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    LoadRoute? loadRoute,
    List<LoadStatusLog>? loadStatusLogs,
    LoadPrice? loadPrice,
  }) {
    return RecentRouteData(
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      loadRoute: loadRoute ?? this.loadRoute,
      loadStatusLogs: loadStatusLogs ?? this.loadStatusLogs,
      loadPrice: loadPrice ?? this.loadPrice,
    );
  }

  factory RecentRouteData.fromJson(Map<String, dynamic> json){
    return RecentRouteData(
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
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      loadRoute: json["loadRoute"] == null ? null : LoadRoute.fromJson(json["loadRoute"]),
      loadStatusLogs: json["loadStatusLogs"] == null ? [] : List<LoadStatusLog>.from(json["loadStatusLogs"]!.map((x) => LoadStatusLog.fromJson(x))),
      loadPrice: json["loadPrice"] == null ? null : LoadPrice.fromJson(json["loadPrice"]),
    );
  }

}

class LoadPrice {
  LoadPrice({
    required this.loadPriceId,
    required this.loadId,
    required this.rate,
    required this.handlingCharges,
    required this.status,
    required this.createAt,
    required this.deletedAt,
  });

  final String loadPriceId;
  final String loadId;
  final int rate;
  final int handlingCharges;
  final int status;
  final DateTime? createAt;
  final dynamic deletedAt;

  LoadPrice copyWith({
    String? loadPriceId,
    String? loadId,
    int? rate,
    int? handlingCharges,
    int? status,
    DateTime? createAt,
    dynamic deletedAt,
  }) {
    return LoadPrice(
      loadPriceId: loadPriceId ?? this.loadPriceId,
      loadId: loadId ?? this.loadId,
      rate: rate ?? this.rate,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      status: status ?? this.status,
      createAt: createAt ?? this.createAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadPrice.fromJson(Map<String, dynamic> json){
    return LoadPrice(
      loadPriceId: json["loadPriceId"] ?? "",
      loadId: json["loadId"] ?? "",
      rate: json["rate"] ?? 0,
      handlingCharges: json["handlingCharges"] ?? 0,
      status: json["status"] ?? 0,
      createAt: DateTime.tryParse(json["createAt"] ?? ""),
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
    dynamic deletedAt,
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
