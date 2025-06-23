part of 'vp_creation_bloc.dart';

sealed class VpCreationEvent {}

// Vp Creation Event
class VpCreationRequested extends VpCreationEvent {
  final VpCreationApiRequest apiRequest;
  final String id;
  VpCreationRequested({required this.apiRequest,required this.id});
}

// Truck Type
class GetTruckTypeEvent extends VpCreationEvent {}

// Truck Pref Lane Type
class GetTruckPrefLaneEvent extends VpCreationEvent {
  final String? location;
  GetTruckPrefLaneEvent({this.location});
}

// Logout Event
class LogoutRequested extends VpCreationEvent {}

// Logout API Event
class LogoutAPIRequested extends VpCreationEvent {
  final LogOutRequest apiRequest;
  LogoutAPIRequested({required this.apiRequest});
}


class VpCompanyTypeEvent extends VpCreationEvent {
  VpCompanyTypeEvent();
}

// Reset Event
class VpResetEvent extends VpCreationEvent {}
