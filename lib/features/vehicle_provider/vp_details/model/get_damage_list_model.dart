import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';

class GetDamageListModel {
  GetDamageListModel({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  final List<DamageReport> data;
  final int total;
  final PageMeta? pageMeta;

  factory GetDamageListModel.fromJson(Map<String, dynamic> json) {
    return GetDamageListModel(
      data: json["data"] == null
          ? []
          : List<DamageReport>.from(
          json["data"]['data']!.map((x) => DamageReport.fromJson(x))),
      total: json["total"] ?? 0,
      pageMeta:
      json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
    );
  }

  GetDamageListModel copyWith({
    List<DamageReport>? data,
    int? total,
    PageMeta? pageMeta,
  }) {
    return GetDamageListModel(
      data: data ?? this.data,
      total: total ?? this.total,
      pageMeta: pageMeta ?? this.pageMeta,
    );
  }
}



class Datum {
  Datum({
    required this.damageId,
    required this.vehicleId,
    required this.loadId,
    required this.itemName,
    required this.quantity,
    required this.status,
    required this.image,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String damageId;
  final String vehicleId;
  final String loadId;
  final String itemName;
  final int quantity;
  final int status;
  final List<String> image;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Datum copyWith({
    String? damageId,
    String? vehicleId,
    String? loadId,
    String? itemName,
    int? quantity,
    int? status,
    List<String>? image,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
  }) {
    return Datum(
      damageId: damageId ?? this.damageId,
      vehicleId: vehicleId ?? this.vehicleId,
      loadId: loadId ?? this.loadId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      image: image ?? this.image,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      damageId: json["damageId"] ?? "",
      vehicleId: json["vehicleId"] ?? "",
      loadId: json["loadId"] ?? "",
      itemName: json["itemName"] ?? "",
      quantity: json["quantity"] ?? 0,
      status: json["status"] ?? 0,
      image: json["image"] == null ? [] : List<String>.from(
          json["image"]!.map((x) => x)),
      description: json["description"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
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

class DamageImageModel {
  String? documentTypeId;
  String? url;

  DamageImageModel({this.documentTypeId, this.url});

  DamageImageModel copyWith({
    String? documentTypeId,
    String? url,
  }) {
    return DamageImageModel(
      documentTypeId: documentTypeId ?? this.documentTypeId,
      url:url ?? this.url,

    );
  }
}

