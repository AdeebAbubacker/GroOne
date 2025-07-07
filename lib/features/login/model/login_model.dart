import 'package:gro_one_app/features/otp_verification/model/mobile_otp_resend_model.dart';

class LoginApiResponseModel {
    LoginApiResponseModel({
        required this.message,
        required this.user,
    });

    final String message;
    final UserDetailsModel? user;

    LoginApiResponseModel copyWith({
        String? message,
        UserDetailsModel? user,
    }) {
        return LoginApiResponseModel(
            message: message ?? this.message,
            user: user ?? this.user,
        );
    }

    factory LoginApiResponseModel.fromJson(Map<String, dynamic> json){ 
        return LoginApiResponseModel(
            message: json["message"] ?? "",
            user: json["user"] == null ? null : UserDetailsModel.fromJson(json["user"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "message": message,
        "user": user?.toJson(),
    };

}

class UserDetailsModel {
    UserDetailsModel({
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

    UserDetailsModel copyWith({
        String? id,
        String? mobileNumber,
        int? roleId,
        int? otp,
        KongTokenOtpModel? kongToken,
    }) {
        return UserDetailsModel(
            id: id ?? this.id,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            roleId: roleId ?? this.roleId,
            otp: otp ?? this.otp,
            kongToken: kongToken ?? this.kongToken,
        );
    }

    factory UserDetailsModel.fromJson(Map<String, dynamic> json){ 
        return UserDetailsModel(
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
