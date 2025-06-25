class RateDiscoveryModel {
  RateDiscoveryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  RateDiscoveryModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return RateDiscoveryModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory RateDiscoveryModel.fromJson(Map<String, dynamic> json){
    return RateDiscoveryModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.laneId,
    required this.truckTypeId,
    required this.price,
    required this.lane,
    required this.truckType,
  });

  final int id;
  final num laneId;
  final num truckTypeId;
  final num price;
  final Lane? lane;
  final TruckType? truckType;

  Data copyWith({
    int? id,
    num? laneId,
    num? truckTypeId,
    num? price,
    Lane? lane,
    TruckType? truckType,
  }) {
    return Data(
      id: id ?? this.id,
      laneId: laneId ?? this.laneId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      price: price ?? this.price,
      lane: lane ?? this.lane,
      truckType: truckType ?? this.truckType,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"] ?? 0,
      laneId: json["laneId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      price: json["price"] ?? 0,
      lane: json["lane"] == null ? null : Lane.fromJson(json["lane"]),
      truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
    );
  }

}

class Lane {
  Lane({
    required this.id,
    required this.fromLocationId,
    required this.toLocationId,
    required this.fromLocation,
    required this.toLocation,
  });

  final int id;
  final num fromLocationId;
  final num toLocationId;
  final Location? fromLocation;
  final Location? toLocation;

  Lane copyWith({
    int? id,
    num? fromLocationId,
    num? toLocationId,
    Location? fromLocation,
    Location? toLocation,
  }) {
    return Lane(
      id: id ?? this.id,
      fromLocationId: fromLocationId ?? this.fromLocationId,
      toLocationId: toLocationId ?? this.toLocationId,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
    );
  }

  factory Lane.fromJson(Map<String, dynamic> json){
    return Lane(
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
  });

  final int id;
  final String name;
  final String slug;

  Location copyWith({
    int? id,
    String? name,
    String? slug,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
    );
  }

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
    );
  }

}

class TruckType {
  TruckType({
    required this.id,
    required this.type,
    required this.subType,
    required this.iconUrl,
  });

  final int id;
  final String type;
  final String subType;
  final dynamic iconUrl;

  TruckType copyWith({
    int? id,
    String? type,
    String? subType,
    dynamic? iconUrl,
  }) {
    return TruckType(
      id: id ?? this.id,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  factory TruckType.fromJson(Map<String, dynamic> json){
    return TruckType(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
      iconUrl: json["iconUrl"],
    );
  }

}
