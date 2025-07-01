class KavachAddAddressApiRequest {
  final String addressName;
  final String addr1;
  final String city;
  final String state;
  final String pincode;
  String? gstIn;
  final String country;
  final int addrType;
  int? customerId;

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
      'addressName': addressName,
      'addr1': addr1,
      'city': city,
      'state': state,
      'pincode': pincode,
      'addrType': addrType,
      'country': country,
      'gstin': gstIn,
      'customerId': customerId,
    };
  }
}
