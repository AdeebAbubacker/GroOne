import 'package:gro_one_app/data/model/result.dart';

import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutBillingAddressState {}

class KavachCheckoutBillingAddressLoading extends KavachCheckoutBillingAddressState {}

class KavachCheckoutBillingAddressEmpty extends KavachCheckoutBillingAddressState {}

class KavachCheckoutBillingAddressAvailable extends KavachCheckoutBillingAddressState {
  final List<KavachAddressModel> addresses;
  KavachCheckoutBillingAddressAvailable({required this.addresses});
}

class KavachCheckoutBillingAddressError extends KavachCheckoutBillingAddressState {
  final ErrorType error;
  KavachCheckoutBillingAddressError(this.error);
}

class KavachCheckoutBillingAddressSelected extends KavachCheckoutBillingAddressState {
  final KavachAddressModel? selectedAddress;
  final List<KavachAddressModel> addresses;
  KavachCheckoutBillingAddressSelected({
    required this.selectedAddress,
    required this.addresses,
  });
}
