class TruckPrefLaneModel {
    TruckPrefLaneModel({
        required this.data,
    });

    final Data? data;

    TruckPrefLaneModel copyWith({
        Data? data,
    }) {
        return TruckPrefLaneModel(
            data: data ?? this.data,
        );
    }

    factory TruckPrefLaneModel.fromJson(Map<String, dynamic> json){
        return TruckPrefLaneModel(
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

    final List<Item> items;
    final int total;
    final int? page;
    final int limit;

    Data copyWith({
        List<Item>? items,
        int? total,
        int? page,
        int? limit,
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
            items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
            total: json["total"] ?? 0,
            page: int.tryParse(json["page"]?.toString() ?? "0"),
            limit: int.tryParse(json["limit"]?.toString() ?? "0")??0

        );
    }

}

class Item {
    Item({
        required this.masterLaneId,
        required this.fromLocationId,
        required this.toLocationId,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
        required this.fromLocation,
        required this.toLocation,
        required this.isSelected,
    });

    final int masterLaneId;
    final int fromLocationId;
    final int toLocationId;
    final int status;
    final DateTime? createdAt;
    final dynamic deletedAt;
    final Location? fromLocation;
    final Location? toLocation;
    final bool? isSelected;

    Item copyWith({
        int? masterLaneId,
        int? fromLocationId,
        int? toLocationId,
        int? status,
        DateTime? createdAt,
        dynamic? deletedAt,
        Location? fromLocation,
        Location? toLocation,
        bool? isSelected
    }) {
        return Item(
            isSelected: isSelected ?? this.isSelected,
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

    factory Item.fromJson(Map<String, dynamic> json){
        return Item(
            isSelected: false,
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
