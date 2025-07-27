class PaginatedVehicleList {
    PaginatedVehicleList({
        required this.data,
        required this.total,
        required this.pageMeta,
    });

    final List<VehicleDetailsData> data;
    final int total;
    final PageMeta? pageMeta;

    PaginatedVehicleList copyWith({
        List<VehicleDetailsData>? data,
        int? total,
        PageMeta? pageMeta,
    }) {
        return PaginatedVehicleList(
            data: data ?? this.data,
            total: total ?? this.total,
            pageMeta: pageMeta ?? this.pageMeta,
        );
    }

    factory PaginatedVehicleList.fromJson(Map<String, dynamic> json){ 
        return PaginatedVehicleList(
            data: json["data"] == null ? [] : List<VehicleDetailsData>.from(json["data"]!.map((x) => VehicleDetailsData.fromJson(x))),
            total: json["total"] ?? 0,
            pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
        );
    }

}

class VehicleDetailsData {
    VehicleDetailsData({
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

    VehicleDetailsData copyWith({
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
        return VehicleDetailsData(
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

    factory VehicleDetailsData.fromJson(Map<String, dynamic> json){ 
        return VehicleDetailsData(
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
