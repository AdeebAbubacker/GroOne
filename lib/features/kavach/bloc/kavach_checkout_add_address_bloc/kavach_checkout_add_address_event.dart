import '../../api_request/kacach_add_address_api_request.dart';

abstract class KavachCheckoutAddAddressEvent {}

class AddKavachAddress extends KavachCheckoutAddAddressEvent {
  final KavachAddAddressApiRequest address;
  AddKavachAddress(this.address);
}
