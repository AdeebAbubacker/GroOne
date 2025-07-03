import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/en-dhan_fuel/api_request/en-dhan_api_request.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_kyc_model.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/document_upload_response.dart';
import 'package:gro_one_app/features/en-dhan_fuel/repository/en-dhan_repository.dart';

import 'en_dhan_kyc_state.dart';



class EnDhanKycCubit extends Cubit<EnDhanKycState> {
  final EnDhanRepository _repository;
  
  EnDhanKycCubit(this._repository) : super(EnDhanKycState.initial());

  // ==================== KYC Check ====================
  
  /// Check if KYC documents exist for the customer
  Future<void> checkKycDocuments() async {
    print('🔍 Starting KYC documents check...');
    emit(state.copyWith(kycCheckState: UIState.loading()));
    
    try {
      final result = await _repository.checkKycDocuments();
      
      if (result is Success<EnDhanKycCheckModel>) {
        final kycModel = result.value;
        final hasDocuments = kycModel.hasKycDocuments;
        
        print('📋 KYC Check Response:');
        print('  Success: ${kycModel.success}');
        print('  Message: ${kycModel.message}');
        print('  Data Type: ${kycModel.data.runtimeType}');
        print('  Data: ${kycModel.data}');
        print('  Has Documents: $hasDocuments');
        print('  KYC Data: ${kycModel.kycData}');
        
        emit(state.copyWith(
          hasKycDocuments: hasDocuments,
          kycData: kycModel.kycData,
          kycCheckState: UIState.success(kycModel),
        ));
      } else if (result is Error) {
        print('❌ KYC Check failed: ${(result as Error).type}');
        emit(state.copyWith(kycCheckState: UIState.error((result as Error).type)));
      }
    } catch (e) {
      print('💥 KYC Check exception: $e');
      emit(state.copyWith(kycCheckState: UIState.error(GenericError())));
    }
  }

  // ==================== KYC Document Upload ====================
  
  /// Mark that form submission has been attempted
  void markFormSubmitted() {
    emit(state.copyWith(hasAttemptedSubmit: true));
  }
  
  /// Uploads KYC documents using multipart to En-Dhan API
  Future<void> uploadKycDocumentsMultipart() async {
    // Mark that form submission has been attempted
    markFormSubmitted();
    
    if (!isFormValid()) {
      emit(state.copyWith(uploadKycState: UIState.error(InvalidInputError())));
      return;
    }

    emit(state.copyWith(uploadKycState: UIState.loading()));
    
    // Convert file paths to File objects from document lists
    File? addressProofFrontFile;
    File? addressProofBackFile;
    File? identityProofFrontFile;
    File? identityProofBackFile;
    File? panImageFile;
    
    // Extract file paths from document lists
    if (state.addressFrontDocuments.isNotEmpty) {
      final document = state.addressFrontDocuments.first;
      if (document['path'] != null) {
        addressProofFrontFile = File(document['path']);
      }
    }
    
    if (state.addressBackDocuments.isNotEmpty) {
      final document = state.addressBackDocuments.first;
      if (document['path'] != null) {
        addressProofBackFile = File(document['path']);
      }
    }
    
    if (state.identityFrontDocuments.isNotEmpty) {
      final document = state.identityFrontDocuments.first;
      if (document['path'] != null) {
        identityProofFrontFile = File(document['path']);
      }
    }
    
    if (state.identityBackDocuments.isNotEmpty) {
      final document = state.identityBackDocuments.first;
      if (document['path'] != null) {
        identityProofBackFile = File(document['path']);
      }
    }
    
    if (state.panDocuments.isNotEmpty) {
      final document = state.panDocuments.first;
      if (document['path'] != null) {
        panImageFile = File(document['path']);
      }
    }

    final request = EnDhanKycMultipartApiRequest(
      aadhar: state.aadhaar,
      pan: state.pan,
      addressProofFront: addressProofFrontFile,
      addressProofBack: addressProofBackFile,
      identityProofFront: identityProofFrontFile,
      identityProofBack: identityProofBackFile,
      panImage: panImageFile,
    );

    final result = await _repository.uploadKycDocumentsMultipart(request);
    
    if (result is Success<EnDhanKycModel>) {
      emit(state.copyWith(uploadKycState: UIState.success(result.value)));
    } else if (result is Error<EnDhanKycModel>) {
      emit(state.copyWith(uploadKycState: UIState.error(result.type)));
    }
  }

  // ==================== Aadhaar Verification ====================

  /// Send Aadhaar OTP
  Future<void> sendAadhaarOtp() async {
    if (state.aadhaar.isEmpty) {
      return;
    }
    
    emit(state.copyWith(aadhaarSendOtpState: UIState.loading()));
    
    // For now, use static OTP "123456" instead of calling API
    // TODO: Replace with actual API call later
    await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay
    
    // Create a mock success response
    final mockResponse = AadhaarSendOtpResponse(
      success: true,
      message: 'OTP sent successfully',
      requestId: 'static_request_id_123',
    );
    
    emit(state.copyWith(
      aadhaarRequestId: mockResponse.requestId,
      aadhaarSendOtpState: UIState.success(mockResponse),
    ));
  }

  /// Verify Aadhaar OTP
  Future<void> verifyAadhaarOtp(String otp) async {
    if (state.aadhaarRequestId == null || state.aadhaar.isEmpty) {
      return;
    }
    
    emit(state.copyWith(aadhaarVerifyOtpState: UIState.loading()));
    
    // For now, use static OTP "123456" instead of calling API
    // TODO: Replace with actual API call later
    await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay
    
    // Check if OTP matches static value "123456"
    if (otp == '123456') {
      final mockResponse = AadhaarVerifyOtpResponse(
        success: true,
        message: 'Aadhaar verified successfully',
        isVerified: true,
      );
      
      emit(state.copyWith(
        isAadhaarVerified: true,
        aadhaarVerifyOtpState: UIState.success(mockResponse),
      ));
    } else {
      final mockResponse = AadhaarVerifyOtpResponse(
        success: false,
        message: 'Invalid OTP. Please use 123456',
        isVerified: false,
      );
      
      emit(state.copyWith(
        aadhaarVerifyOtpState: UIState.error(ErrorWithMessage(message: 'Invalid OTP. Please use 123456')),
      ));
    }
  }

  // ==================== PAN Verification ====================

  /// Verify PAN
  Future<void> verifyPan() async {
    print('🔍 PAN Verification Debug: Starting verification...');
    
    if (state.pan.isEmpty) {
      print('🔍 PAN Verification Debug: PAN is empty, returning');
      return;
    }
    
    print('🔍 PAN Verification Debug: PAN to verify: "${state.pan}"');
    emit(state.copyWith(panVerificationState: UIState.loading()));
    
    // For now, use mock response that always returns success
    // TODO: Replace with actual API call later
    await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay
    
    // Create a mock success response with isVerified: true
    final mockResponse = PanVerificationResponse(
      success: true,
      message: 'PAN verified successfully',
      isVerified: true,
    );
    
    print('🔍 PAN Verification Debug: Mock success response: $mockResponse');
    print('🔍 PAN Verification Debug: Setting isPanVerified to true');
    
    emit(state.copyWith(
      isPanVerified: true,
      panVerificationState: UIState.success(mockResponse),
    ));
  }

  // ==================== Form Field Updates ====================
  
  // Set Aadhaar number
  void setAadhaar(String value) {
    print('🔍 setAadhaar called with: "$value"');
    final newState = state.copyWith(aadhaar: value);
    emit(newState);
    print('🔍 Aadhaar state updated to: "${newState.aadhaar}"');
  }

  // Set PAN number
  void setPan(String value) {
    emit(state.copyWith(pan: value));
  }

  // ==================== Validation Methods ====================
  
  // Validate Aadhaar number
  void validateAadhaar(String value) {
    print('🔍 validateAadhaar called with: "$value"');
    final isValid = _validateAadhaar(value) == null;
    print('🔍 Aadhaar Validation Debug:');
    print('  - Input value: "$value"');
    print('  - Validation result: $isValid');
    print('  - Error message: ${_validateAadhaar(value)}');
    emit(state.copyWith(isAadhaarValid: isValid));
    print('🔍 isAadhaarValid updated to: $isValid');
  }

  // Validate PAN number
  void validatePan(String value) {
    final isValid = _validatePan(value) == null;
    print('🔍 PAN Validation Debug:');
    print('  - Input value: "$value"');
    print('  - Length: ${value.length}');
    print('  - Validation result: $isValid');
    print('  - Error message: ${_validatePan(value)}');
    print('  - Current isPanVerified: ${state.isPanVerified}');
    
    emit(state.copyWith(isPanValid: isValid));
    
    // Auto-verify PAN when input is valid and complete (10 characters)
    if (isValid && value.length == 10 && !state.isPanVerified) {
      print('🔍 PAN Auto-verification triggered!');
      // Add a small delay to avoid too many API calls
      Future.delayed(Duration(milliseconds: 500), () {
        if (state.pan == value) {
          print('🔍 PAN Auto-verification executing...');
          verifyPan();
        } else {
          print('🔍 PAN Auto-verification skipped - PAN changed');
        }
      });
    } else {
      print('🔍 PAN Auto-verification conditions not met:');
      print('  - isValid: $isValid');
      print('  - length == 10: ${value.length == 10}');
      print('  - !isPanVerified: ${!state.isPanVerified}');
    }
  }

  // Get Aadhaar validation error (only if form has been submitted)
  String? getAadhaarValidationError(String value) {
    if (!state.hasAttemptedSubmit) return null;
    return _validateAadhaar(value);
  }

  // Get PAN validation error (only if form has been submitted)
  String? getPanValidationError(String value) {
    if (!state.hasAttemptedSubmit) return null;
    return _validatePan(value);
  }

  // Set PAN image uploaded flag
  void setPanImageUploaded(bool value) {
    emit(state.copyWith(isPanImageUploaded: value));
  }

  // Set identity front uploaded flag
  void setIdentityFrontUploaded(bool value) {
    emit(state.copyWith(isIdentityFrontUploaded: value));
  }

  // Set identity back uploaded flag
  void setIdentityBackUploaded(bool value) {
    emit(state.copyWith(isIdentityBackUploaded: value));
  }

  // Set address front uploaded flag
  void setAddressFrontUploaded(bool value) {
    emit(state.copyWith(isAddressFrontUploaded: value));
  }

  // Set address back uploaded flag
  void setAddressBackUploaded(bool value) {
    emit(state.copyWith(isAddressBackUploaded: value));
  }

  // Update PAN documents list
  void updatePanDocuments(List documents) {
    emit(state.copyWith(panDocuments: List.from(documents)));
  }

  // Update identity front documents list
  void updateIdentityFrontDocuments(List documents) {
    emit(state.copyWith(identityFrontDocuments: List.from(documents)));
  }

  // Update identity back documents list
  void updateIdentityBackDocuments(List documents) {
    emit(state.copyWith(identityBackDocuments: List.from(documents)));
  }

  // Update address front documents list
  void updateAddressFrontDocuments(List documents) {
    emit(state.copyWith(addressFrontDocuments: List.from(documents)));
  }

  // Update address back documents list
  void updateAddressBackDocuments(List documents) {
    emit(state.copyWith(addressBackDocuments: List.from(documents)));
  }

  // ==================== Private Validation Methods ====================
  
  // Private Aadhaar validation method
  String? _validateAadhaar(String value) {
    if (value.isEmpty) {
      return 'Aadhaar number is required';
    }
    
    // Remove spaces and special characters
    String cleanAadhaar = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanAadhaar.length != 12) {
      return 'Aadhaar number must be 12 digits';
    }
    
    // For testing, accept any 12-digit number
    // TODO: Re-enable strict validation later
    /*
    // Check if all digits are not same
    if (RegExp(r'^(\d)\1{11}$').hasMatch(cleanAadhaar)) {
      return 'Invalid Aadhaar number';
    }
    
    // Check if it starts with 0 or 1
    if (cleanAadhaar.startsWith('0') || cleanAadhaar.startsWith('1')) {
      return 'Invalid Aadhaar number';
    }
    */
    
    return null;
  }

  // Private PAN validation method
  String? _validatePan(String value) {
    if (value.isEmpty) {
      return 'PAN number is required';
    }
    
    // Remove spaces and convert to uppercase
    String cleanPan = value.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    
    // PAN format: ABCDE1234F (5 letters + 4 digits + 1 letter)
    RegExp panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    
    if (!panRegex.hasMatch(cleanPan)) {
      return 'Please enter valid PAN number (e.g., ABCDE1234F)';
    }
    
    return null;
  }

  // Check if form is valid
  bool isFormValid() {
    return state.isFormValid;
  }

  /// Reset all state
  void resetState() {
    emit(EnDhanKycState.initial());
  }
} 