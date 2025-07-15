part of 'otp_bloc.dart';

class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}
class OtpResendLoading extends OtpState {}

class OtpSuccess extends OtpState {
  final MobileOtpVerificationModel otpResponse;

  OtpSuccess(this.otpResponse);
}

class OtpResendSuccess extends OtpState {
  final MobileOtpResendModel loginApiResponseModel;

  OtpResendSuccess(this.loginApiResponseModel);
}

class OtpError extends OtpState {
  final ErrorType errorType;

  OtpError(this.errorType);
}
