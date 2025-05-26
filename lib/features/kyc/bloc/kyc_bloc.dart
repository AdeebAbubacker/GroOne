import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_verify_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/model/addhar_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/addhar_verify_otp_response.dart';
import '../../../../data/model/result.dart';
import '../api_request/verify_pan_request.dart';
import '../api_request/verify_tan_request.dart';
import '../model/verify_gst_response.dart';
import '../model/verify_pan_response.dart';
import '../model/verify_tan_response.dart';
import '../repository/kyc_repository.dart';

part 'kyc_event.dart';

part 'kyc_state.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  final KycRepository _kycRepository;

  KycBloc(this._kycRepository) : super(KycInitial()) {
    on<AddharOtpRequested>((event, emit) async {
      emit(AddharLoading());
      Result result = await _kycRepository.kycSendOtp(event.apiRequest);

      if (result is Success<AddharOtpResponse>) {
        emit(AddharOtpSuccess(result.value));
      } else if (result is Error) {
        emit(AddharOtpError(result.type));
      } else {
        emit(AddharOtpError(GenericError()));
      }
    });
    on<AddharVerifyOtpRequested>((event, emit) async {
      emit(AddharLoading());
      Result result = await _kycRepository.verifyAddharOtp(event.apiRequest);

      if (result is Success<AddharVerifyOtpResponse>) {
        emit(AddharVerifyOtpSuccess(result.value));
      } else if (result is Error) {
        emit(AddharOtpError(result.type));
      } else {
        emit(AddharOtpError(GenericError()));
      }
    });
    //verify gst
    on<VerifyGstRequested>((event, emit) async {
      emit(VerifyGstLoading());
      Result result = await _kycRepository.verifyGST(event.apiRequest);

      if (result is Success<VerifyGstResponse>) {
        emit(VerifyGstSuccess(result.value));
      } else if (result is Error) {
        emit(AddharOtpError(result.type));
      } else {
        emit(AddharOtpError(GenericError()));
      }
    });
    //verify pan
    on<VerifyTanRequested>((event, emit) async {
      emit(VerifyTanLoading());
      Result result = await _kycRepository.verifyTan(event.apiRequest);

      if (result is Success<VerifyTanResponse>) {
        emit(VerifyTanSuccess(result.value));
      } else if (result is Error) {
        emit(AddharOtpError(result.type));
      } else {
        emit(AddharOtpError(GenericError()));
      }
    });
    //verify tan
    on<VerifyPanRequested>((event, emit) async {
      emit(VerifyPanLoading());
      Result result = await _kycRepository.verifyPan(event.apiRequest);

      if (result is Success<VerifyPanResponse>) {
        emit(VerifyPanSuccess(result.value));
      } else if (result is Error) {
        emit(AddharOtpError(result.type));
      } else {
        emit(AddharOtpError(GenericError()));
      }
    });
  }
}
