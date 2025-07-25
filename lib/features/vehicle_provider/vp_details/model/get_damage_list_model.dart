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

