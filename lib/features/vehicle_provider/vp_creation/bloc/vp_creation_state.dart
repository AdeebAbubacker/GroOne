part of 'vp_creation_bloc.dart';

sealed class VpCreationState {}

class VpCreationInitial extends VpCreationState {}

class VpCreationLoading extends VpCreationState {}

class VpCreationSuccess extends VpCreationState {
  final VpCreationModel vpCreationModel;
  VpCreationSuccess(this.vpCreationModel);
}

class VpCreationError extends VpCreationState {
  final ErrorType errorType;
  VpCreationError(this.errorType);
}