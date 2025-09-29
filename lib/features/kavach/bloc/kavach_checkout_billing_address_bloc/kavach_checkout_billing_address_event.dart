import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutBillingAddressEvent {}

class FetchKavachBillingAddresses extends KavachCheckoutBillingAddressEvent {
  String shippingUniqueId;
  String billingUniqueId;

  FetchKavachBillingAddresses({
    required this.billingUniqueId,
    required this.shippingUniqueId,
  });
}

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
