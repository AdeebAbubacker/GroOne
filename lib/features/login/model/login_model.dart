class LoginApiResponseModel {
    LoginApiResponseModel({
        required this.mobile,
        required this.customerId,
        required this.roleId,
        required this.driver,
        required this.tempFlg,
        required this.otp,
    });

    final String mobile;
    final String customerId;
    final int roleId;
    final bool driver;
    final bool tempFlg;
    final int otp;

    LoginApiResponseModel copyWith({
        String? mobile,
        String? customerId,
        int? roleId,
        bool? driver,
        bool? tempFlg,
        int? otp,
    }) {
        return LoginApiResponseModel(
            mobile: mobile ?? this.mobile,
            customerId: customerId ?? this.customerId,
            roleId: roleId ?? this.roleId,
            driver: driver ?? this.driver,
            tempFlg: tempFlg ?? this.tempFlg,
            otp: otp ?? this.otp,
        );
    }

    factory LoginApiResponseModel.fromJson(Map<String, dynamic> json){ 
        return LoginApiResponseModel(
            mobile: json["mobile"] ?? "",
            customerId: json["customerId"] ?? "",
            roleId: json["roleId"] ?? 0,
            driver: json["driver"] ?? false,
            tempFlg: json["tempFlg"] ?? false,
            otp: json["otp"] ?? 0,
        );
    }

}
