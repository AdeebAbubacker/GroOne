// class KavachAddAddressApiRequest {
//   final String customerName;
//   final String mobileNumber;
//   final String addr1;
//   final String addr2;
//   final String city;
//   final String state;
//   final String pincode;
//   String? gstIn;
//   final String country;
//   final int addrType;
//   int? customerId;
//
//   KavachAddAddressApiRequest({
//     required this.customerName,
//     required this.mobileNumber,
//     required this.addr1,
//     required this.addr2,
//     required this.city,
//     required this.state,
//     required this.pincode,
//     required this.addrType,
//     required this.country,
//     this.gstIn,
//     this.customerId,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'customerName': customerName,
//       'mobileNumber': mobileNumber,
//       'addr1': addr1,
//       'addr2': addr2,
//       'city': city,
//       'state': state,
//       'pincode': pincode,
//       'addrType': addrType,
//       'country': country,
//       'gstin': gstIn,
//       'customerId': customerId,
//     };
//   }
// }
class KavachAddAddressApiRequest {
  final String customerName;
  final String addr1;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final int addrType;
  int? customerId;
  final String? gstin;

  KavachAddAddressApiRequest({
    required this.customerName,
    required this.addr1,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.addrType,
    this.customerId,
    this.gstin,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'addr1': addr1,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'addrType': addrType,
      'customerId': customerId,
      'gstin': gstin,
    };
  }
}
