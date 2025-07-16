import 'dart:convert';

GpsLoginResponseModel gpsLoginResponseModelFromJson(String str) =>
    GpsLoginResponseModel.fromJson(json.decode(str));

String gpsLoginResponseModelToJson(GpsLoginResponseModel data) =>
    json.encode(data.toJson());

class GpsLoginResponseModel {
  final String? token;
  final String? refreshToken;

  GpsLoginResponseModel({this.token, this.refreshToken});

  factory GpsLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      GpsLoginResponseModel(
        token: json["token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
    "token": token,
    "refresh_token": refreshToken,
  };
}

// Keep the old structure for backward compatibility if needed
class GpsLoginResponseModelLegacy {
  final bool success;
  final String message;
  final GpsLoginData? data;

  GpsLoginResponseModelLegacy({
    required this.success,
    required this.message,
    this.data,
  });

  factory GpsLoginResponseModelLegacy.fromJson(Map<String, dynamic> json) =>
      GpsLoginResponseModelLegacy(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null ? GpsLoginData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class GpsLoginData {
  final String? token;
  final String? refreshToken;
  final GpsUser? user;

  GpsLoginData({this.token, this.refreshToken, this.user});

  factory GpsLoginData.fromJson(Map<String, dynamic> json) => GpsLoginData(
    token: json["token"],
    refreshToken: json["refresh_token"],
    user: json["user"] != null ? GpsUser.fromJson(json["user"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "refresh_token": refreshToken,
    "user": user?.toJson(),
  };
}

class GpsUser {
  final int? id;
  final String? username;
  final String? email;
  final String? role;

  GpsUser({this.id, this.username, this.email, this.role});

  factory GpsUser.fromJson(Map<String, dynamic> json) => GpsUser(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "role": role,
  };
}
