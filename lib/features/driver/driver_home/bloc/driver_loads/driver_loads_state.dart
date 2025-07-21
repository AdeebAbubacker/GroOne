part of 'driver_loads_bloc.dart';


abstract class DriverLoadsState {}

class DriverLoadsInitial extends DriverLoadsState {}

class DriverLoadsLoading extends DriverLoadsState {}

class DriverLoadsLoaded extends DriverLoadsState {
  final List<DriverLoadDetails> loads;
  DriverLoadsLoaded(this.loads);
}

class DriverLoadsError extends DriverLoadsState {
  final String message;
  DriverLoadsError(this.message);
}


class DriverLoadStatusChanging extends DriverLoadsState {}

class DriverLoadStatusChanged extends DriverLoadsState {
  final VpLoadAcceptModel result;

  DriverLoadStatusChanged(this.result);
}

class DriverLoadStatusChangeFailed extends DriverLoadsState {
  final String message;

  DriverLoadStatusChangeFailed(this.message);
}
