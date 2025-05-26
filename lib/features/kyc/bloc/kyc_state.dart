part of 'kyc_bloc.dart';

@immutable
sealed class KycState {}

final class KycInitial extends KycState {}

class AddharLoading extends KycState {}
class VerifyGstLoading extends KycState {}
class VerifyTanLoading extends KycState {}
class VerifyPanLoading extends KycState {}
class UploadFileLoading extends KycState {}
class SubmitKycLoading extends KycState {}

class AddharOtpSuccess extends KycState {
  final AddharOtpResponse addharOtpResponse;

  AddharOtpSuccess(this.addharOtpResponse);
}

class AddharVerifyOtpSuccess extends KycState {
  final AddharVerifyOtpResponse addharVerifyOtpResponse;

  AddharVerifyOtpSuccess(this.addharVerifyOtpResponse);
}

class VerifyGstSuccess extends KycState {
  final VerifyGstResponse verifyGstResponse;

  VerifyGstSuccess(this.verifyGstResponse);
}
class VerifyTanSuccess extends KycState {
  final VerifyTanResponse verifyTanResponse;

  VerifyTanSuccess(this.verifyTanResponse);
}class VerifyPanSuccess extends KycState {
  final VerifyPanResponse verifyPanResponse;

  VerifyPanSuccess(this.verifyPanResponse);
}
class UploadFileSuccess extends KycState {
  final UploadFileModel uploadFileModel;

  UploadFileSuccess(this.uploadFileModel);
}class SubmitKycSuccess extends KycState {
  final SubmitKycResponse submitKycResponse;

  SubmitKycSuccess(this.submitKycResponse);
}

class AddharOtpError extends KycState {
  final ErrorType errorType;

  AddharOtpError(this.errorType);
}
