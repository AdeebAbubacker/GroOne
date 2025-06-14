part of 'email_verification_cubit.dart';

class EmailVerificationState extends Equatable {
  final UIState<EmailOtpModel>? emailOtpState;
  final UIState<VerifyEmailOtpModel>? verifyOtpState;
  final String otpCode;
  final bool isVerifyButtonEnabled;
  final bool isResendButtonEnabled;
  final int timerValue;
  const EmailVerificationState({
    this.emailOtpState,
    this.verifyOtpState,
    this.otpCode = '',
    this.isVerifyButtonEnabled = false,
    this.isResendButtonEnabled = true,
    this.timerValue = 0,
  });

  EmailVerificationState copyWith({
    emailOtpState,
    verifyOtpState,
    String? otpCode,
    bool? isVerifyButtonEnabled,
    int? timerValue,
  }) {
    return EmailVerificationState(
      emailOtpState: emailOtpState ?? this.emailOtpState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
      otpCode: otpCode ?? this.otpCode,
      isVerifyButtonEnabled: isVerifyButtonEnabled ?? this.isVerifyButtonEnabled,
      timerValue: timerValue ?? this.timerValue,
    );
  }

  @override
  List<Object?> get props => [emailOtpState, verifyOtpState, otpCode, isVerifyButtonEnabled, timerValue];
}

