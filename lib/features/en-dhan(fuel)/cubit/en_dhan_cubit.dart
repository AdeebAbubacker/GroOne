import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/api_request/en-dhan_api_request.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/model/en_dhan_kyc_model.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/repository/en-dhan_repository.dart';

part 'en_dhan_state.dart';

class EnDhanCubit extends BaseCubit<EnDhanState> {
  final EnDhanRepository _repository;
  
  EnDhanCubit(this._repository) : super(EnDhanState());

  // ==================== KYC Check ====================
  
  /// Check if KYC documents exist for the customer
  Future<void> checkKycDocuments(int customerId) async {
    _setKycCheckUIState(UIState.loading());
    
    try {
      final result = await _repository.checkKycDocuments(customerId);
      
      if (result is Success<EnDhanKycCheckModel>) {
        final hasDocuments = result.value.hasKycDocuments;
        emit(state.copyWith(
          hasKycDocuments: hasDocuments,
          kycData: result.value.kycData,
        ));
        _setKycCheckUIState(UIState.success(result.value));
      } else if (result is Error) {
        _setKycCheckUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      _setKycCheckUIState(UIState.error(GenericError()));
    }
  }

  // ==================== KYC Document Upload ====================
  
  /// Uploads KYC documents to En-Dhan API
  Future<void> uploadKycDocuments() async {
    if (!isFormValid()) {
      _setUploadKycUIState(UIState.error(InvalidInputError()));
      return;
    }

    _setUploadKycUIState(UIState.loading());
    
    final request = EnDhanKycApiRequest(
      customerId: state.customerId,
      aadhar: state.aadhaar,
      pan: state.pan,
      addressProofFront: state.addressProofFront,
      addressProofBack: state.addressProofBack,
      identityProofFront: state.identityProofFront,
      identityProofBack: state.identityProofBack,
      panImage: state.panImage,
    );

    Result result = await _repository.uploadKycDocuments(request);
    
    if (result is Success<EnDhanKycModel>) {
      _setUploadKycUIState(UIState.success(result.value));
    } else if (result is Error) {
      _setUploadKycUIState(UIState.error(result.type));
    }
  }

  // ==================== Form Field Updates ====================
  
  // Set Aadhaar number
  void setAadhaar(String value) {
    emit(state.copyWith(aadhaar: value));
  }

  // Set PAN number
  void setPan(String value) {
    emit(state.copyWith(pan: value));
  }

  // Set address proof front
  void setAddressProofFront(String value) {
    emit(state.copyWith(addressProofFront: value));
  }

  // Set address proof back
  void setAddressProofBack(String value) {
    emit(state.copyWith(addressProofBack: value));
  }

  // Set identity proof front
  void setIdentityProofFront(String value) {
    emit(state.copyWith(identityProofFront: value));
  }

  // Set identity proof back
  void setIdentityProofBack(String value) {
    emit(state.copyWith(identityProofBack: value));
  }

  // Set PAN image
  void setPanImage(String value) {
    emit(state.copyWith(panImage: value));
  }

  // Set customer ID
  void setCustomerId(int? value) {
    emit(state.copyWith(customerId: value));
  }

  // Check if form is valid
  bool isFormValid() {
    return state.aadhaar.isNotEmpty &&
           state.pan.isNotEmpty &&
           state.addressProofFront.isNotEmpty &&
           state.addressProofBack.isNotEmpty &&
           state.identityProofFront.isNotEmpty &&
           state.identityProofBack.isNotEmpty &&
           state.panImage.isNotEmpty;
  }

  // ==================== Private UI State Setters ====================
  
  /// Sets the KYC check UI state
  void _setKycCheckUIState(UIState<EnDhanKycCheckModel>? uiState) {
    emit(state.copyWith(kycCheckState: uiState));
  }

  /// Sets the upload KYC UI state
  void _setUploadKycUIState(UIState<EnDhanKycModel>? uiState) {
    emit(state.copyWith(uploadKycState: uiState));
  }

  // ==================== Reset Methods ====================
  
  /// Resets the KYC check UI state
  void resetKycCheckUIState() {
    emit(state.copyWith(
      kycCheckState: resetUIState<EnDhanKycCheckModel>(state.kycCheckState),
    ));
  }

  /// Resets the upload KYC UI state
  void resetUploadKycUIState() {
    emit(state.copyWith(
      uploadKycState: resetUIState<EnDhanKycModel>(state.uploadKycState),
    ));
  }

  /// Resets all state
  void resetState() {
    emit(state.copyWith(
      uploadKycState: resetUIState<EnDhanKycModel>(state.uploadKycState),
      kycCheckState: resetUIState<EnDhanKycCheckModel>(state.kycCheckState),
      aadhaar: '',
      pan: '',
      addressProofFront: '',
      addressProofBack: '',
      identityProofFront: '',
      identityProofBack: '',
      panImage: '',
      customerId: null,
      hasKycDocuments: false,
      kycData: null,
    ));
  }
} 