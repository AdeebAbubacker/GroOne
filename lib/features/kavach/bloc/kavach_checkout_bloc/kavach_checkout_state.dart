import '../../../../data/model/result.dart';
import '../../model/kavach_address_model.dart';
import '../../model/kavach_vehicle_model.dart';

abstract class KavachCheckoutState {}

class VehicleInitial extends KavachCheckoutState {}

class VehicleLoading extends KavachCheckoutState {}

class VehicleLoaded extends KavachCheckoutState {
  final List<KavachVehicleModel> vehicles;
  VehicleLoaded(this.vehicles);
}

class VehicleError extends KavachCheckoutState {
  final ErrorType error;
  VehicleError(this.error);
}

class AddressLoading extends KavachCheckoutState {}

class AddressLoaded extends KavachCheckoutState {
  final List<KavachAddressModel> addresses;
  AddressLoaded(this.addresses);
}

class AddressEmpty extends KavachCheckoutState {}

class AddressError extends KavachCheckoutState {
  final ErrorType error;
  AddressError(this.error);
}

class AddressSelected extends KavachCheckoutState {
  final KavachAddressModel selectedAddress;
  final List<KavachAddressModel> addresses;
  AddressSelected({required this.selectedAddress, required this.addresses});
}



