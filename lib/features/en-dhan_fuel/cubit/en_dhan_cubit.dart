import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/en-dhan_fuel/api_request/en-dhan_api_request.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/document_upload_response.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_kyc_model.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_models.dart'
    as api_models;
import 'package:gro_one_app/features/en-dhan_fuel/model/vehicle_verification_response.dart';
import 'package:gro_one_app/features/en-dhan_fuel/repository/en-dhan_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/pincode_response.dart';

import '../../../data/network/api_service.dart';
import '../../../dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';

part 'en_dhan_state.dart';

class EnDhanCubit extends BaseCubit<EnDhanState> {
  final EnDhanRepository _repository;
  final UserInformationRepository _userInformationRepository;
  bool _isClosed = false;

  EnDhanCubit(this._repository, this._userInformationRepository) : super(EnDhanState.initial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  void setAadhaarDocUrl(String url) {
    emit(state.copyWith(aadhaarDocLink: url));
  }

  void setAadhaarVerified(bool value) {
    emit(state.copyWith(isAadhaarVerified: value));
  }


  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(EnDhanState.initial());
  }

  /// Comprehensive reset for KYC screen - ensures all states are cleared
  void resetKycScreenCompletely() {
    if (!_isClosed) {
      emit(EnDhanState.initial());
    }
  }

  /// Debug method to check cubit status
  void debugCubitStatus() {
    // Debug method - status checking available
  }

  // ==================== KYC Check ====================

  /// Check if KYC documents exist for the customer
  Future<void> checkKycDocuments() async {
    if (_isClosed) return;

    _setKycCheckUIState(UIState.loading());

    try {
      // Get customer ID dynamically
      final customerId = await _userInformationRepository.getUserID();
      if (customerId == null || customerId.isEmpty) {
        _setKycCheckUIState(UIState.error(ErrorWithMessage(message: 'Customer ID not found')));
        return;
      }
      
      final result = await _repository.checkKycDocuments(customerId);
      
      if (_isClosed) return;

      // if (result is Success<EnDhanKycCheckModel>) {
      //   final response = result.value;
      //
      //   // Handle "Document not found" as a valid response
      //   if (response.data == "Document not found") {
      //     // Document not found - this is expected for new users
      //   }
      //
      //   // Update the state with KYC check results
      //   emit(state.copyWith(
      //     kycCheckState: UIState.success(response),
      //     hasKycDocuments: response.hasKycDocuments,
      //     kycData: response.kycData,
      //   ));
      // }
      if (result is Success<EnDhanKycCheckModel>) {
        final response = result.value;

        bool shouldNavigateToKyc = false;

        final document = response.kycData?.document;

        if (document == null ||
            document.identityProofFront == null ||
            document.identityProofFront!.trim().isEmpty) {
          shouldNavigateToKyc = true;
        }

        emit(state.copyWith(
          kycCheckState: UIState.success(response),
          hasKycDocuments: !shouldNavigateToKyc,
          kycData: response.kycData,
        ));
      }


      else if (result is Error) {
        _setKycCheckUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
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

  /// Upload a single document and return the URL
  Future<Result<String>> _uploadDocument(File file, String customerId) async {
    try {
      final apiService = locator<ApiService>();
      final result = await apiService.multipart(
        // 'https://gro-devapi.letsgro.co/document/api/v1/upload',
        ApiUrls.documentUpload,
        file,
        fields: {
          'userId': customerId,
          'fileType': 'pan_document',
          'documentType': ' ',
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

  /// Uploads KYC documents to En-Dhan API
  Future<bool> uploadKycDocuments() async {
    markFormSubmitted();

    if (!isFormValid()) {
      _setUploadKycUIState(UIState.error(InvalidInputError()));
      return false;
    }

    _setUploadKycUIState(UIState.loading());
    final customerId = await _userInformationRepository.getUserID();
    if (customerId == null || customerId.isEmpty) {
      _setUploadKycUIState(UIState.error(ErrorWithMessage(message: 'Customer ID not found')));
      return false;
    }

    try {
      String? panDocLink;

      if (!state.isPanImageUploaded) {
        if (state.panDocuments.isNotEmpty) {
          final filePath = state.panDocuments.first['path'];
          if (filePath != null && !filePath.startsWith('http')) {
            final uploadResult = await _uploadDocument(File(filePath), customerId);
            if (uploadResult is Success<String>) {
              panDocLink = uploadResult.value;
            } else {
              _setUploadKycUIState(
                UIState.error(ErrorWithMessage(message: 'Failed to upload PAN document')),
              );
              return false;
            }
          }
        }
      } else {
        // Already uploaded — URL is in state.panDocuments[0]['path']
        panDocLink = state.panDocuments.first['path'];
      }

      final result = await _repository.uploadKycDocuments(
        EnDhanKycApiRequest(
          aadhar: state.aadhaar,
          isAadhar: true,
          pan: state.pan,
          panDocLink: panDocLink,
          isPan: state.pan.isNotEmpty ? true : null,
          aadharDocLink: state.aadhaarDocLink,
          fromFleet: true
        ),
        customerId,
      );

      if (result is Success<EnDhanKycModel>) {
        // _setUploadKycUIState(UIState.success(result.value));
        return true;
      } else {
        _setUploadKycUIState(UIState.error((result as Error).type));
        return false;
      }
    } catch (_) {
      _setUploadKycUIState(UIState.error(GenericError()));
      return false;
    }
  }


  // Future<void> uploadKycDocuments() async {
  //   // Mark that form submission has been attempted
  //   markFormSubmitted();
  //
  //   if (!isFormValid()) {
  //     _setUploadKycUIState(UIState.error(InvalidInputError()));
  //     return;
  //   }
  //
  //   _setUploadKycUIState(UIState.loading());
  //
  //   // Get customer ID dynamically
  //   final customerId = await _userInformationRepository.getUserID();
  //   if (customerId == null || customerId.isEmpty) {
  //     _setUploadKycUIState(UIState.error(ErrorWithMessage(message: 'Customer ID not found')));
  //     return;
  //   }
  //
  //   try {
  //     String? panDocLink;
  //
  //     // Upload PAN document if provided
  //     if (state.panDocuments.isNotEmpty && state.pan.isNotEmpty) {
  //       final document = state.panDocuments.first;
  //       if (document['path'] != null) {
  //         final panImageFile = File(document['path']);
  //
  //         // Upload the PAN document first to get the URL
  //         final uploadResult = await _uploadDocument(panImageFile, customerId);
  //         if (uploadResult is Success<String>) {
  //           panDocLink = uploadResult.value;
  //         } else {
  //           _setUploadKycUIState(UIState.error(ErrorWithMessage(message: 'Failed to upload PAN document')));
  //           return;
  //         }
  //       }
  //     }
  //
  //
  //     final request = EnDhanKycApiRequest(
  //       aadhar: state.aadhaar,
  //       isAadhar: true,
  //       pan: state.pan,
  //       panDocLink: panDocLink,
  //       isPan: state.pan.isNotEmpty ? true : null,
  //       aadharDocLink: state.aadhaarDocLink,
  //     );
  //
  //     final result = await _repository.uploadKycDocuments(request, customerId);
  //
  //     if (_isClosed) return;
  //
  //     if (result is Success<EnDhanKycModel>) {
  //       _setUploadKycUIState(UIState.success(result.value));
  //     } else if (result is Error) {
  //       _setUploadKycUIState(UIState.error((result as Error).type));
  //     }
  //   } catch (e) {
  //     if (!_isClosed) {
  //       _setUploadKycUIState(UIState.error(GenericError()));
  //     }
  //   }
  // }

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

    // Get customer ID dynamically
    final customerId = await _userInformationRepository.getUserID();
    if (customerId == null || customerId.isEmpty) {
      _setUploadKycUIState(UIState.error(ErrorWithMessage(message: 'Customer ID not found')));
      return;
    }

    try {
      // Convert document lists to File objects
      File? addressProofFrontFile;
      File? addressProofBackFile;
      File? identityProofFrontFile;
      File? identityProofBackFile;

      if (state.addressFrontDocuments.isNotEmpty) {
        final document = state.addressFrontDocuments.first;
        if (document is Map && document['path'] != null) {
          addressProofFrontFile = File(document['path']);
        }
      }
      if (state.addressBackDocuments.isNotEmpty) {
        final document = state.addressBackDocuments.first;
        if (document is Map && document['path'] != null) {
          addressProofBackFile = File(document['path']);
        }
      }
      if (state.identityFrontDocuments.isNotEmpty) {
        final document = state.identityFrontDocuments.first;
        if (document is Map && document['path'] != null) {
          identityProofFrontFile = File(document['path']);
        }
      }
      if (state.identityBackDocuments.isNotEmpty) {
        final document = state.identityBackDocuments.first;
        if (document is Map && document['path'] != null) {
          identityProofBackFile = File(document['path']);
        }
      }

      final request = EnDhanKycMultipartApiRequest(
        addressProofFront: addressProofFrontFile,
        addressProofBack: addressProofBackFile,
        identityProofFront: identityProofFrontFile,
        identityProofBack: identityProofBackFile,
      );

      final result = await _repository.uploadKycDocumentsMultipart(request, customerId);

      if (_isClosed) return;

      if (result is Success<EnDhanKycModel>) {
        _setUploadKycUIState(UIState.success(result.value));
      } else if (result is Error) {
        _setUploadKycUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      if (!_isClosed) {
        _setUploadKycUIState(UIState.error(GenericError()));
      }
    }
  }

  /// Fetch Card Balance
  Future<void> fetchCardBalance() async {
    if (_isClosed) return;

    _setCardBalanceUIState(UIState.loading());

    try {
      final result = await _repository.fetchCardBalance();
      
      if (_isClosed) return;

      if (result is Success<api_models.EnDhanCardBalanceResponse>) {
        _setCardBalanceUIState(UIState.success(result.value));
      } else if (result is Error) {
        _setCardBalanceUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      if (!_isClosed) {
        _setCardBalanceUIState(UIState.error(GenericError()));
      }
    }
  }

  /// Fetch Cards List
  Future<void> fetchCards({String? searchTerm}) async {
    if (_isClosed) {
      return;
    }

    _setCardsUIState(UIState.loading());

    final result = await _repository.fetchCards(searchTerm: searchTerm);

    if (_isClosed) {
      return; // Check again after async operation
    }

    if (result is Success<api_models.EnDhanCardListModel>) {
      _setCardsUIState(UIState.success(result.value));
    } else if (result is Error<api_models.EnDhanCardListModel>) {
      _setCardsUIState(UIState.error(result.type));
    }
  }

  // ==================== Aadhaar Verification ====================

  /// Send Aadhaar OTP
  Future<void> sendAadhaarOtp() async {
    if (_isClosed) {
      return;
    }

    if (state.aadhaar.isEmpty) {
      return;
    }

    _setAadhaarSendOtpUIState(UIState.loading());

    try {
      final request = AadhaarSendOtpRequest(
        aadhaar: state.aadhaar,
        force: true,
      );

      final result = await _repository.sendAadhaarOtp(request);

      if (_isClosed) {
        return;
      }

      if (result is Success<AadhaarSendOtpResponse>) {
        final response = result.value;
        
        // Store the request ID, with fallback if it's null or empty
        String requestId = response.requestId ?? '';
        if (requestId.isEmpty) {
          requestId = '123456'; // Fallback to static request ID
        }
        
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

  /// Verify Aadhaar OTP
  Future<void> verifyAadhaarOtp(String otp) async {
    if (_isClosed) {
      return;
    }

    if (state.aadhaar.isEmpty) {
      return;
    }

    // Use fallback request ID if the stored one is null or empty
    String requestId = state.aadhaarRequestId ?? '';
    if (requestId.isEmpty) {
      requestId = '123456'; // Fallback to static request ID
    }

    _setAadhaarVerifyOtpUIState(UIState.loading());

    try {
      final request = AadhaarVerifyOtpRequest(
        requestId: requestId,
        otp: otp,
        aadhaar: state.aadhaar,
      );

      final result = await _repository.verifyAadhaarOtp(request);

      if (_isClosed) {
        return;
      }

      if (result is Success<AadhaarVerifyOtpResponse>) {
        final response = result.value;
        // Check if verification was successful based on success flag and message
        if (response.success == true || 
            (response.message.toLowerCase().contains('verified successfully') || 
             response.message.toLowerCase().contains('verification successful'))) {
          final newState = state.copyWith(isAadhaarVerified: true);
          emit(newState);
        }
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
    if (_isClosed) {
      return;
    }

    if (state.pan.isEmpty) {
      return;
    }

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

      final request = PanVerificationRequest(
        panNumber: state.pan,
        name: customerName,
      );

      final result = await _repository.verifyPan(request);

      if (_isClosed) {
        return;
      }

      if (result is Success<PanVerificationResponse>) {
        final response = result.value;

        final isVerified = response.isVerified == true ||
            response.success == true ||
            (response.message.toLowerCase().contains('verified successfully') ||
                response.message.toLowerCase().contains('verification successful'));

        if (isVerified) {
          emit(state.copyWith(isPanVerified: true));
          _setPanVerificationUIState(UIState.success(response));
        } else {
          _setPanVerificationUIState(UIState.error(
            ErrorWithMessage(message:'PAN verification failed'),
          ));
        }
      }

    } catch (e) {
      if (!_isClosed) {
        _setPanVerificationUIState(UIState.error(GenericError()));
      }
    }
  }

  /// Set PAN Verification UI State
  void _setPanVerificationUIState(UIState<PanVerificationResponse> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(panVerificationState: uiState));
    }
  }

  // ==================== Vehicle Verification ====================

  /// Verify vehicle number for a specific card
  Future<void> verifyVehicle(int cardIndex, String vehicleNumber) async {
    if (_isClosed) {
      return;
    }

    if (vehicleNumber.isEmpty) {
      return;
    }

    // Validate vehicle number format (more flexible Indian format)
    final vehicleRegex = RegExp(r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{4}$');
    if (!vehicleRegex.hasMatch(vehicleNumber.toUpperCase())) {
      _setVehicleVerificationUIState(UIState.error(InvalidInputError()));
      return;
    }

    _setVehicleVerificationUIState(UIState.loading());

    try {
      final request = VehicleVerificationRequest(
        vehicleNumber: vehicleNumber.toUpperCase(),
        force: true,
      );

      final result = await _repository.verifyVehicle(request);

      if (_isClosed) {
        return;
      }

      if (result is Success<VehicleVerificationResponse>) {
        final response = result.value;
        
        if (response.success) {
          // Mark this vehicle number as verified
          final updatedVerifiedVehicles = Map<int, bool>.from(state.verifiedVehicleNumbers);
          updatedVerifiedVehicles[cardIndex] = true;
          
          emit(state.copyWith(verifiedVehicleNumbers: updatedVerifiedVehicles));
          _setVehicleVerificationUIState(UIState.success(response));
        } else {
          _setVehicleVerificationUIState(UIState.error(InvalidInputError()));
        }
      } else if (result is Error) {
        _setVehicleVerificationUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      if (!_isClosed) {
        _setVehicleVerificationUIState(UIState.error(GenericError()));
      }
    }
  }

  /// Set Vehicle Verification UI State
  void _setVehicleVerificationUIState(UIState<VehicleVerificationResponse> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(vehicleVerificationState: uiState));
    }
  }

  /// Get Pincode Details
  Future<void> getPincode(String pincode) async {
    if (_isClosed) return;

    if (pincode.isEmpty || pincode.length != 6) {
      return;
    }
    
    _setPincodeUIState(UIState.loading());

    try {
      final result = await _repository.getPincode(pincode);

      if (_isClosed) return;

      if (result is Success<PincodeResponse>) {
        final response = result.value;
        
        if (response.success && response.data != null) {
          // Auto-populate the fields with API data
          final data = response.data!;
          
          // Local variables to store the final state values
          int? finalZonalOfficeId;
          String? finalZonalOfficeName;
          int? finalRegionalOfficeId;
          int? finalStateId;
          String? finalStateName;
          int? finalDistrictId;
          String? finalDistrictName;

          
          // Set zonal office and fetch regional offices
          if (data.zonal != null) {
            finalZonalOfficeId = data.zonal!.id;
            finalZonalOfficeName = data.zonal!.name;
            // Fetch regional offices for this zonal office
            await fetchRegionalOffices(data.zonal!.id);
          }
          
          // Set regional office
          if (data.region != null) {
            finalRegionalOfficeId = data.region!.id;
          }
          
          // Set state and fetch districts
          if (data.state != null) {
            finalStateId = data.state!.id;
            finalStateName = data.state!.name;
            // Fetch districts for this state
            await fetchDistricts(data.state!.id);
            
            // Set district after districts are loaded
            if (data.district != null) {
              finalDistrictId = data.district!.id;
              finalDistrictName = data.district!.name;
            }
          } else {
            // Set district if no state change
            if (data.district != null) {
              finalDistrictId = data.district!.id;
            }
          }
          
                              // Single emit call with all the updated values
                    if (!_isClosed) {
                      emit(state.copyWith(
                        selectedZonalOfficeId: finalZonalOfficeId,
                        selectedRegionalOfficeId: finalRegionalOfficeId,
                        selectedStateId: finalStateId,
                        selectedDistrictId: finalDistrictId,
                        selectedDistrictName: finalDistrictName,
                        selectedStateName: finalStateName,
                        selectedZonalOfficeName: finalZonalOfficeName,
                      ));
                    }
        }
        
        _setPincodeUIState(UIState.success(response));
      } else if (result is Error) {
        _setPincodeUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      if (!_isClosed) {
        _setPincodeUIState(UIState.error(GenericError()));
      }
    }
  }

  /// Set Pincode UI State
  void _setPincodeUIState(UIState<PincodeResponse> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(pincodeState: uiState));
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

    // Get customer ID dynamically
    final customerId = await _userInformationRepository.getUserID();
    if (customerId == null || customerId.isEmpty) {
      _setCustomerCreationUIState(UIState.error(ErrorWithMessage(message: 'Customer ID not found')));
      return;
    }

    // Convert cards to API request format
    final cardDetails =
        state.cards
            .map(
              (card) => EnDhanCardDetailRequest(
                vechileNo: card.vehicleNumber.replaceAll(' ', ''),
                mobileNo: card.mobile.trim().isNotEmpty ? card.mobile : null,
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



    final request = EnDhanCustomerCreationApiRequest(
      customerId: customerId, // Added customerId parameter
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
      referralCode: state.referralCode.isNotEmpty ? state.referralCode : null, // Added referral code
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
                .map((state) => {'id': state.id, 'state_name': state.name})
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
        debugCubitStatus();
        _setVehicleTypesUIState(UIState.success(result.value));

        // Force another emit to ensure UI rebuilds
        Future.delayed(Duration(milliseconds: 100), () {
          if (!_isClosed) {
            emit(state.copyWith(vehicleTypes: vehicleTypes));
          }
        });
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
    if (!_isClosed) {
      emit(state.copyWith(aadhaar: value));
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
    final isValid = _validateAadhaar(value) == null;
    if (!_isClosed) {
      emit(state.copyWith(isAadhaarValid: isValid));
    }
  }

  // Validate PAN number
  void validatePan(String value) {
    final isValid = _validatePan(value) == null;
    if (!_isClosed) {
      emit(state.copyWith(isPanValid: isValid));
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
    final newState = state.copyWith(panDocuments: List.from(documents));
    emit(newState);
  }

  // Update identity front documents list
  void updateIdentityFrontDocuments(List documents) {
    final newState = state.copyWith(identityFrontDocuments: List.from(documents));
    emit(newState);
  }

  // Update identity back documents list
  void updateIdentityBackDocuments(List documents) {
    final newState = state.copyWith(identityBackDocuments: List.from(documents));
    emit(newState);
  }

  // Update address front documents list
  void updateAddressFrontDocuments(List documents) {
    final newState = state.copyWith(addressFrontDocuments: List.from(documents));
    emit(newState);
  }

  // Update address back documents list
  void updateAddressBackDocuments(List documents) {
    final newState = state.copyWith(addressBackDocuments: List.from(documents));
    emit(newState);
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

  // Preserve customer data but clear card data when navigating back
  void preserveCustomerDataAndClearCards() {
    emit(
      state.copyWith(
        // Preserve customer data
        // customerName, title, mobile, pan, email, address1, address2, cityName, pincode
        // selectedStateId, selectedDistrictId, selectedZonalOfficeId, selectedRegionalOfficeId
        // shippingAddress, saveAsShipping, regionalOffice, roAddress1, roAddress2, roState, roDistrict
        
        // Clear only card-related data
        cards: [const CardFormData()], // Reset to single empty card
        hasAttemptedSubmit: false,
        
        // Clear UI states that are not needed when going back
        customerCreationState: null,
        vehicleVerificationState: null,
        documentUploadState: null,
        verifiedVehicleNumbers: {},
      ),
    );
  }

  // Set pincode
  void setPincode(String value) {
    emit(state.copyWith(pincode: value));
  }

  // Set referral code
  void setReferralCode(String value) {
    emit(state.copyWith(referralCode: value));
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

  // Set selected district name
  void setSelectedDistrictName(String? value) {
    emit(state.copyWith(selectedDistrictName: value));
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
      updateCard(cardIndex, updatedCard);
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
        state.cityName.isEmpty ||
        state.pincode.isEmpty) {
      return false;
    }
    
    // Validate city name format
    final cityRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!cityRegex.hasMatch(state.cityName.trim())) {
      return false;
    }
    
    if (state.cityName.trim().length < 2 || state.cityName.trim().length > 50) {
      return false;
    }

    // Check if shipping address is required and filled
    if (!state.saveAsShipping && state.shippingAddress.isEmpty) {
      return false;
    }

    // Check all cards have required fields
    for (int i = 0; i < state.cards.length; i++) {
      final card = state.cards[i];
      
      if (card.vehicleNumber.isEmpty) {
        return false;
      }
      
      if (card.vehicleType == null || card.vehicleType == 'Select' || card.vehicleType!.isEmpty) {
        return false;
      }
      
      if (card.vinNumber.isEmpty) {
        return false;
      }
      
      if (card.rcNumber.isEmpty) {
        return false;
      }
      
      if (card.rcDocuments.isEmpty) {
        return false;
      }
      
      // Vehicle verification is no longer required
      
      // Mobile number is optional, so we don't check for it
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

  /// Sets the card balance UI state
  void _setCardBalanceUIState(UIState<api_models.EnDhanCardBalanceResponse>? uiState) {
    if (!_isClosed) {
      emit(state.copyWith(cardBalanceState: uiState));
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

  /// Reset vehicle verification state
  void resetVehicleVerificationState() {
    if (!_isClosed) {
      emit(state.copyWith(vehicleVerificationState: null));
    }
  }

  /// Clear verification status for a specific vehicle number
  void clearVehicleVerificationStatus(int cardIndex) {
    if (!_isClosed) {
      final updatedVerifiedVehicles = Map<int, bool>.from(state.verifiedVehicleNumbers);
      updatedVerifiedVehicles.remove(cardIndex);
      emit(state.copyWith(verifiedVehicleNumbers: updatedVerifiedVehicles));
    }
  }

  /// Reset only the KYC form and verification state
  void resetKycFormState() {
    if (!_isClosed) {
      emit(state.copyWith(
        // Clear form fields
        aadhaar: '',
        pan: '',
        
        // Reset verification status
        isAadhaarVerified: false,
        isPanVerified: false,
        aadhaarRequestId: null,
        
        // Reset validation states
        isAadhaarValid: false,
        isPanValid: false,
        
        // Reset upload flags
        isPanImageUploaded: false,
        isIdentityFrontUploaded: false,
        isIdentityBackUploaded: false,
        isAddressFrontUploaded: false,
        isAddressBackUploaded: false,
        
        // Clear document lists
        panDocuments: [],
        identityFrontDocuments: [],
        identityBackDocuments: [],
        addressFrontDocuments: [],
        addressBackDocuments: [],
        
        // Reset UI states
        aadhaarSendOtpState: null,
        aadhaarVerifyOtpState: null,
        panVerificationState: null,
        uploadKycState: null,
        
        // Reset form submission flag
        hasAttemptedSubmit: false,
      ));
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
  void setInitialKycData({
    String? aadhaar,
    String? pan,
    bool isAadhaarVerified = false,
    bool isPanVerified = false,
  }) {
    emit(state.copyWith(
      aadhaar: aadhaar ?? '',
      pan: pan ?? '',
      isAadhaarVerified: isAadhaarVerified,
      isPanVerified: isPanVerified,
      isAadhaarValid: isAadhaarVerified,
      isPanValid: pan != null,
      isPanImageUploaded: pan != null
    ));
  }

  Future<void> checkEndhanServerStatus() async {
    if (_isClosed) return;

    emit(state.copyWith(endhanServerStatusState: UIState.loading()));

    try {
      final result = await _repository.checkEndhanServerStatus();

      if (_isClosed) return;

      if (result is Success<Map<String, dynamic>>) {
        emit(state.copyWith(endhanServerStatusState: UIState.success(result.value)));
      } else if (result is Error) {
        emit(state.copyWith(endhanServerStatusState: UIState.error((result as Error).type)));
      }
    } catch (e) {
      if (!_isClosed) {
        emit(state.copyWith(endhanServerStatusState: UIState.error(GenericError())));
      }
    }
  }


}
