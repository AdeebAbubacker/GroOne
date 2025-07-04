class MobileOtpVerificationModel {
    MobileOtpVerificationModel({
        required this.message,
        required this.token,
        required this.user,
    });

    final String message;
    final String token;
    final User? user;

    MobileOtpVerificationModel copyWith({
        String? message,
        String? token,
        User? user,
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
            user: json["user"] == null ? null : User.fromJson(json["user"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "message": message,
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

    final String id;
    final String mobile;
    final int role;
    final bool tempflg;

    User copyWith({
        String? id,
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
