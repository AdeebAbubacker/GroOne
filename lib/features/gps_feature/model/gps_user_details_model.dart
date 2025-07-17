import 'dart:convert';

GpsUserDetailsModel gpsUserDetailsModelFromJson(String str) =>
    GpsUserDetailsModel.fromJson(json.decode(str));

String gpsUserDetailsModelToJson(GpsUserDetailsModel data) =>
    json.encode(data.toJson());

class GpsUserDetailsModel {
  final int? id;
  final String? name;
  final String? email;
  final int? disabled;
  final GpsUserAttributes? attributes;

  GpsUserDetailsModel({
    this.id,
    this.name,
    this.email,
    this.disabled,
    this.attributes,
  });

  factory GpsUserDetailsModel.fromJson(Map<String, dynamic> json) =>
      GpsUserDetailsModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        disabled: json["disabled"],
        attributes:
            json["attributes"] != null
                ? GpsUserAttributes.fromJson(json["attributes"])
                : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "disabled": disabled,
    "attributes": attributes?.toJson(),
  };
}

class GpsUserAttributes {
  final String? email;

  GpsUserAttributes({this.email});

  factory GpsUserAttributes.fromJson(Map<String, dynamic> json) =>
      GpsUserAttributes(email: json["email"]);

  Map<String, dynamic> toJson() => {"email": email};
}
