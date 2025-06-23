class LpLoadRouteResponse {
  LpLoadRouteResponse({
    required this.success,
    required this.message,
    required this.routeDataList,
  });

  final bool success;
  final String message;
  final List<RouteDataList> routeDataList;

  LpLoadRouteResponse copyWith({
    bool? success,
    String? message,
    List<RouteDataList>? routeDataList,
  }) {
    return LpLoadRouteResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      routeDataList: routeDataList ?? this.routeDataList,
    );
  }

  factory LpLoadRouteResponse.fromJson(Map<String, dynamic> json){
    return LpLoadRouteResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      routeDataList: json["data"] == null ? [] : List<RouteDataList>.from(json["data"]!.map((x) => RouteDataList.fromJson(x))),
    );
  }

}

class RouteDataList {
  RouteDataList({
    required this.id,
    required this.fromLocationId,
    required this.toLocationId,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
    required this.fromLocation,
    required this.toLocation,
  });

  final int id;
  final num fromLocationId;
  final num toLocationId;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final Location? fromLocation;
  final Location? toLocation;

  RouteDataList copyWith({
    int? id,
    num? fromLocationId,
    num? toLocationId,
    num? status,
    DateTime? createdAt,
    dynamic? deletedAt,
    Location? fromLocation,
    Location? toLocation,
  }) {
    return RouteDataList(
      id: id ?? this.id,
      fromLocationId: fromLocationId ?? this.fromLocationId,
      toLocationId: toLocationId ?? this.toLocationId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
    );
  }

  factory RouteDataList.fromJson(Map<String, dynamic> json){
    return RouteDataList(
      id: json["id"] ?? 0,
      fromLocationId: json["fromLocationId"] ?? 0,
      toLocationId: json["toLocationId"] ?? 0,
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      fromLocation: json["fromLocation"] == null ? null : Location.fromJson(json["fromLocation"]),
      toLocation: json["toLocation"] == null ? null : Location.fromJson(json["toLocation"]),
    );
  }

}

class Location {
  Location({
    required this.id,
    required this.name,
    required this.slug,
    required this.latLong,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String name;
  final String slug;
  final String latLong;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  Location copyWith({
    int? id,
    String? name,
    String? slug,
    String? latLong,
    num? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      latLong: latLong ?? this.latLong,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      latLong: json["latLong"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}
