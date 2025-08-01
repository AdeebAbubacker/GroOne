class AddressRequest {
  AddressRequest({
    this.customerId,
    required this.addrName,
    required this.addr,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isDefault,
  });

  final String? customerId;
  final String addrName;
  final String addr;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;

  AddressRequest copyWith({
    String? customerId,
    String? addrName,
    String? addr,
    String? city,
    String? state,
    String? pincode,
    bool? isDefault,
  }) {
    return AddressRequest(
      customerId: customerId ?? this.customerId,
      addrName: addrName ?? this.addrName,
      addr: addr ?? this.addr,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory AddressRequest.fromJson(Map<String, dynamic> json){
    return AddressRequest(
      customerId: json["customerId"] ?? "",
      addrName: json["addrName"] ?? "",
      addr: json["addr"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      pincode: json["pincode"] ?? "",
      isDefault: json["isDefault"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "addrName": addrName,
    "addr": addr,
    "city": city,
    "state": state,
    "pincode": pincode,
    "isDefault": isDefault,
  };

}
