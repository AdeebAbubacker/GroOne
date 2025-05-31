part of 'vp_home_bloc.dart';

@immutable
sealed class VpHomeState {}

final class VpHomeInitial extends VpHomeState {}

class VpMyLoadListLoading extends VpHomeState {}

class VpVehicleListLoading extends VpHomeState {}

class VpDriverListLoading extends VpHomeState {}

class ScheduleTripLoading extends VpHomeState {}

class VpMyLoadListSuccess extends VpHomeState {
  final VpMyLoadResponse vpMyLoadResponse;

  VpMyLoadListSuccess(this.vpMyLoadResponse);
}

class VpVehicleListSuccess extends VpHomeState {
  final VehicleListResponse vehicleListResponse;

  VpVehicleListSuccess(this.vehicleListResponse);
}

class VpDriverListSuccess extends VpHomeState {
  final DriverListResponse driverListResponse;

  VpDriverListSuccess(this.driverListResponse);
}

class ScheduleTripSuccess extends VpHomeState {
  final ScheduleTripResponse scheduleTripResponse;

  ScheduleTripSuccess(this.scheduleTripResponse);
}

class ScheduleTripError extends VpHomeState {
  final ErrorType errorType;

  ScheduleTripError(this.errorType);
}

class VpMyLoadListError extends VpHomeState {
  final ErrorType errorType;

  VpMyLoadListError(this.errorType);
}

class VpRecentLoadListLoading extends VpHomeState {}

class VpRecentLoadListError extends VpHomeState {
  final ErrorType errorType;

  VpRecentLoadListError(this.errorType);
}

class VpRecentLoadListSuccess extends VpHomeState {
  final VpRecentLoadResponse vpRecentLoadResponse;

  VpRecentLoadListSuccess(this.vpRecentLoadResponse);
}

class VpAcceptLoadLoading extends VpHomeState {}

class VpAcceptLoadError extends VpHomeState {
  final ErrorType errorType;

  VpAcceptLoadError(this.errorType);
}

class VpAcceptLoadSuccess extends VpHomeState {
  final VpLoadAcceptModel vpLoadAcceptModel;

  VpAcceptLoadSuccess(this.vpLoadAcceptModel);
}