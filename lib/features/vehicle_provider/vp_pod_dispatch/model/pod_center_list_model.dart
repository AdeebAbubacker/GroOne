class PodCenterListModel {
  PodCenterListModel({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  final List<PodCenterData> data;
  final int total;
  final PageMeta? pageMeta;

  PodCenterListModel copyWith({
    List<PodCenterData>? data,
    int? total,
    PageMeta? pageMeta,
  }) {
    return PodCenterListModel(
      data: data ?? this.data,
      total: total ?? this.total,
      pageMeta: pageMeta ?? this.pageMeta,
    );
  }

  factory PodCenterListModel.fromJson(Map<String, dynamic> json){
    return PodCenterListModel(
      data: json["data"] == null ? [] : List<PodCenterData>.from(json["data"]!.map((x) => PodCenterData.fromJson(x))),
      total: json["total"] ?? 0,
      pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
    );
  }

}

class PodCenterData {
  PodCenterData({
    required this.podCenterId,
    required this.podCenterName,
    required this.status,
    required this.createAt,
    required this.deletedAt,
  });

  final String podCenterId;
  final String podCenterName;
  final int status;
  final DateTime? createAt;
  final dynamic deletedAt;

  PodCenterData copyWith({
    String? podCenterId,
    String? podCenterName,
    int? status,
    DateTime? createAt,
    dynamic deletedAt,
  }) {
    return PodCenterData(
      podCenterId: podCenterId ?? this.podCenterId,
      podCenterName: podCenterName ?? this.podCenterName,
      status: status ?? this.status,
      createAt: createAt ?? this.createAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory PodCenterData.fromJson(Map<String, dynamic> json){
    return PodCenterData(
      podCenterId: json["podCenterId"] ?? "",
      podCenterName: json["podCenterName"] ?? "",
      status: json["status"] ?? 0,
      createAt: DateTime.tryParse(json["createAt"] ?? ""),
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
    return PageMeta(
      page: json["page"] ?? 0,
      pageCount: json["pageCount"] ?? 0,
      nextPage: json["nextPage"] ?? 0,
      pageSize: json["pageSize"] ?? 0,
      total: json["total"] ?? 0,
    );
  }

}
