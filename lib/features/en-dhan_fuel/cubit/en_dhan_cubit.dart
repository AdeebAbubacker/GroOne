import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/en-dhan_fuel/api_request/en-dhan_api_request.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/document_upload_response.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_kyc_model.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_models.dart'
    as api_models;
import 'package:gro_one_app/features/en-dhan_fuel/repository/en-dhan_repository.dart';

part 'en_dhan_state.dart';

class EnDhanCubit extends BaseCubit<EnDhanState> {
  final EnDhanRepository _repository;
  bool _isClosed = false;

  EnDhanCubit(this._repository) : super(EnDhanState.initial());

  @override
  Future<void> close() {
    print('🔒 EnDhanCubit.close() called');
    print('🔒 Stack trace: ${StackTrace.current}');
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    print('🔄 Resetting EnDhanCubit state');
    _isClosed = false;
    emit(EnDhanState.initial());
  }

  /// Debug method to check cubit status
  void debugCubitStatus() {
    print('🔍 Cubit Status:');
    print('  Is Closed: $_isClosed');
    print('  State: ${state.runtimeType}');
    print('  KYC Check State: ${state.kycCheckState?.status}');
    print('  Cards State: ${state.cardsState?.status}');
  }

  // ==================== KYC Check ====================

  /// Check if KYC documents exist for the customer
  Future<void> checkKycDocuments() async {
    print('🔍 EnDhanCubit.checkKycDocuments called');
    print('🔍 Cubit closed status: $_isClosed');

    if (_isClosed) return;

    print('🔍 Starting KYC documents check...');
    _setKycCheckUIState(UIState.loading());

    try {
      final result = await _repository.checkKycDocuments();

      if (_isClosed) return; // Check again after async operation

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

        emit(
          state.copyWith(
            hasKycDocuments: hasDocuments,
            kycData: kycModel.kycData,
          ),
        );
        _setKycCheckUIState(UIState.success(kycModel));
      } else if (result is Error) {
        print('❌ KYC Check failed: ${(result as Error).type}');
        _setKycCheckUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      print('💥 KYC Check exception: $e');
      if (!_isClosed) {
        _setKycCheckUIState(UIState.error(GenericError()));
      }
    }
  }

  // ==================== KYC Document Upload ====================

  /// Mark that form submission has been attempted
  void markFormSubmitted() {
    emit(state.copyWith(hasAttemptedSubmit: true));
  }

  /// Uploads KYC documents to En-Dhan API
  Future<void> uploadKycDocuments() async {
    // Mark that form submission has been attempted
    markFormSubmitted();

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

  /// Uploads KYC documents using multipart to En-Dhan API
  Future<void> uploadKycDocumentsMultipart() async {
    if (_isClosed) return;

    // Mark that form submission has been attempted
    markFormSubmitted();

    if (!isFormValid()) {
      _setUploadKycUIState(UIState.error(InvalidInputError()));
      return;
    }

    _setUploadKycUIState(UIState.loading());

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

    if (_isClosed) return; // Check again after async operation

    if (result is Success<EnDhanKycModel>) {
      _setUploadKycUIState(UIState.success(result.value));
    } else if (result is Error<EnDhanKycModel>) {
      _setUploadKycUIState(UIState.error(result.type));
    }
  }

  /// Fetch Cards List
  Future<void> fetchCards({String? searchTerm}) async {
    print('🔄 EnDhanCubit.fetchCards called with searchTerm: $searchTerm');
    print('🔍 Cubit closed status: $_isClosed');

    if (_isClosed) {
      print('❌ Cubit is closed, returning early');
      return;
    }

    print('📊 Setting cards UI state to loading...');
    _setCardsUIState(UIState.loading());

    print('🌐 Calling repository.fetchCards...');
    final result = await _repository.fetchCards(searchTerm: searchTerm);

    if (_isClosed) {
      print('❌ Cubit is closed after async operation, returning early');
      return; // Check again after async operation
    }

    print('📥 Repository result type: ${result.runtimeType}');

    if (result is Success<api_models.EnDhanCardListModel>) {
      print(
        '✅ Cards fetch successful: ${result.value.data?.length ?? 0} cards',
      );
      _setCardsUIState(UIState.success(result.value));
    } else if (result is Error<api_models.EnDhanCardListModel>) {
      print('❌ Cards fetch failed: ${result.type}');
      _setCardsUIState(UIState.error(result.type));
    }
  }

  // ==================== Aadhaar Verification ====================

  /// Send Aadhaar OTP
  Future<void> sendAadhaarOtp() async {
    if (_isClosed) return;

    if (state.aadhaar.isEmpty) {
      return;
    }

    _setAadhaarSendOtpUIState(UIState.loading());

    // For now, use static OTP "123456" instead of calling API
    // TODO: Replace with actual API call later
    await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay

    if (_isClosed) return;

    // Create a mock success response
    final mockResponse = AadhaarSendOtpResponse(
      success: true,
      message: 'OTP sent successfully',
      requestId: 'static_request_id_123',
    );

    emit(state.copyWith(aadhaarRequestId: mockResponse.requestId));
    _setAadhaarSendOtpUIState(UIState.success(mockResponse));
  }

  /// Verify Aadhaar OTP
  Future<void> verifyAadhaarOtp(String otp) async {
    if (_isClosed) return;

    if (state.aadhaarRequestId == null || state.aadhaar.isEmpty) {
      return;
    }

    _setAadhaarVerifyOtpUIState(UIState.loading());

    // For now, use static OTP "123456" instead of calling API
    // TODO: Replace with actual API call later
    await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay

    if (_isClosed) return;

    // Check if OTP matches static value "123456"
    if (otp == '123456') {
      final mockResponse = AadhaarVerifyOtpResponse(
        success: true,
        message: 'Aadhaar verified successfully',
        isVerified: true,
      );

      emit(state.copyWith(isAadhaarVerified: true));
      _setAadhaarVerifyOtpUIState(UIState.success(mockResponse));
    } else {
      final mockResponse = AadhaarVerifyOtpResponse(
        success: false,
        message: 'Invalid OTP. Please use 123456',
        isVerified: false,
      );

      _setAadhaarVerifyOtpUIState(
        UIState.error(
          ErrorWithMessage(message: 'Invalid OTP. Please use 123456'),
        ),
      );
    }
  }

  /// Set Aadhaar Send OTP UI State
  void _setAadhaarSendOtpUIState(UIState<AadhaarSendOtpResponse> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(aadhaarSendOtpState: uiState));
    }
  }

  /// Set Aadhaar Verify OTP UI State
  void _setAadhaarVerifyOtpUIState(UIState<AadhaarVerifyOtpResponse> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(aadhaarVerifyOtpState: uiState));
    }
  }

  // ==================== PAN Verification ====================

  /// Verify PAN
  Future<void> verifyPan() async {
    print('🔍 PAN Verification Debug: Starting verification...');
    if (_isClosed) {
      print('🔍 PAN Verification Debug: Cubit is closed, returning');
      return;
    }

    if (state.pan.isEmpty) {
      print('🔍 PAN Verification Debug: PAN is empty, returning');
      return;
    }

    print('🔍 PAN Verification Debug: PAN to verify: "${state.pan}"');
    _setPanVerificationUIState(UIState.loading());

    // For now, use mock response that always returns success
    // TODO: Replace with actual API call later
    await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay

    if (_isClosed) {
      print('🔍 PAN Verification Debug: Cubit closed after API call');
      return;
    }

    // Create a mock success response with isVerified: true
    final mockResponse = PanVerificationResponse(
      success: true,
      message: 'PAN verified successfully',
      isVerified: true,
    );

    print('🔍 PAN Verification Debug: Mock success response: $mockResponse');
    print('🔍 PAN Verification Debug: Setting isPanVerified to true');

    emit(state.copyWith(isPanVerified: true));
    _setPanVerificationUIState(UIState.success(mockResponse));
  }

  /// Set PAN Verification UI State
  void _setPanVerificationUIState(UIState<PanVerificationResponse> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(panVerificationState: uiState));
    }
  }

  // ==================== Customer Creation ====================

  /// Create customer with card details
  Future<void> createCustomer() async {
    if (!isCardCreationFormValid()) {
      _setCustomerCreationUIState(UIState.error(InvalidInputError()));
      return;
    }

    _setCustomerCreationUIState(UIState.loading());

    // Debug: Log the current state of cards
    print('=== DEBUG: Creating customer with cards ===');
    print('Number of cards in state: ${state.cards.length}');
    for (int i = 0; i < state.cards.length; i++) {
      final card = state.cards[i];
      print('Card $i:');
      print('  Vehicle Number: ${card.vehicleNumber}');
      print('  Vehicle Type: ${card.vehicleType}');
      print('  VIN Number: ${card.vinNumber}');
      print('  Mobile: ${card.mobile}');
      print('  RC Number: ${card.rcNumber}');
      print('  RC Documents: ${card.rcDocuments}');
    }

    // Convert cards to API request format
    final cardDetails =
        state.cards
            .map(
              (card) => EnDhanCardDetailRequest(
                vechileNo: card.vehicleNumber,
                mobileNo: card.mobile,
                vehicleType: card.vehicleType ?? '',
                vinNumber: card.vinNumber,
                rcDocument:
                    card.rcDocuments.isNotEmpty
                        ? card.rcDocuments.first['fileName'] ?? ''
                        : '',
                rcNumber: card.rcNumber, // This should be the RC book number
              ),
            )
            .toList();

    print('=== DEBUG: API Request card details ===');
    print('Number of cards in API request: ${cardDetails.length}');
    for (int i = 0; i < cardDetails.length; i++) {
      final card = cardDetails[i];
      print('API Card $i:');
      print('  Vehicle No: ${card.vechileNo}');
      print('  Mobile No: ${card.mobileNo}');
      print('  Vehicle Type: ${card.vehicleType}');
      print('  VIN Number: ${card.vinNumber}');
      print('  RC Document: ${card.rcDocument}');
      print('  RC Number: ${card.rcNumber}');
    }

    final request = EnDhanCustomerCreationApiRequest(
      customerName: state.customerName,
      title:
          state.title.isNotEmpty
              ? state.title
              : 'Mr', // Use selected title or default
      zonalOffice: state.selectedZonalOfficeId ?? 0,
      regionalOffice: state.selectedRegionalOfficeId ?? 0,
      communicationAddress1: state.address1,
      communicationAddress2: state.address2,
      communicationCityName: state.cityName,
      communicationPincode: state.pincode,
      communicationStateId: state.selectedStateId ?? 0,
      communicationDistrictId: state.selectedDistrictId ?? 0,
      communicationMobileNo: state.mobile,
      communicationEmailid: state.email,
      incomeTaxPan: state.pan,
      objCardDetailsAl: cardDetails,
    );

    Result result = await _repository.createCustomer(request);

    if (result is Success<api_models.EnDhanCustomerCreationResponse>) {
      _setCustomerCreationUIState(UIState.success(result.value));
    } else if (result is Error) {
      _setCustomerCreationUIState(UIState.error(result.type));
    }
  }

  // ==================== Master Data Fetching ====================

  /// Fetch states
  Future<void> fetchStates() async {
    _setStatesUIState(UIState.loading());

    try {
      final result = await _repository.fetchStates();

      if (result is Success<api_models.EnDhanStateResponse>) {
        final states =
            result.value.document
                .map((state) => {'id': state.id, 'name': state.name})
                .toList();
        emit(state.copyWith(states: states));
        _setStatesUIState(UIState.success(result.value));
      } else if (result is Error) {
        _setStatesUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      _setStatesUIState(UIState.error(GenericError()));
    }
  }

  /// Fetch districts by state ID
  Future<void> fetchDistricts(int stateId) async {
    _setDistrictsUIState(UIState.loading());

    try {
      final result = await _repository.fetchDistricts(stateId);

      if (result is Success<api_models.EnDhanDistrictResponse>) {
        final districts =
            result.value.document
                .map(
                  (district) => {
                    'id': district.id,
                    'district_name': district.districtName,
                  },
                )
                .toList();
        emit(state.copyWith(districts: districts));
        _setDistrictsUIState(UIState.success(result.value));
      } else if (result is Error) {
        _setDistrictsUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      _setDistrictsUIState(UIState.error(GenericError()));
    }
  }

  /// Fetch zonal offices
  Future<void> fetchZonalOffices() async {
    _setZonalOfficesUIState(UIState.loading());

    try {
      final result = await _repository.fetchZonalOffices();

      if (result is Success<api_models.EnDhanZonalResponse>) {
        final zonalOffices =
            result.value.document
                .map((zonal) => {'id': zonal.id, 'zone_name': zonal.zoneName})
                .toList();
        emit(state.copyWith(zonalOffices: zonalOffices));
        _setZonalOfficesUIState(UIState.success(result.value));
      } else if (result is Error) {
        _setZonalOfficesUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      _setZonalOfficesUIState(UIState.error(GenericError()));
    }
  }

  /// Fetch regional offices by zone ID
  Future<void> fetchRegionalOffices(int zoneId) async {
    _setRegionalOfficesUIState(UIState.loading());

    try {
      final result = await _repository.fetchRegionalOffices(zoneId);

      if (result is Success<api_models.EnDhanRegionalResponse>) {
        final regionalOffices =
            result.value.document
                .map(
                  (regional) => {
                    'id': regional.id,
                    'region_name': regional.regionName,
                  },
                )
                .toList();
        emit(state.copyWith(regionalOffices: regionalOffices));
        _setRegionalOfficesUIState(UIState.success(result.value));
      } else if (result is Error) {
        _setRegionalOfficesUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      _setRegionalOfficesUIState(UIState.error(GenericError()));
    }
  }

  /// Fetch vehicle types
  Future<void> fetchVehicleTypes() async {
    if (_isClosed) return;

    _setVehicleTypesUIState(UIState.loading());

    try {
      final result = await _repository.fetchVehicleTypes();

      if (result is Success<api_models.EnDhanVehicleTypeResponse>) {
        final vehicleTypes = result.value.document;
        emit(state.copyWith(vehicleTypes: vehicleTypes));
        _setVehicleTypesUIState(UIState.success(result.value));
      } else if (result is Error) {
        _setVehicleTypesUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      _setVehicleTypesUIState(UIState.error(GenericError()));
    }
  }

  // ==================== Form Field Updates ====================

  // Set Aadhaar number
  void setAadhaar(String value) {
    print('🔍 setAadhaar called with: "$value", cubit closed: $_isClosed');
    if (!_isClosed) {
      emit(state.copyWith(aadhaar: value));
      print('🔍 Aadhaar state updated to: "${state.aadhaar}"');
    } else {
      print('🔍 Cubit is closed, cannot update Aadhaar state');
    }
  }

  // Set PAN number
  void setPan(String value) {
    if (!_isClosed) {
      emit(state.copyWith(pan: value));
    }
  }

  // Set address proof front
  void setAddressProofFront(String value) {
    if (!_isClosed) {
      emit(state.copyWith(addressProofFront: value));
    }
  }

  // Set address proof back
  void setAddressProofBack(String value) {
    if (!_isClosed) {
      emit(state.copyWith(addressProofBack: value));
    }
  }

  // Set identity proof front
  void setIdentityProofFront(String value) {
    if (!_isClosed) {
      emit(state.copyWith(identityProofFront: value));
    }
  }

  // Set identity proof back
  void setIdentityProofBack(String value) {
    if (!_isClosed) {
      emit(state.copyWith(identityProofBack: value));
    }
  }

  // Set PAN image
  void setPanImage(String value) {
    if (!_isClosed) {
      emit(state.copyWith(panImage: value));
    }
  }

  // Set customer ID
  void setCustomerId(int? value) {
    if (!_isClosed) {
      emit(state.copyWith(customerId: value));
    }
  }

  // ==================== Validation Methods ====================

  // Validate Aadhaar number
  void validateAadhaar(String value) {
    print('🔍 validateAadhaar called with: "$value", cubit closed: $_isClosed');
    final isValid = _validateAadhaar(value) == null;
    print('🔍 Aadhaar Validation Debug:');
    print('  - Input value: "$value"');
    print('  - Validation result: $isValid');
    print('  - Error message: ${_validateAadhaar(value)}');
    if (!_isClosed) {
      emit(state.copyWith(isAadhaarValid: isValid));
      print('🔍 isAadhaarValid updated to: $isValid');
    } else {
      print('🔍 Cubit is closed, cannot update validation state');
    }
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

    if (!_isClosed) {
      emit(state.copyWith(isPanValid: isValid));

      // Auto-verify PAN when input is valid and complete (10 characters)
      if (isValid && value.length == 10 && !state.isPanVerified) {
        print('🔍 PAN Auto-verification triggered!');
        // Add a small delay to avoid too many API calls
        Future.delayed(Duration(milliseconds: 500), () {
          if (!_isClosed && state.pan == value) {
            print('🔍 PAN Auto-verification executing...');
            verifyPan();
          } else {
            print(
              '🔍 PAN Auto-verification skipped - cubit closed or PAN changed',
            );
          }
        });
      } else {
        print('🔍 PAN Auto-verification conditions not met:');
        print('  - isValid: $isValid');
        print('  - length == 10: ${value.length == 10}');
        print('  - !isPanVerified: ${!state.isPanVerified}');
      }
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
    if (!_isClosed) {
      emit(state.copyWith(isPanImageUploaded: value));
    }
  }

  // Set identity front uploaded flag
  void setIdentityFrontUploaded(bool value) {
    if (!_isClosed) {
      emit(state.copyWith(isIdentityFrontUploaded: value));
    }
  }

  // Set identity back uploaded flag
  void setIdentityBackUploaded(bool value) {
    if (!_isClosed) {
      emit(state.copyWith(isIdentityBackUploaded: value));
    }
  }

  // Set address front uploaded flag
  void setAddressFrontUploaded(bool value) {
    if (!_isClosed) {
      emit(state.copyWith(isAddressFrontUploaded: value));
    }
  }

  // Set address back uploaded flag
  void setAddressBackUploaded(bool value) {
    if (!_isClosed) {
      emit(state.copyWith(isAddressBackUploaded: value));
    }
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

  // ==================== Card Creation Form Field Updates ====================

  // Set customer name
  void setCustomerName(String value) {
    emit(state.copyWith(customerName: value));
  }

  // Set title
  void setTitle(String value) {
    emit(state.copyWith(title: value));
  }

  // Set mobile number
  void setMobile(String value) {
    emit(state.copyWith(mobile: value));
  }

  // Set email
  void setEmail(String value) {
    emit(state.copyWith(email: value));
  }

  // Set address line 1
  void setAddress1(String value) {
    emit(state.copyWith(address1: value));
  }

  // Set address line 2
  void setAddress2(String value) {
    emit(state.copyWith(address2: value));
  }

  // Set city name
  void setCityName(String value) {
    emit(state.copyWith(cityName: value));
  }

  // Set communication city name
  void setCommunicationCityName(String value) {
    emit(state.copyWith(cityName: value));
  }

  // Reset all form data
  void resetFormData() {
    emit(
      state.copyWith(
        customerName: '',
        title: '',
        mobile: '',
        pan: '',
        email: '',
        address1: '',
        address2: '',
        cityName: '',
        pincode: '',
        selectedStateId: null,
        selectedDistrictId: null,
        selectedZonalOfficeId: null,
        selectedRegionalOfficeId: null,
        shippingAddress: '',
        saveAsShipping: true,
        regionalOffice: '',
        roAddress1: '',
        roAddress2: '',
        roState: '',
        roDistrict: '',
        cards: [const CardFormData()], // Reset to single empty card
        hasAttemptedSubmit: false,
      ),
    );
  }

  // Reset form data and clear KYC state for new card creation
  void resetFormDataForNewCard() {
    emit(
      state.copyWith(
        customerName: '',
        title: '',
        mobile: '',
        pan: '',
        email: '',
        address1: '',
        address2: '',
        cityName: '',
        pincode: '',
        selectedStateId: null,
        selectedDistrictId: null,
        selectedZonalOfficeId: null,
        selectedRegionalOfficeId: null,
        shippingAddress: '',
        saveAsShipping: true,
        regionalOffice: '',
        roAddress1: '',
        roAddress2: '',
        roState: '',
        roDistrict: '',
        cards: [const CardFormData()], // Reset to single empty card
        hasAttemptedSubmit: false,
        hasKycDocuments: false, // Force going through customer info screen
      ),
    );
  }

  // Set pincode
  void setPincode(String value) {
    emit(state.copyWith(pincode: value));
  }

  // Set selected state ID
  void setSelectedStateId(int? value) {
    // Clear districts when state changes
    emit(
      state.copyWith(
        selectedStateId: value,
        districts: [], // Clear districts when state changes
        selectedDistrictId: null, // Clear selected district
      ),
    );
  }

  // Set selected district ID
  void setSelectedDistrictId(int? value) {
    emit(state.copyWith(selectedDistrictId: value));
  }

  // Set selected zonal office ID
  void setSelectedZonalOfficeId(int? value) {
    // Clear regional offices when zonal office changes
    emit(
      state.copyWith(
        selectedZonalOfficeId: value,
        regionalOffices: [], // Clear regional offices when zonal office changes
        selectedRegionalOfficeId: null, // Clear selected regional office
      ),
    );
  }

  // Set selected regional office ID
  void setSelectedRegionalOfficeId(int? value) {
    emit(state.copyWith(selectedRegionalOfficeId: value));
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
    final newCards = List<CardFormData>.from(state.cards)
      ..add(const CardFormData());
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
  void updateCardField(
    int cardIndex, {
    String? vehicleNumber,
    String? vehicleType,
    String? vinNumber,
    String? mobile,
    String? rcNumber,
    List<Map<String, dynamic>>? rcDocuments,
  }) {
    if (cardIndex < state.cards.length) {
      final currentCard = state.cards[cardIndex];
      final updatedCard = currentCard.copyWith(
        vehicleNumber: vehicleNumber,
        vehicleType: vehicleType,
        vinNumber: vinNumber,
        mobile: mobile,
        rcNumber: rcNumber,
        rcDocuments: rcDocuments,
      );

      print('=== DEBUG: Updating card $cardIndex ===');
      print(
        'Current card: ${currentCard.vehicleNumber} | ${currentCard.vehicleType} | ${currentCard.vinNumber} | ${currentCard.mobile}',
      );
      print(
        'Updated card: ${updatedCard.vehicleNumber} | ${updatedCard.vehicleType} | ${updatedCard.vinNumber} | ${updatedCard.mobile}',
      );

      updateCard(cardIndex, updatedCard);
    } else {
      print(
        '=== DEBUG: Card index $cardIndex out of bounds. Total cards: ${state.cards.length} ===',
      );
    }
  }

  // Check if form is valid
  bool isFormValid() {
    return state.isFormValid;
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
    if (!_isClosed) {
      emit(state.copyWith(kycCheckState: uiState));
    }
  }

  /// Sets the upload KYC UI state
  void _setUploadKycUIState(UIState<EnDhanKycModel>? uiState) {
    if (!_isClosed) {
      emit(state.copyWith(uploadKycState: uiState));
    }
  }

  /// Sets the customer creation UI state
  void _setCustomerCreationUIState(
    UIState<api_models.EnDhanCustomerCreationResponse>? uiState,
  ) {
    if (!_isClosed) {
      emit(state.copyWith(customerCreationState: uiState));
    }
  }

  /// Sets the states UI state
  void _setStatesUIState(UIState<api_models.EnDhanStateResponse>? uiState) {
    if (!_isClosed) {
      emit(state.copyWith(statesState: uiState));
    }
  }

  /// Sets the districts UI state
  void _setDistrictsUIState(
    UIState<api_models.EnDhanDistrictResponse>? uiState,
  ) {
    if (!_isClosed) {
      emit(state.copyWith(districtsState: uiState));
    }
  }

  /// Sets the zonal offices UI state
  void _setZonalOfficesUIState(
    UIState<api_models.EnDhanZonalResponse>? uiState,
  ) {
    if (!_isClosed) {
      emit(state.copyWith(zonalOfficesState: uiState));
    }
  }

  /// Sets the regional offices UI state
  void _setRegionalOfficesUIState(
    UIState<api_models.EnDhanRegionalResponse>? uiState,
  ) {
    if (!_isClosed) {
      emit(state.copyWith(regionalOfficesState: uiState));
    }
  }

  /// Sets the vehicle types UI state
  void _setVehicleTypesUIState(
    UIState<api_models.EnDhanVehicleTypeResponse>? uiState,
  ) {
    if (!_isClosed) {
      emit(state.copyWith(vehicleTypesState: uiState));
    }
  }

  /// Upload document
  Future<DocumentUploadResponse?> uploadDocument(File file) async {
    _setDocumentUploadUIState(UIState.loading());

    try {
      final result = await _repository.uploadDocument(file);

      if (result is Success<DocumentUploadResponse>) {
        _setDocumentUploadUIState(UIState.success(result.value));
        return result.value;
      } else if (result is Error) {
        _setDocumentUploadUIState(UIState.error((result as Error).type));
        return null;
      }
    } catch (e) {
      _setDocumentUploadUIState(UIState.error(GenericError()));
      return null;
    }
    return null;
  }

  /// Sets the document upload UI state
  void _setDocumentUploadUIState(UIState<DocumentUploadResponse>? uiState) {
    if (!_isClosed) {
      emit(state.copyWith(documentUploadState: uiState));
    }
  }

  /// Sets the cards UI state
  void _setCardsUIState(UIState<api_models.EnDhanCardListModel>? uiState) {
    if (!_isClosed) {
      emit(state.copyWith(cardsState: uiState));
    }
  }

  /// Reset cards UI state
  void resetCardsUIState() {
    if (!_isClosed) {
      emit(state.copyWith(cardsState: null));
    }
  }

  /// Reset all UI states
  void resetAllUIStates() {
    if (!_isClosed) {
      emit(
        state.copyWith(
          uploadKycState: null,
          kycCheckState: null,
          customerCreationState: null,
          statesState: null,
          districtsState: null,
          zonalOfficesState: null,
          regionalOfficesState: null,
          vehicleTypesState: null,
          documentUploadState: null,
          cardsState: null,
        ),
      );
    }
  }

  /// Reset only customer creation state
  void resetCustomerCreationState() {
    if (!_isClosed) {
      emit(state.copyWith(customerCreationState: null));
    }
  }

  // ==================== Reset Methods ====================

  /// Resets the KYC check UI state
  void resetKycCheckUIState() {
    if (!_isClosed) {
      emit(
        state.copyWith(
          kycCheckState: resetUIState<EnDhanKycCheckModel>(state.kycCheckState),
        ),
      );
    }
  }

  /// Resets the upload KYC UI state
  void resetUploadKycUIState() {
    if (!_isClosed) {
      emit(
        state.copyWith(
          uploadKycState: resetUIState<EnDhanKycModel>(state.uploadKycState),
        ),
      );
    }
  }

  /// Resets all state
  void resetState() {
    if (!_isClosed) {
      emit(
        state.copyWith(
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
        ),
      );
    }
  }
}
