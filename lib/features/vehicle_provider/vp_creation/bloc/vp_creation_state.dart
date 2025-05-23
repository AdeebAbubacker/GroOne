part of 'vp_creation_bloc.dart';

@immutable
sealed class VpCreationState {}

class VpCreationInitial extends VpCreationState {}

class VpCreationLoading extends VpCreationState {}

class VpCreationSuccess extends VpCreationState {
  final SignInModel signInModel;
  VpCreationSuccess(this.signInModel);
}

class VpCreationError extends VpCreationState {
  final ErrorType errorType;
  VpCreationError(this.errorType);
}