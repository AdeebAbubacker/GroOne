import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/email_verification/api_request/verify_email_otp_api_request.dart';
import 'package:gro_one_app/features/email_verification/model/email_otp_model.dart';
import 'package:gro_one_app/features/email_verification/model/verify_email_otp_model.dart';
import 'package:gro_one_app/features/email_verification/repository/email_verification_repository.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final EmailVerificationRepository _repository;
  Timer? _timer;
  EmailVerificationCubit(this._repository) : super(EmailVerificationState());


  // Set Otp
  void setOtp(String? value) {
    emit(state.copyWith(otpCode: value ?? ''));
  }

  // Enable verify button
  void enableVerifyButton(bool value){
    emit(state.copyWith(isVerifyButtonEnabled: value));
  }

  // Enable verify button
  void setVerifiedEmail(bool value){
    emit(state.copyWith(isVerifiedEmail: value));
  }


  // Start Timer
  void startTimer({int startFrom = 10}) {
    _timer?.cancel();
    emit(state.copyWith(timerValue : startFrom, isVerifyButtonEnabled: false));

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final newTime = state.timerValue - 1;

      if (newTime <= 0) {
        timer.cancel();
        emit(state.copyWith(timerValue: 0, isVerifyButtonEnabled: true));
      } else {
        emit(state.copyWith(timerValue: newTime));
      }
    });
  }


  // Sent Otp Api Call
  Future<void> sendOtp(String email) async {
    emit(state.copyWith(sendOtpState: UIState.loading()));
    Result result = await _repository.getSendOtpData(email);
    if (result is Success<EmailOtpModel>) {
      emit(state.copyWith(sendOtpState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(sendOtpState: UIState.error(result.type)));
    }
  }


  // Sent Otp Api Call
  Future<void> verifyOtp(VerifyEmailOtpApiRequest request) async {
    emit(state.copyWith(verifyOtpState: UIState.loading()));
    Result result = await _repository.getVerifyOtpData(request);
    if (result is Success<VerifyEmailOtpModel>) {
      emit(state.copyWith(verifyOtpState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(verifyOtpState: UIState.error(result.type)));
    }
  }


  // Reset UI
  void resetState(){
    setOtp(null);
    enableVerifyButton(false);
    setVerifiedEmail(false);
    emit(state.copyWith(sendOtpState: null, verifyOtpState: null));
  }


}
