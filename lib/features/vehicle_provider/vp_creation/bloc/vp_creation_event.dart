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
