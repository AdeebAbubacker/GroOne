import '../../../../data/model/result.dart';
import '../../model/kavach_vehicle_model.dart';

abstract class KavachCheckoutVehicleState {}

class KavachCheckoutVehicleInitial extends KavachCheckoutVehicleState {}

class KavachCheckoutVehicleLoading extends KavachCheckoutVehicleState {}

class KavachCheckoutVehicleLoaded extends KavachCheckoutVehicleState {
  final List<KavachVehicleModel> vehicles;
  KavachCheckoutVehicleLoaded(this.vehicles);
}

class KavachCheckoutVehicleError extends KavachCheckoutVehicleState {
  final ErrorType error;
  KavachCheckoutVehicleError(this.error);
}
