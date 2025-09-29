import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutShippingAddressEvent {}

class FetchKavachShippingAddresses extends KavachCheckoutShippingAddressEvent {
  String billingAddressUniqueId;
  String shippingAddressUniqueId;

  FetchKavachShippingAddresses({
    required this.billingAddressUniqueId,
    required this.shippingAddressUniqueId,
  });
}

class SelectKavachShippingAddress extends KavachCheckoutShippingAddressEvent {
  final KavachAddressModel address;

  SelectKavachShippingAddress(this.address);
}

class RestoreKavachShippingAddress extends KavachCheckoutShippingAddressEvent {
  final KavachAddressModel address;
  final List<KavachAddressModel> addresses;

  RestoreKavachShippingAddress(this.address, this.addresses);
}

class ClearKavachShippingAddress extends KavachCheckoutShippingAddressEvent {}
