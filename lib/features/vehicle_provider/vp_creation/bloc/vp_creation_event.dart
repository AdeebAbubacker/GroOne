part of 'vp_creation_bloc.dart';

sealed class VpCreationEvent {}

// Vp Creation Event
class VpCreationRequested extends VpCreationEvent {
  final VpCreationApiRequest apiRequest;
  final String id;
  VpCreationRequested({required this.apiRequest,required this.id});
}
