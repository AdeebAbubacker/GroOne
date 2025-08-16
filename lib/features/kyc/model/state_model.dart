class StateModel {
  StateModel({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  final List<StateModelList> data;
  final int total;
  final PageMeta? pageMeta;

  StateModel copyWith({
    List<StateModelList>? data,
    int? total,
    PageMeta? pageMeta,
  }) {
    return StateModel(
      data: data ?? this.data,
      total: total ?? this.total,
      pageMeta: pageMeta ?? this.pageMeta,
    );
  }

  factory StateModel.fromJson(Map<String, dynamic> json){

    return StateModel(
      data: json["data"] == null ? [] : List<StateModelList>.from(json["data"]!.map((x) => StateModelList.fromJson(x))),
      total: json["total"] ?? 0,
      pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data.map((x) => x?.toJson()).toList(),
    "total": total,
    "pageMeta": pageMeta?.toJson(),
  };

}

class StateModelList {
  StateModelList({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  StateModelList copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
  }) {
    return StateModelList(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory StateModelList.fromJson(Map<String, dynamic> json){
    return StateModelList(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deletedAt": deletedAt,
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
      pageSize: parseInt(json["pageSize"]),
      total: json["total"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "page": page,
    "pageCount": pageCount,
    "nextPage": nextPage,
    "pageSize": pageSize,
    "total": total,
  };

}


int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}