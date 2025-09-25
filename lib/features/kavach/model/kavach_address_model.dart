import 'package:equatable/equatable.dart';

class KavachAddressModel extends Equatable {
  final String id;
  final String customerName;
  final String mobileNumber;
  final int customerId;
  final String addressName;
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
    required this.addressName,
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
      id: json['preferedAddressId'] ?? '',
      customerName: json['customerName'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      customerId: int.tryParse(json['customerId']?.toString() ?? '0') ?? 0,
      addressName: json['addrName'] ?? '',
      addr1: json['addr'] ?? '',
      addr2: json['addr2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      gstin: json['gstIn'],
      pincode: json['pincode'] ?? '',
      addrType: int.tryParse(json['addrType']?.toString() ?? '0') ?? 0,
      status: int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      deletedAt:
          json['deletedAt'] != null
              ? DateTime.tryParse(json['deletedAt'])
              : null,
    );
  }

  String get fullAddress => '$addr1, $city, $state, $country - $pincode';

  // Create a unique identifier using address properties since ID might not be unique
  String get uniqueId => '$addressName-$addr1-$city-$pincode';

  @override
  List<Object?> get props => [
    id,
    customerName,
    mobileNumber,
    customerId,
    addressName,
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
