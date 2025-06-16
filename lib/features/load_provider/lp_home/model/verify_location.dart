class VerifyLocationModel {
  VerifyLocationModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  VerifyLocationModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return VerifyLocationModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory VerifyLocationModel.fromJson(Map<String, dynamic> json){
    return VerifyLocationModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.locationdetails,
    required this.lane,
    required this.gMapResponse,
  });

  final LocationDetails? locationdetails;
  final Lane? lane;
  final GMapResponse? gMapResponse;

  Data copyWith({
    LocationDetails? locationdetails,
    Lane? lane,
    GMapResponse? gMapResponse,
  }) {
    return Data(
      locationdetails: locationdetails ?? this.locationdetails,
      lane: lane ?? this.lane,
      gMapResponse: gMapResponse ?? this.gMapResponse,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      locationdetails: json["locationdetails"] == null ? null : LocationDetails.fromJson(json["locationdetails"]),
      lane: json["lane"] == null ? null : Lane.fromJson(json["lane"]),
      gMapResponse: json["gMapResponse"] == null ? null : GMapResponse.fromJson(json["gMapResponse"]),
    );
  }

}

class GMapResponse {
  GMapResponse({
    required this.htmlAttributions,
    required this.result,
    required this.status,
  });

  final List<dynamic> htmlAttributions;
  final Result? result;
  final String status;

  GMapResponse copyWith({
    List<dynamic>? htmlAttributions,
    Result? result,
    String? status,
  }) {
    return GMapResponse(
      htmlAttributions: htmlAttributions ?? this.htmlAttributions,
      result: result ?? this.result,
      status: status ?? this.status,
    );
  }

  factory GMapResponse.fromJson(Map<String, dynamic> json){
    return GMapResponse(
      htmlAttributions: json["html_attributions"] == null ? [] : List<dynamic>.from(json["html_attributions"]!.map((x) => x)),
      result: json["result"] == null ? null : Result.fromJson(json["result"]),
      status: json["status"] ?? "",
    );
  }

}

class Result {
  Result({
    required this.addressComponents,
    required this.adrAddress,
    required this.formattedAddress,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.photos,
    required this.placeId,
    required this.reference,
    required this.types,
    required this.url,
    required this.utcOffset,
    required this.vicinity,
    required this.website,
  });

  final List<AddressComponent> addressComponents;
  final String adrAddress;
  final String formattedAddress;
  final Geometry? geometry;
  final String icon;
  final String iconBackgroundColor;
  final String iconMaskBaseUri;
  final String name;
  final List<Photo> photos;
  final String placeId;
  final String reference;
  final List<String> types;
  final String url;
  final num utcOffset;
  final String vicinity;
  final String website;

  Result copyWith({
    List<AddressComponent>? addressComponents,
    String? adrAddress,
    String? formattedAddress,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    List<Photo>? photos,
    String? placeId,
    String? reference,
    List<String>? types,
    String? url,
    num? utcOffset,
    String? vicinity,
    String? website,
  }) {
    return Result(
      addressComponents: addressComponents ?? this.addressComponents,
      adrAddress: adrAddress ?? this.adrAddress,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      geometry: geometry ?? this.geometry,
      icon: icon ?? this.icon,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconMaskBaseUri: iconMaskBaseUri ?? this.iconMaskBaseUri,
      name: name ?? this.name,
      photos: photos ?? this.photos,
      placeId: placeId ?? this.placeId,
      reference: reference ?? this.reference,
      types: types ?? this.types,
      url: url ?? this.url,
      utcOffset: utcOffset ?? this.utcOffset,
      vicinity: vicinity ?? this.vicinity,
      website: website ?? this.website,
    );
  }

  factory Result.fromJson(Map<String, dynamic> json){
    return Result(
      addressComponents: json["address_components"] == null ? [] : List<AddressComponent>.from(json["address_components"]!.map((x) => AddressComponent.fromJson(x))),
      adrAddress: json["adr_address"] ?? "",
      formattedAddress: json["formatted_address"] ?? "",
      geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
      icon: json["icon"] ?? "",
      iconBackgroundColor: json["icon_background_color"] ?? "",
      iconMaskBaseUri: json["icon_mask_base_uri"] ?? "",
      name: json["name"] ?? "",
      photos: json["photos"] == null ? [] : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
      placeId: json["place_id"] ?? "",
      reference: json["reference"] ?? "",
      types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
      url: json["url"] ?? "",
      utcOffset: json["utc_offset"] ?? 0,
      vicinity: json["vicinity"] ?? "",
      website: json["website"] ?? "",
    );
  }

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

}

class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });

  final Location? location;
  final Viewport? viewport;

  Geometry copyWith({
    Location? location,
    Viewport? viewport,
  }) {
    return Geometry(
      location: location ?? this.location,
      viewport: viewport ?? this.viewport,
    );
  }

  factory Geometry.fromJson(Map<String, dynamic> json){
    return Geometry(
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      viewport: json["viewport"] == null ? null : Viewport.fromJson(json["viewport"]),
    );
  }

}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  final num lat;
  final num lng;

  Location copyWith({
    num? lat,
    num? lng,
  }) {
    return Location(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      lat: json["lat"] ?? 0,
      lng: json["lng"] ?? 0,
    );
  }

}

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });

  final Location? northeast;
  final Location? southwest;

  Viewport copyWith({
    Location? northeast,
    Location? southwest,
  }) {
    return Viewport(
      northeast: northeast ?? this.northeast,
      southwest: southwest ?? this.southwest,
    );
  }

  factory Viewport.fromJson(Map<String, dynamic> json){
    return Viewport(
      northeast: json["northeast"] == null ? null : Location.fromJson(json["northeast"]),
      southwest: json["southwest"] == null ? null : Location.fromJson(json["southwest"]),
    );
  }

}

class Photo {
  Photo({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });

  final num height;
  final List<String> htmlAttributions;
  final String photoReference;
  final int width;

  Photo copyWith({
    num? height,
    List<String>? htmlAttributions,
    String? photoReference,
    int? width,
  }) {
    return Photo(
      height: height ?? this.height,
      htmlAttributions: htmlAttributions ?? this.htmlAttributions,
      photoReference: photoReference ?? this.photoReference,
      width: width ?? this.width,
    );
  }

  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
      height: json["height"] ?? 0,
      htmlAttributions: json["html_attributions"] == null ? [] : List<String>.from(json["html_attributions"]!.map((x) => x)),
      photoReference: json["photo_reference"] ?? "",
      width: json["width"] ?? 0,
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
  final LocationDetails? fromLocation;
  final LocationDetails? toLocation;

  Lane copyWith({
    int? id,
    num? fromLocationId,
    num? toLocationId,
    LocationDetails? fromLocation,
    LocationDetails? toLocation,
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
      fromLocation: json["fromLocation"] == null ? null : LocationDetails.fromJson(json["fromLocation"]),
      toLocation: json["toLocation"] == null ? null : LocationDetails.fromJson(json["toLocation"]),
    );
  }

}

class LocationDetails {
  LocationDetails({
    required this.id,
    required this.name,
    required this.slug,
  });

  final int id;
  final String name;
  final String slug;

  LocationDetails copyWith({
    int? id,
    String? name,
    String? slug,
  }) {
    return LocationDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
    );
  }

  factory LocationDetails.fromJson(Map<String, dynamic> json){
    return LocationDetails(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
    );
  }

}
