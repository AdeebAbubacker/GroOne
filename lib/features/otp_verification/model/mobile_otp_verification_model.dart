class MobileOtpVerificationModel {
    MobileOtpVerificationModel({
        required this.message,
        required this.token,
        required this.user,
        this.kongToken,
    });

    final String message;
    final String token;
    final UserOtpModel? user;
    final KongTokenModel? kongToken;

    MobileOtpVerificationModel copyWith({
        String? message,
        String? token,
        UserOtpModel? user,
        KongTokenModel? kongToken,
    }) {
        return MobileOtpVerificationModel(
            message: message ?? this.message,
            token: token ?? this.token,
            user: user ?? this.user,
            kongToken: kongToken ?? this.kongToken,
        );
    }

    factory MobileOtpVerificationModel.fromJson(Map<String, dynamic> json){ 
        return MobileOtpVerificationModel(
            message: json["message"] ?? "",
            token: json["token"] ?? "",
            user: json["user"] == null ? null : UserOtpModel.fromJson(json["user"]),
            kongToken: json["kongToken"] == null ? null : KongTokenModel.fromJson(json["kongToken"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        "user": user?.toJson(),
        "kongToken": kongToken?.toJson(),
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

class KongTokenModel {
    KongTokenModel({
        required this.expiresIn,
        required this.tokenType,
        required this.refreshToken,
        required this.accessToken,
    });

    final int expiresIn;
    final String tokenType;
    final String refreshToken;
    final String accessToken;

    KongTokenModel copyWith({
        int? expiresIn,
        String? tokenType,
        String? refreshToken,
        String? accessToken,
    }) {
        return KongTokenModel(
            expiresIn: expiresIn ?? this.expiresIn,
            tokenType: tokenType ?? this.tokenType,
            refreshToken: refreshToken ?? this.refreshToken,
            accessToken: accessToken ?? this.accessToken,
        );
    }

    factory KongTokenModel.fromJson(Map<String, dynamic> json){ 
        return KongTokenModel(
            expiresIn: json["expires_in"] ?? 0,
            tokenType: json["token_type"] ?? "",
            refreshToken: json["refresh_token"] ?? "",
            accessToken: json["access_token"] ?? "",
        );
    }

    Map<String, dynamic> toJson() => {
        "expires_in": expiresIn,
        "token_type": tokenType,
        "refresh_token": refreshToken,
        "access_token": accessToken,
    };
}
