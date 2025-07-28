class MobileOtpVerificationModel {
    MobileOtpVerificationModel({
        required this.mobile,
        required this.customerId,
        required this.roleId,
        required this.driver,
        required this.tempFlg,
        required this.kongToken,
    });

    final String mobile;
    final String customerId;
    final int roleId;
    final bool driver;
    final bool tempFlg;
    final KongToken? kongToken;

    MobileOtpVerificationModel copyWith({
        String? mobile,
        String? customerId,
        int? roleId,
        bool? driver,
        bool? tempFlg,
        KongToken? kongToken,
    }) {
        return MobileOtpVerificationModel(
            mobile: mobile ?? this.mobile,
            customerId: customerId ?? this.customerId,
            roleId: roleId ?? this.roleId,
            driver: driver ?? this.driver,
            tempFlg: tempFlg ?? this.tempFlg,
            kongToken: kongToken ?? this.kongToken,
        );
    }

    factory MobileOtpVerificationModel.fromJson(Map<String, dynamic> json){
        return MobileOtpVerificationModel(
            mobile: json["mobile"] ?? "",
            customerId: json["customerId"] ?? "",
            roleId: json["roleId"] ?? 0,
            driver: json["driver"] ?? false,
            tempFlg: json["tempFlg"] ?? false,
            kongToken: json["kongToken"] == null ? null : KongToken.fromJson(json["kongToken"]),
        );
    }

}

class KongToken {
    KongToken({
        required this.expiresIn,
        required this.tokenType,
        required this.refreshToken,
        required this.accessToken,
    });

    final int expiresIn;
    final String tokenType;
    final String refreshToken;
    final String accessToken;

    KongToken copyWith({
        int? expiresIn,
        String? tokenType,
        String? refreshToken,
        String? accessToken,
    }) {
        return KongToken(
            expiresIn: expiresIn ?? this.expiresIn,
            tokenType: tokenType ?? this.tokenType,
            refreshToken: refreshToken ?? this.refreshToken,
            accessToken: accessToken ?? this.accessToken,
        );
    }

    factory KongToken.fromJson(Map<String, dynamic> json){
        return KongToken(
            expiresIn: json["expiresIn"] ?? 0,
            tokenType: json["tokenType"] ?? "",
            refreshToken: json["refreshToken"] ?? "",
            accessToken: json["accessToken"] ?? "",
        );
    }

    Map<String, dynamic> toJson() {
        return {
            "expires_in": expiresIn,
            "token_type": tokenType,
            "refresh_token": refreshToken,
            "access_token": accessToken,
        };
    }

}