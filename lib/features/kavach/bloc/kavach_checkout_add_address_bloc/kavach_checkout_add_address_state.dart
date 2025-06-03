import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutAddAddressState {}

class KavachCheckoutAddressInitial extends KavachCheckoutAddAddressState {}

class KavachCheckoutAddressLoading extends KavachCheckoutAddAddressState {}

class KavachCheckoutAddressAdded extends KavachCheckoutAddAddressState {
  final KavachAddressModel address;
  KavachCheckoutAddressAdded(this.address);
}
class KavachCheckoutAddressError extends KavachCheckoutAddAddressState {
  final String error;
  KavachCheckoutAddressError(this.error);
}
