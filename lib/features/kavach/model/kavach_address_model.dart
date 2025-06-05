import 'package:equatable/equatable.dart';

class KavachAddressModel extends Equatable {
  final int id;
  final String customerName;
  final String mobileNumber;
  final String addr1;
  final String addr2;
  final String city;
  final String state;
  final String pincode;

  const KavachAddressModel({
    required this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.addr1,
    required this.addr2,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory KavachAddressModel.fromJson(Map<String, dynamic> json) {
    return KavachAddressModel(
      id: json['id'],
      customerName: json['customerName'],
      mobileNumber: json['mobileNumber'],
      addr1: json['addr1'],
      addr2: json['addr2'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
    );
  }

  String get fullAddress => '$addr1, $addr2, $city, $state - $pincode';

  @override
  List<Object?> get props => [
    id,
    customerName,
    mobileNumber,
    addr1,
    addr2,
    city,
    state,
    pincode,
  ];
}
