import 'dart:convert';

GpsUserDetailsModel gpsUserDetailsModelFromJson(String str) =>
    GpsUserDetailsModel.fromJson(json.decode(str));

String gpsUserDetailsModelToJson(GpsUserDetailsModel data) =>
    json.encode(data.toJson());

class GpsUserDetailsModel {
  final List<GpsUserData>? data;
  final bool? success;
  final int? total;

  GpsUserDetailsModel({this.data, this.success, this.total});

  factory GpsUserDetailsModel.fromJson(Map<String, dynamic> json) =>
      GpsUserDetailsModel(
        data:
            json["data"] != null
                ? List<GpsUserData>.from(
                  json["data"].map((x) => GpsUserData.fromJson(x)),
                )
                : null,
        success: json["success"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
    "data": data?.map((x) => x.toJson()).toList(),
    "success": success,
    "total": total,
  };

  // Helper method to get the first user (for backward compatibility)
  GpsUserData? get firstUser => data?.isNotEmpty == true ? data!.first : null;
}

class GpsUserData {
  final int? disabled;
  final String? email;
  final int? id;
  final String? name;

  GpsUserData({this.disabled, this.email, this.id, this.name});

  factory GpsUserData.fromJson(Map<String, dynamic> json) => GpsUserData(
    disabled: json["disabled"],
    email: json["email"],
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "disabled": disabled,
    "email": email,
    "id": id,
    "name": name,
  };
}

// Keep the old structure for backward compatibility if needed
class GpsUserDetailsModelLegacy {
  final int? id;
  final String? name;
  final String? email;
  final int? disabled;
  final GpsUserAttributes? attributes;

  GpsUserDetailsModelLegacy({
    this.id,
    this.name,
    this.email,
    this.disabled,
    this.attributes,
  });

  factory GpsUserDetailsModelLegacy.fromJson(Map<String, dynamic> json) =>
      GpsUserDetailsModelLegacy(
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
