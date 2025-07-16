import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutBillingAddressEvent {}

class FetchKavachBillingAddresses extends KavachCheckoutBillingAddressEvent {}

class SelectKavachBillingAddress extends KavachCheckoutBillingAddressEvent {
  final KavachAddressModel address;
  SelectKavachBillingAddress(this.address);
}

class RestoreKavachBillingAddress extends KavachCheckoutBillingAddressEvent {
  final KavachAddressModel address;
  final List<KavachAddressModel> addresses;
  RestoreKavachBillingAddress(this.address, this.addresses);
}

class ClearKavachBillingAddress extends KavachCheckoutBillingAddressEvent {}

