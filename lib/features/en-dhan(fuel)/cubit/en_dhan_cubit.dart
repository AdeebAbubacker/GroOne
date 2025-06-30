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
  Future<void> checkKycDocuments() async {
    _setKycCheckUIState(UIState.loading());
    
    try {
      final result = await _repository.checkKycDocuments();
      
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

  // ==================== Card Creation Form Field Updates ====================
  
  // Set customer name
  void setCustomerName(String value) {
    emit(state.copyWith(customerName: value));
  }

  // Set mobile number
  void setMobile(String value) {
    emit(state.copyWith(mobile: value));
  }

  // Set address line 1
  void setAddress1(String value) {
    emit(state.copyWith(address1: value));
  }

  // Set address line 2
  void setAddress2(String value) {
    emit(state.copyWith(address2: value));
  }

  // Set pincode
  void setPincode(String value) {
    emit(state.copyWith(pincode: value));
  }

  // Set shipping address
  void setShippingAddress(String value) {
    emit(state.copyWith(shippingAddress: value));
  }

  // Set save as shipping checkbox
  void setSaveAsShipping(bool value) {
    emit(state.copyWith(saveAsShipping: value));
  }

  // Set regional office
  void setRegionalOffice(String value) {
    emit(state.copyWith(regionalOffice: value));
  }

  // Set RO address line 1
  void setRoAddress1(String value) {
    emit(state.copyWith(roAddress1: value));
  }

  // Set RO address line 2
  void setRoAddress2(String value) {
    emit(state.copyWith(roAddress2: value));
  }

  // Set RO state
  void setRoState(String value) {
    emit(state.copyWith(roState: value));
  }

  // Set RO district
  void setRoDistrict(String value) {
    emit(state.copyWith(roDistrict: value));
  }

  // Add a new card
  void addCard() {
    final newCards = List<CardFormData>.from(state.cards)..add(const CardFormData());
    emit(state.copyWith(cards: newCards));
  }

  // Remove a card at specific index
  void removeCard(int index) {
    if (state.cards.length > 1) {
      final newCards = List<CardFormData>.from(state.cards)..removeAt(index);
      emit(state.copyWith(cards: newCards));
    }
  }

  // Update card data at specific index
  void updateCard(int index, CardFormData cardData) {
    final newCards = List<CardFormData>.from(state.cards);
    if (index < newCards.length) {
      newCards[index] = cardData;
      emit(state.copyWith(cards: newCards));
    }
  }

  // Update specific card field
  void updateCardField(int cardIndex, {
    String? vehicleNumber,
    String? vehicleType,
    String? vinNumber,
    String? mobile,
    List<Map<String, dynamic>>? rcDocuments,
  }) {
    if (cardIndex < state.cards.length) {
      final currentCard = state.cards[cardIndex];
      final updatedCard = currentCard.copyWith(
        vehicleNumber: vehicleNumber,
        vehicleType: vehicleType,
        vinNumber: vinNumber,
        mobile: mobile,
        rcDocuments: rcDocuments,
      );
      updateCard(cardIndex, updatedCard);
    }
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

  // Check if card creation form is valid
  bool isCardCreationFormValid() {
    // Check billing address fields
    if (state.customerName.isEmpty || 
        state.mobile.isEmpty || 
        state.address1.isEmpty || 
        state.pincode.isEmpty) {
      return false;
    }

    // Check if shipping address is required and filled
    if (!state.saveAsShipping && state.shippingAddress.isEmpty) {
      return false;
    }

    // Check all cards have required fields
    for (final card in state.cards) {
      if (card.vehicleNumber.isEmpty || 
          card.vehicleType == null || 
          card.vehicleType == 'Select' ||
          card.vinNumber.isEmpty || 
          card.mobile.isEmpty) {
        return false;
      }
    }

    return true;
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
      customerName: '',
      mobile: '',
      address1: '',
      address2: '',
      pincode: '',
      shippingAddress: '',
      saveAsShipping: true,
      regionalOffice: 'Chennai',
      roAddress1: '',
      roAddress2: '',
      roState: '',
      roDistrict: '',
      cards: const [CardFormData()],
    ));
  }
} 