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
    final String rcNumber;
    final String rcDocLink;
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

    VehicleDetailsData copyWith({
        String? vehicleId,
        String? customerId,
        String? truckNo,
        String? ownerName,
        DateTime? registrationDate,
        String? tonnage,
        int? truckTypeId,
        String? modelNumber,
        String? rcNumber,
        String? rcDocLink,
        String? insurancePolicyNumber,
        DateTime? insuranceValidityDate,
        DateTime? fcExpiryDate,
        DateTime? pucExpiryDate,
        int? status,
        DateTime? createdAt,
        dynamic updatedAt,
        dynamic deletedAt,
        String? companyName,
        TruckType? truckType,
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
            rcNumber: json["rcNumber"] ?? "",
            rcDocLink: json["rcDocLink"] ?? "",
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
    final int nextPage;
    final int pageSize;
    final int total;

    PageMeta copyWith({
        int? page,
        int? pageCount,
        int? nextPage,
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
      int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }
 
        return PageMeta(
            page: parseInt(json["page"]),
            pageCount: parseInt(json["pageCount"]),
            nextPage: json["nextPage"] == null ? 0 : parseInt(json["nextPage"]),
            pageSize: parseInt(json["pageSize"]),
            total: parseInt(json["total"]),
        );
    }

}
