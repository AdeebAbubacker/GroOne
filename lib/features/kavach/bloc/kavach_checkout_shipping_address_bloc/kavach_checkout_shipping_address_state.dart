import '../../../../data/model/result.dart';
import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutShippingAddressState {}

class KavachCheckoutShippingAddressLoading extends KavachCheckoutShippingAddressState {}

class KavachCheckoutShippingAddressEmpty extends KavachCheckoutShippingAddressState {}

class KavachCheckoutShippingAddressError extends KavachCheckoutShippingAddressState {
  final ErrorType error;
  KavachCheckoutShippingAddressError(this.error);
}

class KavachCheckoutShippingAddressSelected extends KavachCheckoutShippingAddressState {
  final KavachAddressModel selectedAddress;
  final List<KavachAddressModel> addresses;
  KavachCheckoutShippingAddressSelected({required this.selectedAddress, required this.addresses});
}
