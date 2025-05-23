part of 'otp_bloc.dart';

@immutable
sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class OtpRequested extends OtpEvent {
  final OtpRequest apiRequest;

  const OtpRequested({required this.apiRequest});
}

class OtpResendRequested extends OtpEvent {
  final LoginApiRequest apiRequest;

  const OtpResendRequested({required this.apiRequest});
}
