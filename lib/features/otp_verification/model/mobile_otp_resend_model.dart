class MobileOtpResendModel {
    MobileOtpResendModel({
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

    MobileOtpResendModel copyWith({
        String? mobile,
        String? customerId,
        int? roleId,
        bool? driver,
        bool? tempFlg,
        int? otp,
    }) {
        return MobileOtpResendModel(
            mobile: mobile ?? this.mobile,
            customerId: customerId ?? this.customerId,
            roleId: roleId ?? this.roleId,
            driver: driver ?? this.driver,
            tempFlg: tempFlg ?? this.tempFlg,
            otp: otp ?? this.otp,
        );
    }

    factory MobileOtpResendModel.fromJson(Map<String, dynamic> json){ 
        return MobileOtpResendModel(
            mobile: json["mobile"] ?? "",
            customerId: json["customerId"] ?? "",
            roleId: json["roleId"] ?? 0,
            driver: json["driver"] ?? false,
            tempFlg: json["tempFlg"] ?? false,
            otp: json["otp"] ?? 0,
        );
    }

}

