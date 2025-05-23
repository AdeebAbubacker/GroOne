// To parse this JSON data, do
//
//     final otpResponse = otpResponseFromJson(jsonString);

import 'dart:convert';

OtpResponse otpResponseFromJson(String str) => OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
  bool success;
  String message;
  Data data;

  OtpResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
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
  String token;
  User user;

  Data({
    required this.token,
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}

class User {
  int id;
  String mobile;
  int role;
  bool tempflg;

  User({
    required this.id,
    required this.mobile,
    required this.role,
    required this.tempflg,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    mobile: json["mobile"],
    role: json["role"],
    tempflg: json["tempflg"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobile": mobile,
    "role": role,
    "tempflg": tempflg,
  };
}
