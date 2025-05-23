part of 'vp_creation_bloc.dart';

@immutable
sealed class VpCreationEvent {}

class VpCreationRequested extends VpCreationEvent {
  final SignInApiRequest apiRequest;
  VpCreationRequested({required this.apiRequest});
}
