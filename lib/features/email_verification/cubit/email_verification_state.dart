part of 'email_verification_cubit.dart';

class EmailVerificationState extends Equatable {
  final UIState<EmailOtpModel>? sendOtpState;
  final UIState<VerifyEmailOtpModel>? verifyOtpState;
  final String otpCode;
  final bool isVerifyButtonEnabled;
  final bool isResendButtonEnabled;
  final int timerValue;
  final bool isVerifiedEmail;
  const EmailVerificationState({
    this.sendOtpState,
    this.verifyOtpState,
    this.otpCode = '',
    this.isVerifyButtonEnabled = false,
    this.isResendButtonEnabled = true,
    this.timerValue = 0,
    this.isVerifiedEmail = false
  });

  EmailVerificationState copyWith({
    UIState<EmailOtpModel>? sendOtpState,
    UIState<VerifyEmailOtpModel>? verifyOtpState,
    String? otpCode,
    bool? isVerifyButtonEnabled,
    int? timerValue,
    bool? isVerifiedEmail
  }) {
    return EmailVerificationState(
      sendOtpState: sendOtpState ?? this.sendOtpState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
      otpCode: otpCode ?? this.otpCode,
      isVerifyButtonEnabled: isVerifyButtonEnabled ?? this.isVerifyButtonEnabled,
      timerValue: timerValue ?? this.timerValue,
      isVerifiedEmail: isVerifiedEmail ?? this.isVerifiedEmail
    );
  }

  @override
  List<Object?> get props => [sendOtpState, verifyOtpState, otpCode, isVerifyButtonEnabled, timerValue, isVerifiedEmail];
}

