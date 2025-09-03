class SetPrimaryAddressResponse {
  SetPrimaryAddressResponse({
    required this.preferedAddressId,
    required this.customerId,
    required this.addrName,
    required this.addr,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isDefault,
    required this.addrType,
    required this.country,
    required this.gstIn,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String preferedAddressId;
  final String customerId;
  final String addrName;
  final String addr;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;
  final String addrType;
  final String country;
  final dynamic gstIn;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  SetPrimaryAddressResponse copyWith({
    String? preferedAddressId,
    String? customerId,
    String? addrName,
    String? addr,
    String? city,
    String? state,
    String? pincode,
    bool? isDefault,
    String? addrType,
    String? country,
    dynamic gstIn,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) {
    return SetPrimaryAddressResponse(
      preferedAddressId: preferedAddressId ?? this.preferedAddressId,
      customerId: customerId ?? this.customerId,
      addrName: addrName ?? this.addrName,
      addr: addr ?? this.addr,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      isDefault: isDefault ?? this.isDefault,
      addrType: addrType ?? this.addrType,
      country: country ?? this.country,
      gstIn: gstIn ?? this.gstIn,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory SetPrimaryAddressResponse.fromJson(Map<String, dynamic> json){
    return SetPrimaryAddressResponse(
      preferedAddressId: json["preferedAddressId"] ?? "",
      customerId: json["customerId"] ?? "",
      addrName: json["addrName"] ?? "",
      addr: json["addr"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      pincode: json["pincode"] ?? "",
      isDefault: json["isDefault"] ?? false,
      addrType: json["addrType"] ?? "",
      country: json["country"] ?? "",
      gstIn: json["gstIn"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "preferedAddressId": preferedAddressId,
    "customerId": customerId,
    "addrName": addrName,
    "addr": addr,
    "city": city,
    "state": state,
    "pincode": pincode,
    "isDefault": isDefault,
    "addrType": addrType,
    "country": country,
    "gstIn": gstIn,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}
