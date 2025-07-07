class MobileOtpResendModel {
    MobileOtpResendModel({
        required this.message,
        required this.user,
    });

    final String message;
    final UserOtpSucessModel? user;

    MobileOtpResendModel copyWith({
        String? message,
        UserOtpSucessModel? user,
    }) {
        return MobileOtpResendModel(
            message: message ?? this.message,
            user: user ?? this.user,
        );
    }

    factory MobileOtpResendModel.fromJson(Map<String, dynamic> json){ 
        return MobileOtpResendModel(
            message: json["message"] ?? "",
            user: json["user"] == null ? null : UserOtpSucessModel.fromJson(json["user"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "message": message,
        "user": user?.toJson(),
    };

}

class UserOtpSucessModel {
    UserOtpSucessModel({
        required this.id,
        required this.mobileNumber,
        required this.roleId,
        required this.otp,
        required this.kongToken,
    });

    final String id;
    final String mobileNumber;
    final int roleId;
    final int otp;
    final KongTokenOtpModel? kongToken;

    UserOtpSucessModel copyWith({
        String? id,
        String? mobileNumber,
        int? roleId,
        int? otp,
        KongTokenOtpModel? kongToken,
    }) {
        return UserOtpSucessModel(
            id: id ?? this.id,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            roleId: roleId ?? this.roleId,
            otp: otp ?? this.otp,
            kongToken: kongToken ?? this.kongToken,
        );
    }

    factory UserOtpSucessModel.fromJson(Map<String, dynamic> json){ 
        return UserOtpSucessModel(
            id: json["id"] ?? "",
            mobileNumber: json["mobileNumber"] ?? "",
            roleId: json["roleId"] ?? 0,
            otp: json["otp"] ?? 0,
            kongToken: json["kongToken"] == null ? null : KongTokenOtpModel.fromJson(json["kongToken"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "mobileNumber": mobileNumber,
        "roleId": roleId,
        "otp": otp,
        "kongToken": kongToken?.toJson(),
    };

}

class KongTokenOtpModel {
    KongTokenOtpModel({
        required this.expiresIn,
        required this.tokenType,
        required this.refreshToken,
        required this.accessToken,
    });

    final int expiresIn;
    final String tokenType;
    final String refreshToken;
    final String accessToken;

    KongTokenOtpModel copyWith({
        int? expiresIn,
        String? tokenType,
        String? refreshToken,
        String? accessToken,
    }) {
        return KongTokenOtpModel(
            expiresIn: expiresIn ?? this.expiresIn,
            tokenType: tokenType ?? this.tokenType,
            refreshToken: refreshToken ?? this.refreshToken,
            accessToken: accessToken ?? this.accessToken,
        );
    }

    factory KongTokenOtpModel.fromJson(Map<String, dynamic> json){ 
        return KongTokenOtpModel(
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
