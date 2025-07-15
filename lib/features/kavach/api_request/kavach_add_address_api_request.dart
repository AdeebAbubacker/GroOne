class KavachAddAddressApiRequest {
  final String addressName;
  final String addr1;
  final String city;
  final String state;
  final String pincode;
  String? gstIn;
  final String country;
  final int addrType;
  String? customerId;

  KavachAddAddressApiRequest({
    required this.addressName,
    required this.addr1,
    required this.city,
    required this.state,
    required this.pincode,
    required this.addrType,
    required this.country,
    this.gstIn,
    this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId,
      "addrName": addressName,
      "addr": addr1,
      "city": city,
      "state": state,
      "pincode": pincode,
      "isDefault": true,
      "addrType": addrType.toString(), // Convert to String
      "country": country,
      "gstIn": gstIn,
    };
  }
}
