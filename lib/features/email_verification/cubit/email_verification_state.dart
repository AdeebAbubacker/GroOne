part of 'email_verification_cubit.dart';

class EmailVerificationState extends Equatable {
  final UIState<SendEmailOtpModel>? sendOtpState;
  final UIState<ResendEmailOtpModel>? resendOtpState;
  final UIState<VerifyEmailOtpModel>? verifyOtpState;
  final String otpCode;
  final bool isVerifyButtonEnabled;
  final bool isResendButtonEnabled;
  final int timerValue;
  final bool isVerifiedEmail;
  const EmailVerificationState({
    this.sendOtpState,
    this.resendOtpState,
    this.verifyOtpState,
    this.otpCode = '',
    this.isVerifyButtonEnabled = false,
    this.isResendButtonEnabled = false,
    this.timerValue = 0,
    this.isVerifiedEmail = false,
  });

  EmailVerificationState copyWith({
    UIState<SendEmailOtpModel>? sendOtpState,
    UIState<ResendEmailOtpModel>? resendOtpState,
    UIState<VerifyEmailOtpModel>? verifyOtpState,
    String? otpCode,
    bool? isVerifyButtonEnabled,
    bool? isResendButtonEnabled,
    int? timerValue,
    bool? isVerifiedEmail,
  }) {
    return EmailVerificationState(
      sendOtpState: sendOtpState ?? this.sendOtpState,
      resendOtpState: resendOtpState ?? this.resendOtpState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
      otpCode: otpCode ?? this.otpCode,
      isVerifyButtonEnabled: isVerifyButtonEnabled ?? this.isVerifyButtonEnabled,
      isResendButtonEnabled: isResendButtonEnabled ?? this.isResendButtonEnabled,
      timerValue: timerValue ?? this.timerValue,
      isVerifiedEmail: isVerifiedEmail ?? this.isVerifiedEmail,
    );
  }

  @override
  List<Object?> get props => [
    sendOtpState,
    resendOtpState,
    verifyOtpState,
    otpCode,
    isVerifyButtonEnabled,
    isResendButtonEnabled,
    timerValue,
    isVerifiedEmail,
  ];
}
