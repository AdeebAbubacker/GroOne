import '../../../../data/model/result.dart';
import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutShippingAddressState {}

class KavachCheckoutAddressLoading extends KavachCheckoutShippingAddressState {}

class KavachCheckoutAddressEmpty extends KavachCheckoutShippingAddressState {}

class KavachCheckoutAddressError extends KavachCheckoutShippingAddressState {
  final ErrorType error;
  KavachCheckoutAddressError(this.error);
}

class KavachCheckoutAddressSelected extends KavachCheckoutShippingAddressState {
  final KavachAddressModel selectedAddress;
  final List<KavachAddressModel> addresses;
  KavachCheckoutAddressSelected({required this.selectedAddress, required this.addresses});
}
