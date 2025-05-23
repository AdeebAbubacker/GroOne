
part of 'login_bloc.dart';



enum LoginStatus { initial, isLoading, isSuccess, isFailed }

class LoginState extends Equatable {
  const LoginState({this.index = 0, this.status = LoginStatus.initial});

  final int index;
  final LoginStatus status;

  LoginState copyWith({int? counter, LoginStatus? status}) => LoginState(
    index: counter ?? this.index,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [index, status];
}

class LogInInitial extends LoginState {}

class LogInLoading extends LoginState {}


class LogInSuccess extends LoginState {
  final LoginApiResponseModel loginApiResponseModel;
  LogInSuccess(this.loginApiResponseModel);
}


class LogInError extends LoginState {
  final ErrorType errorType;
  LogInError(this.errorType);
}