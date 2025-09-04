class LocationAddressResponse {
  LocationAddressResponse({
    required this.plusCode,
    required this.results,
    required this.status,
  });

  final PlusCode? plusCode;
  final List<Result> results;
  final String status;

  LocationAddressResponse copyWith({
    PlusCode? plusCode,
    List<Result>? results,
    String? status,
  }) {
    return LocationAddressResponse(
      plusCode: plusCode ?? this.plusCode,
      results: results ?? this.results,
      status: status ?? this.status,
    );
  }

  factory LocationAddressResponse.fromJson(Map<String, dynamic> json){
    return LocationAddressResponse(
      plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
      results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
      status: json["status"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "plus_code": plusCode?.toJson(),
    "results": results.map((x) => x.toJson()).toList(),
    "status": status,
  };

}

class PlusCode {
  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  final String compoundCode;
  final String globalCode;

  PlusCode copyWith({
    String? compoundCode,
    String? globalCode,
  }) {
    return PlusCode(
      compoundCode: compoundCode ?? this.compoundCode,
      globalCode: globalCode ?? this.globalCode,
    );
  }

  factory PlusCode.fromJson(Map<String, dynamic> json){
    return PlusCode(
      compoundCode: json["compound_code"] ?? "",
      globalCode: json["global_code"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "compound_code": compoundCode,
    "global_code": globalCode,
  };

}

class Result {
  Result({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.navigationPoints,
    required this.placeId,
    required this.types,
  });

  final List<AddressComponent> addressComponents;
  final String formattedAddress;
  final Geometry? geometry;
  final List<NavigationPoint> navigationPoints;
  final String placeId;
  final List<String> types;

  Result copyWith({
    List<AddressComponent>? addressComponents,
    String? formattedAddress,
    Geometry? geometry,
    List<NavigationPoint>? navigationPoints,
    String? placeId,
    List<String>? types,
  }) {
    return Result(
      addressComponents: addressComponents ?? this.addressComponents,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      geometry: geometry ?? this.geometry,
      navigationPoints: navigationPoints ?? this.navigationPoints,
      placeId: placeId ?? this.placeId,
      types: types ?? this.types,
    );
  }

  factory Result.fromJson(Map<String, dynamic> json){
    return Result(
      addressComponents: json["address_components"] == null ? [] : List<AddressComponent>.from(json["address_components"]!.map((x) => AddressComponent.fromJson(x))),
      formattedAddress: json["formatted_address"] ?? "",
      geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
      navigationPoints: json["navigation_points"] == null ? [] : List<NavigationPoint>.from(json["navigation_points"]!.map((x) => NavigationPoint.fromJson(x))),
      placeId: json["place_id"] ?? "",
      types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "address_components": addressComponents.map((x) => x.toJson()).toList(),
    "formatted_address": formattedAddress,
    "geometry": geometry?.toJson(),
    "navigation_points": navigationPoints.map((x) => x.toJson()).toList(),
    "place_id": placeId,
    "types": types.map((x) => x).toList(),
  };

}

class AddressComponent {
  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  final String longName;
  final String shortName;
  final List<String> types;

  AddressComponent copyWith({
    String? longName,
    String? shortName,
    List<String>? types,
  }) {
    return AddressComponent(
      longName: longName ?? this.longName,
      shortName: shortName ?? this.shortName,
      types: types ?? this.types,
    );
  }

  factory AddressComponent.fromJson(Map<String, dynamic> json){
    return AddressComponent(
      longName: json["long_name"] ?? "",
      shortName: json["short_name"] ?? "",
      types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "long_name": longName,
    "short_name": shortName,
    "types": types.map((x) => x).toList(),
  };

}

class Geometry {
  Geometry({
    required this.bounds,
    required this.location,
    required this.locationType,
    required this.viewport,
  });

  final Bounds? bounds;
  final NortheastClass? location;
  final String locationType;
  final Bounds? viewport;

  Geometry copyWith({
    Bounds? bounds,
    NortheastClass? location,
    String? locationType,
    Bounds? viewport,
  }) {
    return Geometry(
      bounds: bounds ?? this.bounds,
      location: location ?? this.location,
      locationType: locationType ?? this.locationType,
      viewport: viewport ?? this.viewport,
    );
  }

  factory Geometry.fromJson(Map<String, dynamic> json){
    return Geometry(
      bounds: json["bounds"] == null ? null : Bounds.fromJson(json["bounds"]),
      location: json["location"] == null ? null : NortheastClass.fromJson(json["location"]),
      locationType: json["location_type"] ?? "",
      viewport: json["viewport"] == null ? null : Bounds.fromJson(json["viewport"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "bounds": bounds?.toJson(),
    "location": location?.toJson(),
    "location_type": locationType,
    "viewport": viewport?.toJson(),
  };

}

class Bounds {
  Bounds({
    required this.northeast,
    required this.southwest,
  });

  final NortheastClass? northeast;
  final NortheastClass? southwest;

  Bounds copyWith({
    NortheastClass? northeast,
    NortheastClass? southwest,
  }) {
    return Bounds(
      northeast: northeast ?? this.northeast,
      southwest: southwest ?? this.southwest,
    );
  }

  factory Bounds.fromJson(Map<String, dynamic> json){
    return Bounds(
      northeast: json["northeast"] == null ? null : NortheastClass.fromJson(json["northeast"]),
      southwest: json["southwest"] == null ? null : NortheastClass.fromJson(json["southwest"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "northeast": northeast?.toJson(),
    "southwest": southwest?.toJson(),
  };

}

class NortheastClass {
  NortheastClass({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  NortheastClass copyWith({
    double? lat,
    double? lng,
  }) {
    return NortheastClass(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  factory NortheastClass.fromJson(Map<String, dynamic> json){
    return NortheastClass(
      lat: json["lat"] ?? 0.0,
      lng: json["lng"] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };

}

class NavigationPoint {
  NavigationPoint({
    required this.location,
    required this.restrictedTravelModes,
  });

  final NavigationPointLocation? location;
  final List<String> restrictedTravelModes;

  NavigationPoint copyWith({
    NavigationPointLocation? location,
    List<String>? restrictedTravelModes,
  }) {
    return NavigationPoint(
      location: location ?? this.location,
      restrictedTravelModes: restrictedTravelModes ?? this.restrictedTravelModes,
    );
  }

  factory NavigationPoint.fromJson(Map<String, dynamic> json){
    return NavigationPoint(
      location: json["location"] == null ? null : NavigationPointLocation.fromJson(json["location"]),
      restrictedTravelModes: json["restricted_travel_modes"] == null ? [] : List<String>.from(json["restricted_travel_modes"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "restricted_travel_modes": restrictedTravelModes.map((x) => x).toList(),
  };

}

class NavigationPointLocation {
  NavigationPointLocation({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  NavigationPointLocation copyWith({
    double? latitude,
    double? longitude,
  }) {
    return NavigationPointLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory NavigationPointLocation.fromJson(Map<String, dynamic> json){
    return NavigationPointLocation(
      latitude: json["latitude"] ?? 0.0,
      longitude: json["longitude"] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };

}
