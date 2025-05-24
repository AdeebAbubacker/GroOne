part of 'vp_creation_bloc.dart';

sealed class VpCreationEvent {}

class VpCreationRequested extends VpCreationEvent {
  final VpCreationApiRequest apiRequest;
  final String id;
  VpCreationRequested({required this.apiRequest,required this.id});
}
