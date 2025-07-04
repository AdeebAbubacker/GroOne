class LoginApiResponseModel {
    LoginApiResponseModel({
        required this.message,
        required this.user,
    });

    final String message;
    final User? user;

    LoginApiResponseModel copyWith({
        String? message,
        User? user,
    }) {
        return LoginApiResponseModel(
            message: message ?? this.message,
            user: user ?? this.user,
        );
    }

    factory LoginApiResponseModel.fromJson(Map<String, dynamic> json){ 
        return LoginApiResponseModel(
            message: json["message"] ?? "",
            user: json["user"] == null ? null : User.fromJson(json["user"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "message": message,
        "user": user?.toJson(),
    };

}

class User {
    User({
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
    final KongToken? kongToken;

    User copyWith({
        String? id,
        String? mobileNumber,
        int? roleId,
        int? otp,
        KongToken? kongToken,
    }) {
        return User(
            id: id ?? this.id,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            roleId: roleId ?? this.roleId,
            otp: otp ?? this.otp,
            kongToken: kongToken ?? this.kongToken,
        );
    }

    factory User.fromJson(Map<String, dynamic> json){ 
        return User(
            id: json["id"] ?? "",
            mobileNumber: json["mobileNumber"] ?? "",
            roleId: json["roleId"] ?? 0,
            otp: json["otp"] ?? 0,
            kongToken: json["kongToken"] == null ? null : KongToken.fromJson(json["kongToken"]),
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
