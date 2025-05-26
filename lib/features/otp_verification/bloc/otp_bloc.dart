import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/features/login/api_request/login_in_api_request.dart';
import 'package:gro_one_app/features/login/model/login_model.dart';
import 'package:gro_one_app/features/otp_verification/model/otp_response.dart';
import 'package:gro_one_app/features/otp_verification/repository/otp_repository.dart';

import '../../../data/model/result.dart';
import '../api_request/otp_request.dart';

part 'otp_event.dart';

part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OtpRepository _repository;

  OtpBloc(this._repository) : super(const OtpState()) {
    on<OtpRequested>((event, emit) async {
      emit(OtpLoading());
      Result result = await _repository.sendOtp(event.apiRequest);

      if (result is Success<OtpResponse>) {
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

      if (result is Success<LoginApiResponseModel>) {
        emit(OtpResendSuccess(result.value));
      } else if (result is Error) {
        emit(OtpError(result.type));
      } else {
        emit(OtpError(GenericError()));
      }
    });
  }
}
