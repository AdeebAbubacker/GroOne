import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/login/model/login_model.dart';
import 'package:gro_one_app/features/otp_verification/model/mobile_otp_resend_model%20copy.dart';
import 'package:gro_one_app/features/otp_verification/model/mobile_otp_verification_model.dart';
import 'package:gro_one_app/features/otp_verification/repository/mobile_otp_verification_repository.dart';

import '../../../data/model/result.dart';
import '../api_request/mobile_otp_verification_api_request.dart';

part 'otp_event.dart';

part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final MobileOtpVerificationRepository _repository;

  OtpBloc(this._repository) : super(const OtpState()) {
    on<OtpRequested>((event, emit) async {
      emit(OtpLoading());
      Result result = await _repository.sendOtp(event.apiRequest);

      if (result is Success<MobileOtpVerificationModel>) {
        emit(OtpSuccess(result.value));
      } else if (result is Error) {
        emit(OtpError(result.type));
      } else {
        emit(OtpError(GenericError()));
      }
    });

    on<OtpResendRequested>((event, emit) async {
      emit(OtpResendLoading());
      Result result = await _repository.resendOtp(event.apiRequest);

      if (result is Success<MobileOtpResendModel>) {
        emit(OtpResendSuccess(result.value));
      } else if (result is Error) {
        emit(OtpError(result.type));
      } else {
        emit(OtpError(GenericError()));
      }
    });
  }
}
