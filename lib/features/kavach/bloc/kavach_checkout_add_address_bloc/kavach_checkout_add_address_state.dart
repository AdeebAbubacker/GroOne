import 'package:gro_one_app/features/fastag/model/fastag_pincode_verify_model.dart';

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

class KavachVerifyPincodeLoaded extends KavachCheckoutAddAddressState {
  final FleetPincodeVerifyModel fleetPincodeVerifyModel;

  KavachVerifyPincodeLoaded(this.fleetPincodeVerifyModel);
}

class KavachVerifyPincodeError extends KavachCheckoutAddAddressState {
  final String error;

  KavachVerifyPincodeError(this.error);
}
