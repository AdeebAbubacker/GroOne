part of 'kyc_bloc.dart';

@immutable
sealed class KycEvent {}

class AddharOtpRequested extends KycEvent {
  final AddharOtpRequest apiRequest;

  AddharOtpRequested({required this.apiRequest});
}

class AddharVerifyOtpRequested extends KycEvent {
  final AddharVerifyOtpRequest apiRequest;

  AddharVerifyOtpRequested({required this.apiRequest});
}

class VerifyGstRequested extends KycEvent {
  final VerifyGstRequest apiRequest;

  VerifyGstRequested({required this.apiRequest});
}

class VerifyTanRequested extends KycEvent {
  final VerifyTanRequest apiRequest;

  VerifyTanRequested({required this.apiRequest});
}

class VerifyPanRequested extends KycEvent {
  final VerifyPanRequest apiRequest;

  VerifyPanRequested({required this.apiRequest});
}

class SubmitKycRequested extends KycEvent {
  final SubmitKycRequestLp apiRequest;
  String userId;

  SubmitKycRequested({required this.apiRequest,required this.userId});
}

class UploadFileRequested extends KycEvent {
  final File file;

  UploadFileRequested({required this.file});
}
