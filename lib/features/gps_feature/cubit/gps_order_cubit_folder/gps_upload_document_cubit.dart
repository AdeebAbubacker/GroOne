import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';

import 'gps_upload_document_state.dart';



class GpsUploadDocumentCubit extends Cubit<GpsUploadDocumentState> {
  final GpsOrderApiRepository _repository;
  bool _isClosed = false;

  GpsUploadDocumentCubit(this._repository) : super(GpsUploadDocumentState.initial());

  @override
  Future<void> close() {
    print('🔒 GpsUploadDocumentCubit.close() called');
    print('🔒 Stack trace: ${StackTrace.current}');
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    print('🔄 Resetting GpsUploadDocumentCubit state');
    _isClosed = false;
    emit(GpsUploadDocumentState.initial());
  }

  /// Debug method to check cubit status
  void debugCubitStatus() {
    print('🔍 GPS Cubit Status:');
    print('  Is Closed: $_isClosed');
    print('  State: ${state.runtimeType}');
    print('  Aadhaar: "${state.aadhaar}"');
    print('  PAN: "${state.pan}"');
    print('  Is Aadhaar Valid: ${state.isAadhaarValid}');
    print('  Is Aadhaar Verified: ${state.isAadhaarVerified}');
    print('  Is PAN Valid: ${state.isPanValid}');
    print('  Is PAN Verified: ${state.isPanVerified}');
  }

  // ==================== Aadhaar Logic ====================

  void setAadhaar(String value) {
    print('🔍 GPS setAadhaar called with: "$value", cubit closed: $_isClosed');
    if (!_isClosed) {
      emit(state.copyWith(aadhaar: value));
      print('🔍 GPS Aadhaar state updated to: "${state.aadhaar}"');
    } else {
      print('🔍 GPS Cubit is closed, cannot update Aadhaar state');
    }
  }

  void validateAadhaar(String value) {
    print('🔍 GPS validateAadhaar called with: "$value", cubit closed: $_isClosed');
    final isValid = _validateAadhaar(value) == null;
    print('🔍 GPS Aadhaar Validation Debug:');
    print('  - Input value: "$value"');
    print('  - Validation result: $isValid');
    print('  - Error message: ${_validateAadhaar(value)}');
    if (!_isClosed) {
      emit(state.copyWith(isAadhaarValid: isValid));
      print('🔍 GPS isAadhaarValid updated to: $isValid');
    } else {
      print('🔍 GPS Cubit is closed, cannot update validation state');
    }
  }

  String? getAadhaarValidationError(String value) {
    if (!state.hasAttemptedSubmit) return null;
    return _validateAadhaar(value);
  }

  String? _validateAadhaar(String value) {
    if (value.isEmpty) {
      return 'Aadhaar number is required';
    }
    String cleanAadhaar = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanAadhaar.length != 12) {
      return 'Aadhaar number must be 12 digits';
    }
    return null;
  }

  void _setAadhaarSendOtpUIState(UIState<GpsAadhaarSendOtpResponse> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(aadhaarSendOtpState: uiState));
    }
  }

  void _setAadhaarVerifyOtpUIState(UIState<GpsAadhaarVerifyOtpResponse> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(aadhaarVerifyOtpState: uiState));
    }
  }

  Future<void> sendAadhaarOtp() async {
    print('🔍 GPS sendAadhaarOtp called, cubit closed: $_isClosed');
    print('🔍 GPS Current aadhaar: "${state.aadhaar}"');
    
    if (_isClosed) {
      print('🔍 GPS Cubit is closed, returning early');
      return;
    }

    if (state.aadhaar.isEmpty) {
      print('🔍 GPS Aadhaar is empty, returning early');
      return;
    }

    // Aadhaar OTP doesn't require authentication

    print('🔍 GPS Setting Aadhaar send OTP UI state to loading...');
    _setAadhaarSendOtpUIState(UIState.loading());

    try {
      final request = GpsAadhaarSendOtpRequest(
        aadhaar: state.aadhaar,
        force: true,
      );

      final result = await _repository.sendAadhaarOtp(request);

      if (_isClosed) {
        print('🔍 GPS Cubit is closed after API call, returning early');
        return;
      }

      if (result is Success<GpsAadhaarSendOtpResponse>) {
        final response = result.value;
        print('🔍 GPS Aadhaar OTP sent successfully, response: $response');
        print('🔍 GPS Response JSON: ${response.toJson()}');
        print('🔍 GPS Raw response.requestId: "${response.requestId}"');
        print('🔍 GPS Response.requestId is null: ${response.requestId == null}');
        print('🔍 GPS Response.requestId is empty: ${response.requestId?.isEmpty}');
        
        // Use actual request ID from API response, fallback to static if not provided
        final requestId = response.requestId?.isNotEmpty == true ? response.requestId! : 'static_request_id_123';
        print('🔍 GPS Final requestId to use: "$requestId"');
        
        print('🔍 GPS Emitting new state with requestId: $requestId');
        emit(state.copyWith(aadhaarRequestId: requestId));
        print('🔍 GPS State updated, new requestId: ${state.aadhaarRequestId}');
        _setAadhaarSendOtpUIState(UIState.success(response));
      } else if (result is Error) {
        print('❌ GPS Aadhaar OTP send failed: ${(result as Error).type}');
        _setAadhaarSendOtpUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      print('💥 GPS Aadhaar OTP send exception: $e');
      if (!_isClosed) {
        _setAadhaarSendOtpUIState(UIState.error(GenericError()));
      }
    }
  }

  Future<void> verifyAadhaarOtp(String otp) async {
    print('🔍 GPS verifyAadhaarOtp called with OTP: "$otp", cubit closed: $_isClosed');
    print('🔍 GPS Current state: aadhaar="${state.aadhaar}", requestId="${state.aadhaarRequestId}"');
    
    // Debug the current cubit status
    debugCubitStatus();
    
    if (_isClosed) {
      print('🔍 GPS Cubit is closed, returning early');
      return;
    }

    if (state.aadhaarRequestId == null || state.aadhaar.isEmpty) {
      print('🔍 GPS Missing requestId or Aadhaar, returning early');
      print('🔍 GPS Debug: aadhaarRequestId is null: ${state.aadhaarRequestId == null}');
      print('🔍 GPS Debug: aadhaar is empty: ${state.aadhaar.isEmpty}');
      return;
    }

    // Aadhaar OTP verification doesn't require authentication

    print('🔍 GPS Setting Aadhaar verify OTP UI state to loading...');
    _setAadhaarVerifyOtpUIState(UIState.loading());

    try {
      final request = GpsAadhaarVerifyOtpRequest(
        requestId: state.aadhaarRequestId!,
        otp: otp,
        aadhaar: state.aadhaar,
      );

      print('🔍 GPS Verify OTP Request:');
      print('🔍 GPS   requestId: "${request.requestId}"');
      print('🔍 GPS   otp: "${request.otp}"');
      print('🔍 GPS   aadhaar: "${request.aadhaar}"');
      print('🔍 GPS   Request JSON: ${request.toJson()}');

      final result = await _repository.verifyAadhaarOtp(request);

      if (_isClosed) {
        print('🔍 GPS Cubit is closed after API call, returning early');
        return;
      }

      if (result is Success<GpsAadhaarVerifyOtpResponse>) {
        final response = result.value;
        print('🔍 GPS Aadhaar OTP verification successful');
        print('🔍 GPS Response: $response');
        print('🔍 GPS Response JSON: ${response.toJson()}');
        print('🔍 GPS Response.isVerified: ${response.isVerified}');
        print('🔍 GPS Response.success: ${response.success}');
        print('🔍 GPS Response.message: ${response.message}');
        print('🔍 GPS Setting isAadhaarVerified to: ${response.isVerified}');
        emit(state.copyWith(isAadhaarVerified: response.isVerified));
        print('🔍 GPS Setting verify OTP UI state to success');
        _setAadhaarVerifyOtpUIState(UIState.success(response));
        print('🔍 GPS State updated successfully');
        print('🔍 GPS New state.isAadhaarVerified: ${state.isAadhaarVerified}');
      } else if (result is Error) {
        print('❌ GPS Aadhaar OTP verification failed: ${(result as Error).type}');
        _setAadhaarVerifyOtpUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      print('💥 GPS Aadhaar OTP verification exception: $e');
      if (!_isClosed) {
        _setAadhaarVerifyOtpUIState(UIState.error(GenericError()));
      }
    }
  }

  // ==================== PAN Logic ====================

  void setPan(String value) {
    print('🔍 GPS setPan called with: "$value", cubit closed: $_isClosed');
    if (!_isClosed) {
      emit(state.copyWith(pan: value));
      print('🔍 GPS PAN state updated to: "${state.pan}"');
    } else {
      print('🔍 GPS Cubit is closed, cannot update PAN state');
    }
  }

  void validatePan(String value) {
    final isValid = _validatePan(value) == null;
    print('🔍 GPS PAN Validation Debug:');
    print('  - Input value: "$value"');
    print('  - Length: ${value.length}');
    print('  - Validation result: $isValid');
    print('  - Error message: ${_validatePan(value)}');
    print('  - Current isPanVerified: ${state.isPanVerified}');

    if (!_isClosed) {
      emit(state.copyWith(isPanValid: isValid));

      // Auto-verify PAN when input is valid and complete (10 characters) and not empty
      if (isValid && value.isNotEmpty && value.length == 10 && !state.isPanVerified) {
        print('🔍 GPS PAN Auto-verification triggered!');
        // Add a small delay to avoid too many API calls
        Future.delayed(Duration(milliseconds: 500), () {
          if (!_isClosed && state.pan == value) {
            print('🔍 GPS PAN Auto-verification executing...');
            verifyPan();
          } else {
            print(
              '🔍 GPS PAN Auto-verification skipped - cubit closed or PAN changed',
            );
          }
        });
      } else {
        print('🔍 GPS PAN Auto-verification conditions not met:');
        print('  - isValid: $isValid');
        print('  - value.isNotEmpty: ${value.isNotEmpty}');
        print('  - length == 10: ${value.length == 10}');
        print('  - !isPanVerified: ${!state.isPanVerified}');
      }
    }
  }

  String? getPanValidationError(String value) {
    if (!state.hasAttemptedSubmit) return null;
    return _validatePan(value);
  }

  String? _validatePan(String value) {
    if (value.isEmpty) {
      return null; // PAN is optional, empty is valid
    }
    String cleanPan = value.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    RegExp panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(cleanPan)) {
      return 'Please enter valid PAN number (e.g., ABCDE1234F)';
    }
    return null;
  }

  void _setPanVerificationUIState(UIState<GpsPanVerificationResponse> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(panVerificationState: uiState));
    }
  }

  Future<void> verifyPan() async {
    print('🔍 GPS PAN Verification Debug: Starting verification...');
    if (_isClosed) {
      print('🔍 GPS PAN Verification Debug: Cubit is closed, returning');
      return;
    }

    if (state.pan.isEmpty) {
      print('🔍 GPS PAN Verification Debug: PAN is empty, marking as verified (optional field)');
      emit(state.copyWith(isPanVerified: true));
      return;
    }

    // PAN verification doesn't require authentication

    print('🔍 GPS PAN Verification Debug: PAN to verify: "${state.pan}"');
    _setPanVerificationUIState(UIState.loading());

    try {
      final request = GpsPanVerificationRequest(
        pan: state.pan,
        force: true,
      );

      final result = await _repository.verifyPan(request);

      if (_isClosed) {
        print('🔍 GPS PAN Verification Debug: Cubit closed after API call');
        return;
      }

      if (result is Success<GpsPanVerificationResponse>) {
        final response = result.value;
        print('🔍 GPS PAN Verification Debug: Success response: $response');
        print('🔍 GPS PAN Verification Debug: Response JSON: ${response.toJson()}');
        print('🔍 GPS PAN Verification Debug: Setting isPanVerified to ${response.isVerified}');
        emit(state.copyWith(isPanVerified: response.isVerified));
        _setPanVerificationUIState(UIState.success(response));
      } else if (result is Error) {
        print('❌ GPS PAN Verification failed: ${(result as Error).type}');
        _setPanVerificationUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      print('💥 GPS PAN Verification exception: $e');
      if (!_isClosed) {
        _setPanVerificationUIState(UIState.error(GenericError()));
      }
    }
  }

  // ==================== Document Upload Logic ====================

  void updatePanDocuments(List<Map<String, dynamic>> documents) {
    if (!_isClosed) {
      emit(state.copyWith(panDocuments: documents));
    }
  }

  void _setUploadKycUIState(UIState<GpsDocumentUploadResponse> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(uploadKycState: uiState));
    }
  }

  Future<void> uploadKycDocumentsMultipart() async {
    print('🔍 GPS uploadKycDocumentsMultipart called, cubit closed: $_isClosed');
    if (_isClosed) {
      print('🔍 GPS Cubit is closed, returning early');
      return;
    }

    // Get customer ID
    final userRepository = locator<UserInformationRepository>();
    final customerId = await userRepository.getUserID();
    
    if (customerId == null || customerId.isEmpty) {
      print('🔍 GPS Customer ID is null or empty, returning early');
      _setUploadKycUIState(UIState.error(ErrorWithMessage(message: 'Unable to get customer ID')));
      return;
    }
    
    print('🔍 GPS Customer ID: $customerId');

    // Validate required fields
    if (state.aadhaar.isEmpty) {
      print('🔍 GPS Aadhaar is empty, returning early');
      return;
    }

    if (!state.isAadhaarVerified) {
      print('🔍 GPS Aadhaar is not verified, returning early');
      return;
    }

    print('🔍 GPS Setting upload KYC UI state to loading...');
    _setUploadKycUIState(UIState.loading());

    try {
      // Get PAN document file
      File? panImageFile;
      if (state.panDocuments.isNotEmpty) {
        final document = state.panDocuments.first;
        if (document['path'] != null) {
          panImageFile = File(document['path']);
          print('🔍 GPS PAN document: ${panImageFile?.path}');
        }
      }

      // Use the same PAN image for all document fields
      File? addressProofFrontFile = panImageFile;
      File? addressProofBackFile = panImageFile;
      File? identityProofFrontFile = panImageFile;
      File? identityProofBackFile = panImageFile;

      print('🔍 GPS Using PAN image for all document fields:');
      print('  - PAN Image: ${panImageFile?.path}');
      print('  - Address Proof Front: ${addressProofFrontFile?.path}');
      print('  - Address Proof Back: ${addressProofBackFile?.path}');
      print('  - Identity Proof Front: ${identityProofFrontFile?.path}');
      print('  - Identity Proof Back: ${identityProofBackFile?.path}');

      final request = GpsDocumentUploadMultipartApiRequest(
        aadhar: state.aadhaar,
        pan: state.pan.isNotEmpty ? state.pan : null,
        panImage: panImageFile,
        addressProofFront: addressProofFrontFile,
        addressProofBack: addressProofBackFile,
        identityProofFront: identityProofFrontFile,
        identityProofBack: identityProofBackFile,
        customerId: customerId,
      );

      print('🔍 GPS Upload request debug:');
      print('  - Aadhar: ${request.aadhar}');
      print('  - PAN: ${request.pan}');
      print('  - PanImage: ${request.panImage?.path}');
      print('  - AddressProofFront: ${request.addressProofFront?.path}');
      print('  - AddressProofBack: ${request.addressProofBack?.path}');
      print('  - IdentityProofFront: ${request.identityProofFront?.path}');
      print('  - IdentityProofBack: ${request.identityProofBack?.path}');
      print('  - Form fields: ${request.getFormFields()}');
      print('  - Files: ${request.getFiles().keys.toList()}');

      final result = await _repository.uploadGpsDocumentsMultipart(request);

      if (_isClosed) {
        print('🔍 GPS Cubit is closed after API call, returning early');
        return;
      }

      if (result is Success<GpsDocumentUploadResponse>) {
        final response = result.value;
        print('🔍 GPS KYC documents uploaded successfully');
        _setUploadKycUIState(UIState.success(response));
      } else if (result is Error) {
        print('❌ GPS KYC documents upload failed: ${(result as Error).type}');
        _setUploadKycUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      print('💥 GPS KYC documents upload exception: $e');
      if (!_isClosed) {
        _setUploadKycUIState(UIState.error(GenericError()));
      }
    }
  }

  // ==================== Form Management ====================

  void markFormSubmitted() {
    print('🔍 GPS markFormSubmitted called');
    if (!_isClosed) {
      emit(state.copyWith(hasAttemptedSubmit: true));
      print('🔍 GPS Form submission marked');
    } else {
      print('🔍 GPS Cubit is closed, cannot mark form submitted');
    }
  }

  // ==================== Reset Methods ====================

  /// Reset all state
  void resetState() {
    if (!_isClosed) {
      print('🔍 GPS Resetting all state');
      emit(GpsUploadDocumentState.initial());
    } else {
      print('🔍 GPS Cubit is closed, cannot reset state');
    }
  }

  /// Reset only verification states
  void resetVerificationStates() {
    if (!_isClosed) {
      print('🔍 GPS Resetting verification states');
      emit(state.copyWith(
        isAadhaarVerified: false,
        isPanVerified: false,
        aadhaarRequestId: null,
        aadhaarSendOtpState: UIState.initial(),
        aadhaarVerifyOtpState: UIState.initial(),
        panVerificationState: UIState.initial(),
      ));
    } else {
      print('🔍 GPS Cubit is closed, cannot reset verification states');
    }
  }
} 