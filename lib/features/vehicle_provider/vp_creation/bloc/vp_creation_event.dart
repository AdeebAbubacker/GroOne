part of 'vp_creation_bloc.dart';

sealed class VpCreationEvent {}

/// Vp Creation Event
class VpCreationRequested extends VpCreationEvent {
  final VpCreationApiRequest apiRequest;
  final String id;
  VpCreationRequested({required this.apiRequest,required this.id});
}

/// Logout Event
class LogoutRequested extends VpCreationEvent {

}
/// Logout API Event
class LogoutAPIRequested extends VpCreationEvent {
  final LogOutRequest apiRequest;

  LogoutAPIRequested({required this.apiRequest});
}