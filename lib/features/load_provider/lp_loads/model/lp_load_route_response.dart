// class LpLoadRouteResponse {
//   LpLoadRouteResponse({
//     required this.message,
//     required this.data,
//   });

//   final String message;
//   final Data? data;

//   LpLoadRouteResponse copyWith({
//     String? message,
//     Data? data,
//   }) {
//     return LpLoadRouteResponse(
//       message: message ?? this.message,
//       data: data ?? this.data,
//     );
//   }

//   factory LpLoadRouteResponse.fromJson(Map<String, dynamic> json){
//     return LpLoadRouteResponse(
//       message: json["message"] ?? "",
//       data: json["data"] == null ? null : Data.fromJson(json["data"]),
//     );
//   }

// }

// class Data {
//   Data({
//     required this.routeList,
//     required this.total,
//     required this.page,
//     required this.limit,
//   });

//   final List<RouteList> routeList;
//   final int total;
//   final int page;
//   final int limit;

//   Data copyWith({
//     List<RouteList>? items,
//     int? total,
//     int? page,
//     int? limit,
//   }) {
//     return Data(
//       routeList: items ?? routeList,
//       total: total ?? this.total,
//       page: page ?? this.page,
//       limit: limit ?? this.limit,
//     );
//   }

//   factory Data.fromJson(Map<String, dynamic> json){
//     return Data(
//       routeList: json["items"] == null ? [] : List<RouteList>.from(json["items"]!.map((x) => RouteList.fromJson(x))),
//       total: json["total"] ?? 0,
//       page: json["page"] ?? 0,
//       limit: json["limit"] ?? 0,
//     );
//   }

// }

// class RouteList {
//   RouteList({
//     required this.masterLaneId,
//     required this.fromLocationId,
//     required this.toLocationId,
//     required this.status,
//     required this.createdAt,
//     required this.deletedAt,
//     required this.fromLocation,
//     required this.toLocation,
//   });

//   final int masterLaneId;
//   final int fromLocationId;
//   final int toLocationId;
//   final int status;
//   final DateTime? createdAt;
//   final dynamic deletedAt;
//   final dynamic fromLocation;
//   final dynamic toLocation;

//   RouteList copyWith({
//     int? masterLaneId,
//     int? fromLocationId,
//     int? toLocationId,
//     int? status,
//     DateTime? createdAt,
//     dynamic deletedAt,
//     dynamic fromLocation,
//     dynamic toLocation,
//   }) {
//     return RouteList(
//       masterLaneId: masterLaneId ?? this.masterLaneId,
//       fromLocationId: fromLocationId ?? this.fromLocationId,
//       toLocationId: toLocationId ?? this.toLocationId,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       deletedAt: deletedAt ?? this.deletedAt,
//       fromLocation: fromLocation ?? this.fromLocation,
//       toLocation: toLocation ?? this.toLocation,
//     );
//   }

//   factory RouteList.fromJson(Map<String, dynamic> json){
//     return RouteList(
//       masterLaneId: json["masterLaneId"] ?? 0,
//       fromLocationId: json["fromLocationId"] ?? 0,
//       toLocationId: json["toLocationId"] ?? 0,
//       status: json["status"] ?? 0,
//       createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
//       deletedAt: json["deletedAt"],
//       fromLocation: json["fromLocation"],
//       toLocation: json["toLocation"],
//     );
//   }

// }

class LpLoadRouteResponse {
    LpLoadRouteResponse({
        required this.data,
    });

    final Data? data;

    LpLoadRouteResponse copyWith({
        Data? data,
    }) {
        return LpLoadRouteResponse(
            data: data ?? this.data,
        );
    }

    factory LpLoadRouteResponse.fromJson(Map<String, dynamic> json){ 
        return LpLoadRouteResponse(
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.items,
        required this.total,
        required this.page,
        required this.limit,
    });

    final List<RouteList> items;
    final int total;
    final String page;
    final String limit;

    Data copyWith({
        List<RouteList>? items,
        int? total,
        String? page,
        String? limit,
    }) {
        return Data(
            items: items ?? this.items,
            total: total ?? this.total,
            page: page ?? this.page,
            limit: limit ?? this.limit,
        );
    }

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            items: json["items"] == null ? [] : List<RouteList>.from(json["items"]!.map((x) => RouteList.fromJson(x))),
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
        dynamic? deletedAt,
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
