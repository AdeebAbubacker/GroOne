class KavachAddAddressApiRequest {
  final String customerName;
  final String mobileNumber;
  final String addr1;
  final String addr2;
  final String city;
  final String state;
  final String pincode;
  final int addrType;
  int? customerId;

  KavachAddAddressApiRequest({
    required this.customerName,
    required this.mobileNumber,
    required this.addr1,
    required this.addr2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.addrType,
    this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'addr1': addr1,
      'addr2': addr2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'addrType': addrType,
      'customerId': customerId,
    };
  }
}
