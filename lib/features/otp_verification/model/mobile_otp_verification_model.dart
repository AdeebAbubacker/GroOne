class MobileOtpVerificationModel {
  MobileOtpVerificationModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  MobileOtpVerificationModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return MobileOtpVerificationModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory MobileOtpVerificationModel.fromJson(Map<String, dynamic> json){
    return MobileOtpVerificationModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };

}

class Data {
  Data({
    required this.token,
    required this.user,
  });

  final String token;
  final User? user;

  Data copyWith({
    String? token,
    User? user,
  }) {
    return Data(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      token: json["token"] ?? "",
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user?.toJson(),
  };

}

class User {
  User({
    required this.id,
    required this.mobile,
    required this.role,
    required this.tempflg,
  });

  final int id;
  final String mobile;
  final int role;
  final bool tempflg;

  User copyWith({
    int? id,
    String? mobile,
    int? role,
    bool? tempflg,
  }) {
    return User(
      id: id ?? this.id,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      tempflg: tempflg ?? this.tempflg,
    );
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"] ?? 0,
      mobile: json["mobile"] ?? "",
      role: json["role"] ?? 0,
      tempflg: json["tempflg"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobile": mobile,
    "role": role,
    "tempflg": tempflg,
  };

}
