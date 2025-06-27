import 'package:equatable/equatable.dart';

class KavachAddressModel extends Equatable {
  final int id;
  final String customerName;
  final String mobileNumber;
  final int customerId;
  final String addr1;
  final String addr2;
  final String city;
  final String state;
  final String country;
  final String? gstin;
  final String pincode;
  final int addrType;
  final int status;
  final DateTime createdAt;
  final DateTime? deletedAt;

  const KavachAddressModel({
    required this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.customerId,
    required this.addr1,
    required this.addr2,
    required this.city,
    required this.state,
    required this.country,
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
      customerName: json['customerName']??'',
      mobileNumber: json['mobileNumber']??'',
      customerId: json['customerId'],
      addr1: json['addr1'],
      addr2: json['addr2'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      gstin: json['gstin'],
      pincode: json['pincode'],
      addrType: json['addrType'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null,
    );
  }

  String get fullAddress => '$addr1, $addr2, $city, $state, $country - $pincode';

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


