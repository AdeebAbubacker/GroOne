class GetDamageListModel {
  GetDamageListModel({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  final List<GetDamageData> data;
  final int total;
  final PageMeta? pageMeta;

  factory GetDamageListModel.fromJson(Map<String, dynamic> json){
    return GetDamageListModel(
      data: json["data"] == null ? [] : List<GetDamageData>.from(json["data"]!.map((x) => GetDamageData.fromJson(x))),
      total: json["total"] ?? 0,
      pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
    );
  }

}

class GetDamageData {
  GetDamageData({
    required this.damageId,
    required this.vehicleId,
    required this.loadId,
    required this.itemName,
    required this.quantity,
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
  final List<String> image;
  final String description;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;

  factory GetDamageData.fromJson(Map<String, dynamic> json){
    return GetDamageData(
      damageId: json["damageId"] ?? "",
      vehicleId: json["vehicleId"] ?? "",
      loadId: json["loadId"] ?? "",
      itemName: json["itemName"] ?? "",
      quantity: json["quantity"] ?? 0,
      image: json["image"] == null ? [] : List<String>.from(json["image"]!.map((x) => x)),
      description: json["description"] ?? "",
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
