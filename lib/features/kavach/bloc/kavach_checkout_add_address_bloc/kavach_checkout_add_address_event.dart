import '../../api_request/kavach_add_address_api_request.dart';

abstract class KavachCheckoutAddAddressEvent {}

class AddKavachAddress extends KavachCheckoutAddAddressEvent {
  final KavachAddAddressApiRequest address;

  AddKavachAddress(this.address);
}

class VerifyPincode extends KavachCheckoutAddAddressEvent {
  final String pincode;

  VerifyPincode(this.pincode);
}
