class KavachAddAddressApiRequest {
  final String addr1;
  final String addr2;
  final String city;
  final String state;
  final String pincode;
  String? gstIn;
  final String country;
  final int addrType;
  int? customerId;

  KavachAddAddressApiRequest({
    required this.addr1,
    required this.addr2,
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
      'addr1': addr1,
      'addr2': addr2,
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
