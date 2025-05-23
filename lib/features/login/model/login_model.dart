// To parse this JSON data, do
//
//     final loginApiResponseModel = loginApiResponseModelFromJson(jsonString);

import 'dart:convert';

LoginApiResponseModel loginApiResponseModelFromJson(String str) => LoginApiResponseModel.fromJson(json.decode(str));

String loginApiResponseModelToJson(LoginApiResponseModel data) => json.encode(data.toJson());

class LoginApiResponseModel {
  bool success;
  String message;
  Data data;

  LoginApiResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginApiResponseModel.fromJson(Map<String, dynamic> json) => LoginApiResponseModel(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  User user;

  Data({
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}

class User {
  int id;
  String mobileNumber;
  int roleId;
  int otp;

  User({
    required this.id,
    required this.mobileNumber,
    required this.roleId,
    required this.otp,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    mobileNumber: json["mobileNumber"],
    roleId: json["roleId"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobileNumber": mobileNumber,
    "roleId": roleId,
    "otp": otp,
  };
}
