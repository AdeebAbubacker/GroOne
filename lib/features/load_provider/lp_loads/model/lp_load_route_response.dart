class LpLoadRouteResponse {
    LpLoadRouteResponse({
        required this.data,
    });

    final LpLoadData? data;

    LpLoadRouteResponse copyWith({
        LpLoadData? data,
    }) {
        return LpLoadRouteResponse(
            data: data ?? this.data,
        );
    }

    factory LpLoadRouteResponse.fromJson(Map<String, dynamic> json){ 
        return LpLoadRouteResponse(
            data: json["data"] == null ? null : LpLoadData.fromJson(json["data"]),
        );
    }

}

class LpLoadData {
    LpLoadData({
        required this.routeList,
        required this.total,
        required this.page,
        required this.limit,
    });

    final List<RouteList> routeList;
    final int total;
    final String page;
    final String limit;

    LpLoadData copyWith({
        List<RouteList>? routeList,
        int? total,
        String? page,
        String? limit,
    }) {
        return LpLoadData(
            routeList: routeList ?? this.routeList,
            total: total ?? this.total,
            page: page ?? this.page,
            limit: limit ?? this.limit,
        );
    }

    factory LpLoadData.fromJson(Map<String, dynamic> json){ 
        return LpLoadData(
            routeList: json["items"] == null ? [] : List<RouteList>.from(json["items"]!.map((x) => RouteList.fromJson(x))),
            total: json["total"] ?? 0,
            page: json["page"] ?? "",
            limit: json["limit"] ?? "",
        );
    }

}

class RouteList {
    RouteList({
        required this.masterLaneId,
        required this.fromLocationId,
        required this.toLocationId,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
        required this.fromLocation,
        required this.toLocation,
    });

    final int masterLaneId;
    final int fromLocationId;
    final int toLocationId;
    final int status;
    final DateTime? createdAt;
    final dynamic deletedAt;
    final Location? fromLocation;
    final Location? toLocation;

    RouteList copyWith({
        int? masterLaneId,
        int? fromLocationId,
        int? toLocationId,
        int? status,
        DateTime? createdAt,
        dynamic deletedAt,
        Location? fromLocation,
        Location? toLocation,
    }) {
        return RouteList(
            masterLaneId: masterLaneId ?? this.masterLaneId,
            fromLocationId: fromLocationId ?? this.fromLocationId,
            toLocationId: toLocationId ?? this.toLocationId,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
            fromLocation: fromLocation ?? this.fromLocation,
            toLocation: toLocation ?? this.toLocation,
        );
    }

    factory RouteList.fromJson(Map<String, dynamic> json){ 
        return RouteList(
            masterLaneId: json["masterLaneId"] ?? 0,
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
    final int status;
    final DateTime? createdAt;
    final dynamic deletedAt;

    Location copyWith({
        int? id,
        String? name,
        String? slug,
        String? latLong,
        int? status,
        DateTime? createdAt,
        dynamic deletedAt,
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
