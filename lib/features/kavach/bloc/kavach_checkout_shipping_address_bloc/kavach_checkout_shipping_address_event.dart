import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutShippingAddressEvent {}

class FetchKavachShippingAddresses extends KavachCheckoutShippingAddressEvent {
  bool noRefresh;
  bool mandatoryRefresh;

  FetchKavachShippingAddresses({
    this.noRefresh = false,
    this.mandatoryRefresh = false,
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
