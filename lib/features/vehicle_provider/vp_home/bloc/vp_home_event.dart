part of 'vp_home_bloc.dart';

@immutable
sealed class VpHomeEvent {}

class VpMyLoadListRequested extends VpHomeEvent {
  VpMyLoadListRequested();
}


class VpVehicleListRequested extends VpHomeEvent {
  final String userId;
  VpVehicleListRequested({required this.userId});
}

class VpDriverDetailsRequested extends VpHomeEvent {
  final String userId;
  VpDriverDetailsRequested({required this.userId});
}

class ScheduleTripRequested extends VpHomeEvent {
  final ScheduleTripRequest apiRequest;
  ScheduleTripRequested({required this.apiRequest});
}


