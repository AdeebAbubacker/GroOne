import 'package:equatable/equatable.dart';

// class KavachAddressModel extends Equatable {
//   final int id;
//   final String customerName;
//   final String mobileNumber;
//   final String addr1;
//   final String addr2;
//   final String city;
//   final String state;
//   final String pincode;
//
//   const KavachAddressModel({
//     required this.id,
//     required this.customerName,
//     required this.mobileNumber,
//     required this.addr1,
//     required this.addr2,
//     required this.city,
//     required this.state,
//     required this.pincode,
//   });
//
//   factory KavachAddressModel.fromJson(Map<String, dynamic> json) {
//     return KavachAddressModel(
//       id: json['id'],
//       customerName: json['customerName'],
//       mobileNumber: json['mobileNumber'],
//       addr1: json['addr1'],
//       addr2: json['addr2'],
//       city: json['city'],
//       state: json['state'],
//       pincode: json['pincode'],
//     );
//   }
//
//   String get fullAddress => '$addr1, $addr2, $city, $state - $pincode';
//
//   @override
//   List<Object?> get props => [
//     id,
//     customerName,
//     mobileNumber,
//     addr1,
//     addr2,
//     city,
//     state,
//     pincode,
//   ];
// }

class KavachAddressModel extends Equatable {
  final int id;
  final String customerName;
  final String? mobileNumber;
  final int customerId;
  final String addr1;
  final String? addr2;
  final String city;
  final String state;
  final String? country;
  final String? gstin;
  final String pincode;
  final int addrType;
  final int status;
  final DateTime createdAt;
  final DateTime? deletedAt;

  const KavachAddressModel({
    required this.id,
    required this.customerName,
    this.mobileNumber,
    required this.customerId,
    required this.addr1,
    this.addr2,
    required this.city,
    required this.state,
    this.country,
    this.gstin,
    required this.pincode,
    required this.addrType,
    required this.status,
    required this.createdAt,
    this.deletedAt,
  });

  factory KavachAddressModel.fromJson(Map<String, dynamic> json) {
    return KavachAddressModel(
      id: json['id'],
      customerName: json['customerName'] ?? '',
      mobileNumber: json['mobileNumber'] == null || json['mobileNumber'].toString().isEmpty
          ? null
          : json['mobileNumber'],
      customerId: json['customerId'],
      addr1: json['addr1'] ?? '',
      addr2: json['addr2'] == null || json['addr2'].toString().isEmpty
          ? null
          : json['addr2'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] == null || json['country'].toString().isEmpty
          ? null
          : json['country'],
      gstin: json['gstin'],
      pincode: json['pincode'] ?? '',
      addrType: json['addrType'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null,
    );
  }

  // String get fullAddress {
  //   final addressParts = [
  //     addr1,
  //     if (addr2 != null && addr2!.isNotEmpty) addr2,
  //     city,
  //     state,
  //     if (country != null && country!.isNotEmpty) country,
  //     '- $pincode',
  //   ];
  //   return addressParts.where((part) => part != null && part.toString().trim().isNotEmpty).join(', ');
  // }
  String get fullAddress {
    return '''
$addr1
$city, $state - $pincode
''';
  }


  @override
  List<Object?> get props => [
    id,
    customerName,
    mobileNumber,
    customerId,
    addr1,
    addr2,
    city,
    state,
    country,
    gstin,
    pincode,
    addrType,
    status,
    createdAt,
    deletedAt,
  ];
}


