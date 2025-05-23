part of 'vp_creation_bloc.dart';

sealed class VpCreationEvent {}

class VpCreationRequested extends VpCreationEvent {
  final VpCreationApiRequest apiRequest;
  VpCreationRequested({required this.apiRequest});
}
