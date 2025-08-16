class CityModel {
  CityModel({
    required this.data,
    required this.total,
    required this.pageMeta,
  });

  final List<CityModelList> data;
  final int total;
  final PageMeta? pageMeta;

  CityModel copyWith({
    List<CityModelList>? data,
    int? total,
    PageMeta? pageMeta,
  }) {
    return CityModel(
      data: data ?? this.data,
      total: total ?? this.total,
      pageMeta: pageMeta ?? this.pageMeta,
    );
  }

  factory CityModel.fromJson(Map<String, dynamic> json){
    return CityModel(
      data: json["data"] == null ? [] : List<CityModelList>.from(json["data"]!.map((x) => CityModelList.fromJson(x))),
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

class CityModelList {
  CityModelList({
    required this.id,
    required this.country,
    required this.countryCode,
    required this.state,
    required this.stateCode,
    required this.city,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String country;
  final String countryCode;
  final String state;
  final String stateCode;
  final String city;
  final DateTime? createdAt;
  final dynamic deletedAt;

  CityModelList copyWith({
    int? id,
    String? country,
    String? countryCode,
    String? state,
    String? stateCode,
    String? city,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return CityModelList(
      id: id ?? this.id,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      state: state ?? this.state,
      stateCode: stateCode ?? this.stateCode,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory CityModelList.fromJson(Map<String, dynamic> json){
    return CityModelList(
      id: json["id"] ?? 0,
      country: json["country"] ?? "",
      countryCode: json["countryCode"] ?? "",
      state: json["state"] ?? "",
      stateCode: json["stateCode"] ?? "",
      city: json["city"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "country": country,
    "countryCode": countryCode,
    "state": state,
    "stateCode": stateCode,
    "city": city,
    "createdAt": createdAt?.toIso8601String(),
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