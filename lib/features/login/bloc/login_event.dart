part of 'login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}


class ChangeIndex extends LoginEvent{
  final int index;

  const ChangeIndex({ required this.index});
}