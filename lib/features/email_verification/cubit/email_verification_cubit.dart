import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/email_verification/api_request/verify_email_otp_api_request.dart';
import 'package:gro_one_app/features/email_verification/model/resend_email_otp_model.dart';
import 'package:gro_one_app/features/email_verification/model/send_email_otp_model.dart';
import 'package:gro_one_app/features/email_verification/model/verify_email_otp_model.dart';
import 'package:gro_one_app/features/email_verification/repository/email_verification_repository.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends BaseCubit<EmailVerificationState> {
  final EmailVerificationRepository _repository;
  Timer? _timer;
  EmailVerificationCubit(this._repository) : super(EmailVerificationState());
  String? _lastVerifiedEmail;

  // Set Otp
  void setOtp(String? value) {
    emit(state.copyWith(otpCode: value ?? ''));
  }

  // Enable verify button
  void enableVerifyButton(bool value) {
    emit(state.copyWith(isVerifyButtonEnabled: value));
  }

  // Enable verify button
  void setVerifiedEmail(bool value, {String? email}) {
    emit(state.copyWith(isVerifiedEmail: value));
    if (state.isVerifiedEmail && email != null) {
      _lastVerifiedEmail = email;
    }
  }

  // Start Timer
  void startTimer({int startFrom = 30}) {
    _timer?.cancel();
    emit(
      state.copyWith(
        timerValue: startFrom,
        isVerifyButtonEnabled: false,
        isResendButtonEnabled: true,
      ),
    );

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final newTime = state.timerValue - 1;

      if (newTime <= 0) {
        timer.cancel();
        emit(
          state.copyWith(
            timerValue: 0,
            isVerifyButtonEnabled: true,
            isResendButtonEnabled: false,
          ),
        );
      } else {
        emit(state.copyWith(timerValue: newTime));
      }
    });
  }

  // Sent Otp Api Call
  void _setSendOtpUIState(UIState<SendEmailOtpModel>? uiState) {
    emit(state.copyWith(sendOtpState: uiState));
  }

  Future<void> sendOtp(String email, userId) async {
    _setSendOtpUIState(UIState.loading());
    Result result = await _repository.getSendOtpData(email, userId);
    if (result is Success<SendEmailOtpModel>) {
      _setSendOtpUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setSendOtpUIState(UIState.error(result.type));
    }
  }

  // Verify Otp Api Call
  void _setVerifyOtpUIState(UIState<VerifyEmailOtpModel>? uiState) {
    emit(state.copyWith(verifyOtpState: uiState));
  }

  Future<void> verifyOtp(VerifyEmailOtpApiRequest request) async {
    _setVerifyOtpUIState(UIState.loading());
    Result result = await _repository.getVerifyOtpData(request);
    if (result is Success<VerifyEmailOtpModel>) {
      _setVerifyOtpUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setVerifyOtpUIState(UIState.error(result.type));
    }
  }

  // Reset Resend and Verify Otp UI State
  void resetResendAndVerifyOtpUIState() {
    emit(
      state.copyWith(
        verifyOtpState: resetUIState<VerifyEmailOtpModel>(state.verifyOtpState),
        resendOtpState: resetUIState<ResendEmailOtpModel>(state.resendOtpState),
      ),
    );
  }

  /// check modified email
  void checkIfEmailChanged(String currentEmail) {
    final isSame = currentEmail.trim() == _lastVerifiedEmail?.trim();
    emit(state.copyWith(isVerifiedEmail: isSame));
  }

  // Reset UI
  void resetState() {
    _timer?.cancel();
    emit(
      state.copyWith(
        sendOtpState: resetUIState<SendEmailOtpModel>(state.sendOtpState),
        verifyOtpState: resetUIState<VerifyEmailOtpModel>(state.verifyOtpState),
        resendOtpState: resetUIState<ResendEmailOtpModel>(state.resendOtpState),
        isVerifiedEmail: false,
        isResendButtonEnabled: false,
        isVerifyButtonEnabled: false,
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
