class MobileOtpVerificationModel {
    MobileOtpVerificationModel({
        required this.message,
        required this.token,
        required this.user,
    });

    final String message;
    final String token;
    final UserOtpModel? user;

    MobileOtpVerificationModel copyWith({
        String? message,
        String? token,
        UserOtpModel? user,
    }) {
        return MobileOtpVerificationModel(
            message: message ?? this.message,
            token: token ?? this.token,
            user: user ?? this.user,
        );
    }

    factory MobileOtpVerificationModel.fromJson(Map<String, dynamic> json){ 
        return MobileOtpVerificationModel(
            message: json["message"] ?? "",
            token: json["token"] ?? "",
            user: json["user"] == null ? null : UserOtpModel.fromJson(json["user"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        "user": user?.toJson(),
    };

}

class UserOtpModel {
    UserOtpModel({
        required this.id,
        required this.mobile,
        required this.role,
        required this.tempflg,
    });

    final String id;
    final String mobile;
    final int role;
    final bool tempflg;

    UserOtpModel copyWith({
        String? id,
        String? mobile,
        int? role,
        bool? tempflg,
    }) {
        return UserOtpModel(
            id: id ?? this.id,
            mobile: mobile ?? this.mobile,
            role: role ?? this.role,
            tempflg: tempflg ?? this.tempflg,
        );
    }

    factory UserOtpModel.fromJson(Map<String, dynamic> json){ 
        return UserOtpModel(
            id: json["id"] ?? "",
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
