import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutBillingAddressEvent {}

class FetchKavachBillingAddresses extends KavachCheckoutBillingAddressEvent {}

class SelectKavachBillingAddress extends KavachCheckoutBillingAddressEvent {
  final KavachAddressModel address;
  SelectKavachBillingAddress(this.address);
}

class ClearKavachBillingAddress extends KavachCheckoutBillingAddressEvent {}

