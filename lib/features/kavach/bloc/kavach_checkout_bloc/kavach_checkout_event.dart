import '../../model/kavach_address_model.dart';

abstract class KavachCheckoutEvent {}

class FetchVehicles extends KavachCheckoutEvent {
  FetchVehicles();
}

class FetchAddresses extends KavachCheckoutEvent {}

class SelectAddress extends KavachCheckoutEvent {
  final KavachAddressModel address;
  SelectAddress(this.address);
}


