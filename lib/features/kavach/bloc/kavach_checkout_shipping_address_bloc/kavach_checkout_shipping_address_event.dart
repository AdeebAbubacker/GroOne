import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutShippingAddressEvent {}

class FetchKavachAddresses extends KavachCheckoutShippingAddressEvent {}

class SelectKavachAddress extends KavachCheckoutShippingAddressEvent {
  final KavachAddressModel address;
  SelectKavachAddress(this.address);
}
