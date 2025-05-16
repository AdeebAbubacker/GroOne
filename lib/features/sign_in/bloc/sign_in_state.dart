part of 'sign_in_bloc.dart';

@immutable
sealed class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}


class SignInSuccess extends SignInState {
  final SignInModel signInModel;
  SignInSuccess(this.signInModel);
}


class SignInError extends SignInState {
  final ErrorType errorType;
  SignInError(this.errorType);
}