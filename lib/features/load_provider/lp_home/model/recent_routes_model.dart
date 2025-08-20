class RecentRoutesModel {
  final String message;
  final RecentRoutesDataWrapper data;

  RecentRoutesModel({
    required this.message,
    required this.data,
  });

  factory RecentRoutesModel.fromJson(Map<String, dynamic> json) {
    return RecentRoutesModel(
      message: json["message"] ?? "",
      data: RecentRoutesDataWrapper.fromJson(json["data"] ?? {}),
    );
  }
}

class RecentRoutesDataWrapper {
  final List<RecentRouteData> data;
  final int total;
  final PageMeta pageMeta;

  RecentRoutesDataWrapper({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  factory RecentRoutesDataWrapper.fromJson(Map<String, dynamic> json) {
    return RecentRoutesDataWrapper(
      data: json["data"] == null
          ? []
          : List<RecentRouteData>.from(
          json["data"].map((x) => RecentRouteData.fromJson(x))),
      total: json["total"] ?? 0,
      pageMeta: PageMeta.fromJson(json["pageMeta"] ?? {}),
    );
  }
}

class PageMeta {
  final int page;
  final int pageCount;
  final int? nextPage;
  final int pageSize;
  final int total;

  PageMeta({
    required this.page,
    required this.pageCount,
    required this.nextPage,
    required this.pageSize,
    required this.total,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) {
    return PageMeta(
      page: json["page"] ?? 0,
      pageCount: json["pageCount"] ?? 0,
      nextPage: json["nextPage"],
      pageSize: json["pageSize"] ?? 0,
      total: json["total"] ?? 0,
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

  factory RecentRouteData.fromJson(Map<String, dynamic> json) {
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
      expectedDeliveryDateTime:
      DateTime.tryParse(json["expectedDeliveryDateTime"] ?? ""),
      isAgreed: json["isAgreed"] ?? 0,
      acceptedBy: json["acceptedBy"],
      createdPlatform: json["createdPlatform"] ?? 0,
      updatedPlatform: json["updatedPlatform"] ?? 0,
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      loadRoute:
      json["loadRoute"] == null ? null : LoadRoute.fromJson(json["loadRoute"]),
      loadStatusLogs: json["loadStatusLogs"] == null
          ? []
          : List<LoadStatusLog>.from(
          json["loadStatusLogs"].map((x) => LoadStatusLog.fromJson(x))),
      loadPrice:
      json["loadPrice"] == null ? null : LoadPrice.fromJson(json["loadPrice"]),
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

  factory LoadPrice.fromJson(Map<String, dynamic> json) {
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

  factory LoadRoute.fromJson(Map<String, dynamic> json) {
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

  factory LoadStatusLog.fromJson(Map<String, dynamic> json) {
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
