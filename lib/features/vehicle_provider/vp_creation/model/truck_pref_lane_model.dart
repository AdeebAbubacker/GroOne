class TruckPrefLaneModel {
    TruckPrefLaneModel({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool success;
    final String message;
    final Data? data;

    TruckPrefLaneModel copyWith({
        bool? success,
        String? message,
        Data? data,
    }) {
        return TruckPrefLaneModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory TruckPrefLaneModel.fromJson(Map<String, dynamic> json){

        return TruckPrefLaneModel(
            success: json["success"] ?? false,
            message: json["message"] ?? "",
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.data,
        required this.total,
        required this.pageMeta,
    });

    final List<Datum> data;
    final int total;
    final PageMeta? pageMeta;

    Data copyWith({
        List<Datum>? data,
        int? total,
        PageMeta? pageMeta,
    }) {
        return Data(
            data: data ?? this.data,
            total: total ?? this.total,
            pageMeta: pageMeta ?? this.pageMeta,
        );
    }

    factory Data.fromJson(Map<String, dynamic> json){
        print("json response ${json}");
        return Data(
            data: json["items"] == null ? [] : List<Datum>.from(json["items"]!.map((x) => Datum.fromJson(x))),
            total: json["total"] ?? 0,
            pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
        );
    }

}

class Datum {
    Datum({
        required this.id,
        required this.fromLocationId,
        required this.toLocationId,
        required this.fromLocation,
        required this.toLocation,
    });

    final int id;
    final int fromLocationId;
    final int toLocationId;
    final Location? fromLocation;
    final Location? toLocation;

    Datum copyWith({
        int? id,
        int? fromLocationId,
        int? toLocationId,
        Location? fromLocation,
        Location? toLocation,
    }) {
        return Datum(
            id: id ?? this.id,
            fromLocationId: fromLocationId ?? this.fromLocationId,
            toLocationId: toLocationId ?? this.toLocationId,
            fromLocation: fromLocation ?? this.fromLocation,
            toLocation: toLocation ?? this.toLocation,
        );
    }

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            id: json["id"] ?? 0,
            fromLocationId: json["fromLocationId"] ?? 0,
            toLocationId: json["toLocationId"] ?? 0,
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
    });

    final int id;
    final String name;
    final String slug;
    final String latLong;

    Location copyWith({
        int? id,
        String? name,
        String? slug,
        String? latLong,
    }) {
        return Location(
            id: id ?? this.id,
            name: name ?? this.name,
            slug: slug ?? this.slug,
            latLong: latLong ?? this.latLong,
        );
    }

    factory Location.fromJson(Map<String, dynamic> json){ 
        return Location(
            id: json["id"] ?? 0,
            name: json["name"] ?? "",
            slug: json["slug"] ?? "",
            latLong: json["latLong"] ?? "",
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
