part of 'driver_loads_bloc.dart';

abstract class DriverLoadsState {}

class DriverLoadsInitial extends DriverLoadsState {}

class DriverLoadsLoading extends DriverLoadsState {}

class DriverLoadsLoaded extends DriverLoadsState {
  final DriverListDataDetails loads;
  DriverLoadsLoaded(this.loads);
}

class DriverLoadsError extends DriverLoadsState {
  final String errorType;
  DriverLoadsError(this.errorType);
}

class DriverLoadStatusChanging extends DriverLoadsState {}

class DriverLoadStatusChanged extends DriverLoadsState {
  final VpLoadAcceptModel result;

  DriverLoadStatusChanged(this.result);
}

class DriverLoadStatusChangeFailed extends DriverLoadsState {
  final ErrorType errorType;
  DriverLoadStatusChangeFailed(this.errorType);
}

