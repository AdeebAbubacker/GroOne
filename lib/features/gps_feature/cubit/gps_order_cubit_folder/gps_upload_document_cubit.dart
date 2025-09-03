import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/data/network/api_service.dart';

import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'gps_upload_document_state.dart';



class GpsUploadDocumentCubit extends Cubit<GpsUploadDocumentState> {
  final GpsOrderApiRepository _repository;
  bool _isClosed = false;

  GpsUploadDocumentCubit(this._repository) : super(GpsUploadDocumentState.initial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(GpsUploadDocumentState.initial());
  }


  // ==================== Aadhaar Logic ====================

  void setAadhaar(String value) {
    if (!_isClosed) {
      emit(state.copyWith(aadhaar: value));
    }
  }

  void validateAadhaar(String value) {
    final isValid = _validateAadhaar(value) == null;

    if (!_isClosed) {
      emit(state.copyWith(isAadhaarValid: isValid));
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
    if (_isClosed) {
      return;
    }

    if (state.aadhaar.isEmpty) {
      return;
    }

    // Aadhaar OTP doesn't require authentication
    _setAadhaarSendOtpUIState(UIState.loading());

    try {
      final request = GpsAadhaarSendOtpRequest(
        aadhaar: state.aadhaar,
        force: true,
      );

      final result = await _repository.sendAadhaarOtp(request);

      if (_isClosed) {
        return;
      }

      if (result is Success<GpsAadhaarSendOtpResponse>) {
        final response = result.value;
        // Use actual request ID from API response, fallback to static if not provided
        final requestId = response.requestId?.isNotEmpty == true ? response.requestId! : 'static_request_id_123';
        emit(state.copyWith(aadhaarRequestId: requestId));
        _setAadhaarSendOtpUIState(UIState.success(response));
      } else if (result is Error) {
        _setAadhaarSendOtpUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      if (!_isClosed) {
        _setAadhaarSendOtpUIState(UIState.error(GenericError()));
      }
    }
  }

  Future<void> verifyAadhaarOtp(String otp) async {
    if (_isClosed) {
      return;
    }

    if (state.aadhaarRequestId == null || state.aadhaar.isEmpty) {
      return;
    }

    // Aadhaar OTP verification doesn't require authentication
    _setAadhaarVerifyOtpUIState(UIState.loading());

    try {
      final request = GpsAadhaarVerifyOtpRequest(
        requestId: state.aadhaarRequestId!,
        otp: otp,
        aadhaar: state.aadhaar,
      );
      final result = await _repository.verifyAadhaarOtp(request);

      if (_isClosed) {
        return;
      }

      if (result is Success<GpsAadhaarVerifyOtpResponse>) {
        final response = result.value;

        emit(state.copyWith(isAadhaarVerified: response.isVerified));
        _setAadhaarVerifyOtpUIState(UIState.success(response));
      } else if (result is Error) {
        _setAadhaarVerifyOtpUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      if (!_isClosed) {
        _setAadhaarVerifyOtpUIState(UIState.error(GenericError()));
      }
    }
  }

  // ==================== PAN Logic ====================

  void setPan(String value) {
    if (!_isClosed) {
      emit(state.copyWith(pan: value));
    }
  }

  void validatePan(String value) {
    final isValid = _validatePan(value) == null;

    if (!_isClosed) {
      emit(state.copyWith(isPanValid: isValid));

      // Auto-verify PAN when input is valid and complete (10 characters) and not empty
      if (isValid && value.isNotEmpty && value.length == 10 && !state.isPanVerified) {
        // Add a small delay to avoid too many API calls
        Future.delayed(Duration(milliseconds: 500), () {
          if (!_isClosed && state.pan == value) {
            verifyPan();
          }
        });
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
    RegExp panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
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
    if (_isClosed) {
      return;
    }

    if (state.pan.isEmpty) {
      emit(state.copyWith(isPanVerified: true));
      return;
    }

    // PAN verification doesn't require authentication

    _setPanVerificationUIState(UIState.loading());

    try {
      final userRepository = locator<UserInformationRepository>();
      final userName = await userRepository.getUsername();
      String customerName = "Test User";
      final profileCubit = locator<ProfileCubit>();

      if (userName == null || userName.isEmpty) {
        await profileCubit.fetchProfileDetail();
        final profileState = profileCubit.state;

        if (profileState.profileDetailUIState?.data?.customer != null) {
          final customer = profileState.profileDetailUIState!.data!.customer!;
          customerName = customer.customerName;
        }
      }


      final request = GpsPanVerificationRequest(
        panNumber: state.pan,
        name: customerName,
      );

      final result = await _repository.verifyPan(request);

      if (_isClosed) {
        return;
      }

      if (result is Success<GpsPanVerificationResponse>) {
        final response = result.value;
        emit(state.copyWith(isPanVerified: response.isVerified));
        _setPanVerificationUIState(UIState.success(response));
      } else if (result is Error) {
        _setPanVerificationUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
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

  void _setUploadKycUIState(UIState<GpsKycUploadResponseModel> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(uploadKycState: uiState));
    }
  }

  Future<void> uploadAadhaarPdfFile(File file) async {
    if (_isClosed) return;

    // Get customer ID
    final userRepository = locator<UserInformationRepository>();
    final customerId = await userRepository.getUserID();

    if (customerId == null || customerId.isEmpty) {
      _setUploadKycUIState(UIState.error(ErrorWithMessage(message: 'Unable to get customer ID')));
      return;
    }

    final apiService = locator<ApiService>();

    final result = await apiService.multipart(
      ApiUrls.documentUpload,
      file,
      fields: {
        'userId': customerId,
        'fileType': 'aadhar_document',
        'documentType': 'kyc_document',
      },
      pathName: 'file',
    );

    if (_isClosed) return;

    if (result is Success) {
      final data = result.value;
      if (data is Map<String, dynamic> && data['url'] != null) {
        final link = data['url'] as String;
        emit(state.copyWith(aadhaarDocLink: link));
      }
    }
  }


  Future<void> uploadKycDocuments() async {
    if (_isClosed) {
      return;
    }

    // Get customer ID
    final userRepository = locator<UserInformationRepository>();
    final customerId = await userRepository.getUserID();
    
    if (customerId == null || customerId.isEmpty) {
      _setUploadKycUIState(UIState.error(ErrorWithMessage(message: 'Unable to get customer ID')));
      return;
    }

    // Validate required fields
    if (state.aadhaar.isEmpty) {
      return;
    }

    if (!state.isAadhaarVerified) {
      return;
    }
    _setUploadKycUIState(UIState.loading());

    try {
      String? panDocLink;
      
      // Upload PAN document if provided
      if (state.panDocuments.isNotEmpty && state.pan.isNotEmpty) {
        final document = state.panDocuments.first;
        if (document['path'] != null) {
          final panImageFile = File(document['path']);
          
          // Upload the PAN document first to get the URL
          final uploadResult = await _uploadDocument(panImageFile, customerId);
          if (uploadResult is Success<String>) {
            panDocLink = uploadResult.value;
          } else {
            _setUploadKycUIState(UIState.error(ErrorWithMessage(message: 'Failed to upload PAN document')));
            return;
          }
        }
      }

      // Create KYC upload request
      final request = GpsKycUploadRequest(
        aadhar: state.aadhaar,
        isAadhar: true,
        pan: state.pan.isNotEmpty ? state.pan : null,
        panDocLink: panDocLink,
        isPan: state.pan.isNotEmpty ? true : null,
        aadharDocLink: state.aadhaarDocLink,
        fromFleet: true
      );

      final result = await _repository.uploadKycDocuments(request, customerId);

      if (_isClosed) {
        return;
      }

      if (result is Success<GpsKycUploadResponseModel>) {
        final response = result.value;
        _setUploadKycUIState(UIState.success(response));
      } else if (result is Error) {
        _setUploadKycUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      if (!_isClosed) {
        _setUploadKycUIState(UIState.error(GenericError()));
      }
    }
  }

  /// Upload a single document and return the URL
  Future<Result<String>> _uploadDocument(File file, String customerId) async {
    try {
      final apiService = locator<ApiService>();
      final result = await apiService.multipart(
        ApiUrls.documentUpload,
        file,
        fields: {
          'userId': customerId,
          'fileType': 'pan_document',
          'documentType': 'kyc_document',
        },
        pathName: 'file',
      );

      if (result is Success) {
        final responseData = result.value;
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('url')) {
            return Success(responseData['url']);
          }
        }
        return Error(ErrorWithMessage(message: 'Invalid upload response format'));
      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      return Error(GenericError());
    }
  }

  // ==================== Form Management ====================

  void markFormSubmitted() {
    if (!_isClosed) {
      emit(state.copyWith(hasAttemptedSubmit: true));
    } else {
    }
  }

  // ==================== Reset Methods ====================

  /// Reset all state
  void resetState() {
    if (!_isClosed) {
      emit(GpsUploadDocumentState.initial());
    }
  }

  /// Reset only verification states
  void resetVerificationStates() {
    if (!_isClosed) {
      emit(state.copyWith(
        isAadhaarVerified: false,
        isPanVerified: false,
        aadhaarRequestId: null,
        aadhaarSendOtpState: UIState.initial(),
        aadhaarVerifyOtpState: UIState.initial(),
        panVerificationState: UIState.initial(),
      ));
    }
  }

  void markAadhaarVerified() {
    emit(state.copyWith(isAadhaarVerified: true));
  }
} 