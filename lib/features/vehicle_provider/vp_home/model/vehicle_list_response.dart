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
        required this.companyName,
        required this.truckType,
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
    final String companyName;
    final TruckType? truckType;

    VehicleDetail copyWith({
        String? vehicleId,
        String? customerId,
        String? truckNo,
        String? ownerName,
        DateTime? registrationDate,
        String? tonnage,
        int? truckTypeId,
        String? modelNumber,
        dynamic? rcNumber,
        dynamic? rcDocLink,
        String? insurancePolicyNumber,
        DateTime? insuranceValidityDate,
        DateTime? fcExpiryDate,
        DateTime? pucExpiryDate,
        int? status,
        DateTime? createdAt,
        dynamic? updatedAt,
        dynamic? deletedAt,
        String? companyName,
        TruckType? truckType,
    }) {
        return VehicleDetail(
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
            companyName: companyName ?? this.companyName,
            truckType: truckType ?? this.truckType,
        );
    }

    factory VehicleDetail.fromJson(Map<String, dynamic> json){ 
        return VehicleDetail(
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
            companyName: json["companyName"] ?? "",
            truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
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
        required this.updatedAt,
        required this.deletedAt,
    });

    final int id;
    final String type;
    final String subType;
    final dynamic iconUrl;
    final int status;
    final DateTime? createdAt;
    final dynamic updatedAt;
    final dynamic deletedAt;

    TruckType copyWith({
        int? id,
        String? type,
        String? subType,
        dynamic? iconUrl,
        int? status,
        DateTime? createdAt,
        dynamic? updatedAt,
        dynamic? deletedAt,
    }) {
        return TruckType(
            id: id ?? this.id,
            type: type ?? this.type,
            subType: subType ?? this.subType,
            iconUrl: iconUrl ?? this.iconUrl,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
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
            updatedAt: json["updatedAt"],
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

    final String page;
    final int pageCount;
    final dynamic nextPage;
    final String pageSize;
    final int total;

    PageMeta copyWith({
        String? page,
        int? pageCount,
        dynamic? nextPage,
        String? pageSize,
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
            page: json["page"] ?? "",
            pageCount: json["pageCount"] ?? 0,
            nextPage: json["nextPage"],
            pageSize: json["pageSize"] ?? "",
            total: json["total"] ?? 0,
        );
    }

}
