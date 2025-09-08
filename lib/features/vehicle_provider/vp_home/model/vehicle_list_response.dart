class VehicleListResponse {
    VehicleListResponse({
        required this.data,
        required this.total,
        required this.pageMeta,
    });

    final List<VehicleDetail> data;
    final int total;
    final PageMeta? pageMeta;

    VehicleListResponse copyWith({
        List<VehicleDetail>? data,
        int? total,
        PageMeta? pageMeta,
    }) {
        return VehicleListResponse(
            data: data ?? this.data,
            total: total ?? this.total,
            pageMeta: pageMeta ?? this.pageMeta,
        );
    }

    factory VehicleListResponse.fromJson(Map<String, dynamic> json){ 
        return VehicleListResponse(
            data: json["data"] == null ? [] : List<VehicleDetail>.from(json["data"]!.map((x) => VehicleDetail.fromJson(x))),
            total: json["total"] ?? 0,
            pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
        );
    }

}



class VehicleDetail {
  VehicleDetail({
    required this.id,
    required this.customerId,
    required this.truckNumber,
    required this.vehicleTypeId,
    required this.rcNumber,
    required this.rcDocLink,
    required this.capacity,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
    this.truckType,
  });

  final String? id;
  final String? customerId;
  final String truckNumber;
  final String? vehicleTypeId;
  final String rcNumber;
  final String rcDocLink;
  final String capacity;
  final num status;
  final TruckType? truckType;
  final DateTime? createdAt;
  final dynamic deletedAt;

  factory VehicleDetail.fromJson(Map<String, dynamic> json){
    return VehicleDetail(
      id: json["vehicleId"]?.toString() ?? '',
      customerId: json["customerId"] ?? "",
      truckNumber: json["truckNo"] ?? "",
      vehicleTypeId: json["vehicleTypeId"] ?? "",
      rcNumber: json["rcNumber"] ?? "",
      rcDocLink: json["rcDocLink"] ?? "",
      capacity: json["capacity"] ?? "",
      status: json["status"] ?? 0,
      truckType: json["truckType"] != null
          ? TruckType.fromJson(json["truckType"])
          : null,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "vehicleNumber": truckNumber,
    "vehicleTypeId": vehicleTypeId,
    "rcNumber": rcNumber,
    "rcDocLink": rcDocLink,
    "capacity": capacity,
    "status": status,
    "truckType": truckType?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}

class TruckType {
  TruckType({
    required this.type,
    required this.subType,
  });

  final String? type;
  final String? subType;

  factory TruckType.fromJson(Map<String, dynamic> json) {
    return TruckType(
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "subType": subType,
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
            page: json["page"] ?? 0,
            pageCount: json["pageCount"] ?? 0,
            nextPage: json["nextPage"],
            pageSize: json["pageSize"] ?? 0,
            total: json["total"] ?? 0,
        );
    }

}

