part of 'vp_creation_bloc.dart';

sealed class VpCreationState {}

/// Vp Creation State
class VpCreationInitial extends VpCreationState {}

class VpCreationLoading extends VpCreationState {}

class VpCreationSuccess extends VpCreationState {
  final UserModel? vpCreationModel;
  VpCreationSuccess(this.vpCreationModel);
}

class VpCreationError extends VpCreationState {
  final ErrorType errorType;
  VpCreationError(this.errorType);
}

/// Logout State
class LogoutInitial extends VpCreationState {}

class LogoutLoading extends VpCreationState {}
class LogOutAPILoading extends VpCreationState {}

class LogoutSuccess extends VpCreationState {}
class LogOutAPISuccess extends VpCreationState {
  LogOutResponse logOutResponse;
  LogOutAPISuccess(this.logOutResponse);
}

class LogoutError extends VpCreationState {
  final ErrorType errorType;
  LogoutError(this.errorType);
}


