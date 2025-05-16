part of 'sign_in_bloc.dart';

@immutable
sealed class SignInEvent {}

class SignInRequested extends SignInEvent {
  final SignInApiRequest apiRequest;
  SignInRequested({required this.apiRequest});
}
