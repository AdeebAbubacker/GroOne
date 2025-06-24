import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutShippingAddressEvent {}

class FetchKavachShippingAddresses extends KavachCheckoutShippingAddressEvent {}

class SelectKavachShippingAddress extends KavachCheckoutShippingAddressEvent {
  final KavachAddressModel address;
  SelectKavachShippingAddress(this.address);
}

class ClearKavachShippingAddress extends KavachCheckoutShippingAddressEvent {}