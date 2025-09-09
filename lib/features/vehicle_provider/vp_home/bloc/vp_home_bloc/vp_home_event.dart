part of 'vp_home_bloc.dart';

@immutable
sealed class VpHomeEvent {}

class VpMyLoadListRequested extends VpHomeEvent {
  VpMyLoadListRequested();
}

class VpVehicleListRequested extends VpHomeEvent {
  final String userId;
  String? search;
  VpVehicleListRequested({required this.userId, this.search});
}

class VpDriverDetailsRequested extends VpHomeEvent {
  final String userId;
  String? search;
  final bool loadMore;
  final int limit;
  VpDriverDetailsRequested({
    required this.userId,
    this.search,
    this.loadMore = false,
    this.limit = 10,
  });
}

class ScheduleTripRequested extends VpHomeEvent {
  final ScheduleTripRequest apiRequest;
  ScheduleTripRequested({required this.apiRequest});
}
