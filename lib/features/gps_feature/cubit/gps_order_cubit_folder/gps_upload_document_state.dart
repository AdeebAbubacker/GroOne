import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';

import '../../gps_order_request/gps_order_api_request.dart';

class GpsUploadDocumentState extends Equatable {
  final String aadhaar;
  final bool isAadhaarValid;
  final bool isAadhaarVerified;
  final UIState<GpsAadhaarSendOtpResponse>? aadhaarSendOtpState;
  final UIState<GpsAadhaarVerifyOtpResponse>? aadhaarVerifyOtpState;
  final String? aadhaarRequestId;
  final String? aadhaarDocLink;


  final String pan;
  final bool isPanValid;
  final bool isPanVerified;
  final UIState<GpsPanVerificationResponse>? panVerificationState;

  final bool hasAttemptedSubmit;
  // Only PAN document list (used for all document fields)
  final List<Map<String, dynamic>> panDocuments;
  final UIState<GpsKycUploadResponseModel>? uploadKycState;

  const GpsUploadDocumentState({
    required this.aadhaar,
    required this.isAadhaarValid,
    required this.isAadhaarVerified,
    required this.aadhaarSendOtpState,
    required this.aadhaarVerifyOtpState,
    required this.aadhaarRequestId,
    required this.pan,
    required this.isPanValid,
    required this.isPanVerified,
    required this.panVerificationState,
    required this.hasAttemptedSubmit,
    this.panDocuments = const [],
    this.uploadKycState,
    this.aadhaarDocLink,
  });

  factory GpsUploadDocumentState.initial() => GpsUploadDocumentState(
    aadhaar: '',
    isAadhaarValid: false,
    isAadhaarVerified: false,
    aadhaarSendOtpState: null,
    aadhaarVerifyOtpState: null,
    aadhaarRequestId: null,
    pan: '',
    isPanValid: true, // PAN is optional, so it's valid by default
    isPanVerified: false,
    panVerificationState: null,
    hasAttemptedSubmit: false,
    panDocuments: [],
    uploadKycState: null,
  );

  GpsUploadDocumentState copyWith({
    String? aadhaar,
    bool? isAadhaarValid,
    bool? isAadhaarVerified,
    UIState<GpsAadhaarSendOtpResponse>? aadhaarSendOtpState,
    UIState<GpsAadhaarVerifyOtpResponse>? aadhaarVerifyOtpState,
    String? aadhaarRequestId,
    String? pan,
    bool? isPanValid,
    bool? isPanVerified,
    UIState<GpsPanVerificationResponse>? panVerificationState,
    bool? hasAttemptedSubmit,
    List<Map<String, dynamic>>? panDocuments,
    UIState<GpsKycUploadResponseModel>? uploadKycState,
    String? aadhaarDocLink,
  }) {
    return GpsUploadDocumentState(
      aadhaar: aadhaar ?? this.aadhaar,
      isAadhaarValid: isAadhaarValid ?? this.isAadhaarValid,
      isAadhaarVerified: isAadhaarVerified ?? this.isAadhaarVerified,
      aadhaarSendOtpState: aadhaarSendOtpState ?? this.aadhaarSendOtpState,
      aadhaarVerifyOtpState: aadhaarVerifyOtpState ?? this.aadhaarVerifyOtpState,
      aadhaarRequestId: aadhaarRequestId ?? this.aadhaarRequestId,
      pan: pan ?? this.pan,
      isPanValid: isPanValid ?? this.isPanValid,
      isPanVerified: isPanVerified ?? this.isPanVerified,
      panVerificationState: panVerificationState ?? this.panVerificationState,
      hasAttemptedSubmit: hasAttemptedSubmit ?? this.hasAttemptedSubmit,
      panDocuments: panDocuments ?? this.panDocuments,
      uploadKycState: uploadKycState ?? this.uploadKycState,
      aadhaarDocLink: aadhaarDocLink ?? this.aadhaarDocLink,
    );
  }

  @override
  List<Object?> get props => [
    aadhaar,
    isAadhaarValid,
    isAadhaarVerified,
    aadhaarSendOtpState,
    aadhaarVerifyOtpState,
    aadhaarRequestId,
    pan,
    isPanValid,
    isPanVerified,
    panVerificationState,
    hasAttemptedSubmit,
    panDocuments,
    uploadKycState,
    aadhaarDocLink
  ];
} 