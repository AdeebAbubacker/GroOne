class ChooseRoleResponseModel {
    ChooseRoleResponseModel({
        required this.mobile,
        required this.customerId,
        required this.roleId,
        required this.driver,
        required this.tempFlg,
    });

    final String mobile;
    final String customerId;
    final int roleId;
    final bool driver;
    final bool tempFlg;

    ChooseRoleResponseModel copyWith({
        String? mobile,
        String? customerId,
        int? roleId,
        bool? driver,
        bool? tempFlg,
    }) {
        return ChooseRoleResponseModel(
            mobile: mobile ?? this.mobile,
            customerId: customerId ?? this.customerId,
            roleId: roleId ?? this.roleId,
            driver: driver ?? this.driver,
            tempFlg: tempFlg ?? this.tempFlg,
        );
    }

    factory ChooseRoleResponseModel.fromJson(Map<String, dynamic> json){ 
        return ChooseRoleResponseModel(
            mobile: json["mobile"] ?? "",
            customerId: json["customerId"] ?? "",
            roleId: json["roleId"] ?? 0,
            driver: json["driver"] ?? false,
            tempFlg: json["tempFlg"] ?? false,
        );
    }

}
