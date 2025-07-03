import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/en-dhan_fuel/api_request/en-dhan_api_request.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_models.dart' as api_models;
import 'package:gro_one_app/features/en-dhan_fuel/model/document_upload_response.dart';
import 'package:gro_one_app/features/en-dhan_fuel/repository/en-dhan_repository.dart';

import '../model/card_form_data.dart';
import 'en_dhan_customer_state.dart';

class EnDhanCustomerCubit extends Cubit<EnDhanCustomerState> {
  final EnDhanRepository _repository;
  
  EnDhanCustomerCubit(this._repository) : super(EnDhanCustomerState.initial());

  // ==================== Customer Creation ====================
  
  /// Create customer with card details
  Future<void> createCustomer() async {
    if (!isCardCreationFormValid()) {
      emit(state.copyWith(customerCreationState: UIState.error(InvalidInputError())));
      return;
    }

    emit(state.copyWith(customerCreationState: UIState.loading()));
    
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
    final cardDetails = state.cards.map((card) => EnDhanCardDetailRequest(
      vechileNo: card.vehicleNumber,
      mobileNo: card.mobile,
      vehicleType: card.vehicleType ?? '',
      vinNumber: card.vinNumber,
      rcDocument: card.rcDocuments.isNotEmpty ? card.rcDocuments.first['fileName'] ?? '' : '',
      rcNumber: card.rcNumber, // This should be the RC book number
    )).toList();

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
      title: state.title.isNotEmpty ? state.title : 'Mr', // Use selected title or default
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
      emit(state.copyWith(customerCreationState: UIState.success(result.value)));
    } else if (result is Error) {
      emit(state.copyWith(customerCreationState: UIState.error(result.type)));
    }
  }

  // ==================== Master Data Fetching ====================
  
  /// Fetch states
  Future<void> fetchStates() async {
    emit(state.copyWith(statesState: UIState.loading()));
    
    try {
      final result = await _repository.fetchStates();
      
      if (result is Success<api_models.EnDhanStateResponse>) {
        final states = result.value.document.map((state) => {
          'id': state.id,
          'name': state.name,
        }).toList();
        emit(state.copyWith(states: states, statesState: UIState.success(result.value)));
      } else if (result is Error) {
        emit(state.copyWith(statesState: UIState.error((result as Error).type)));
      }
    } catch (e) {
      emit(state.copyWith(statesState: UIState.error(GenericError())));
    }
  }

  /// Fetch districts by state ID
  Future<void> fetchDistricts(int stateId) async {
    emit(state.copyWith(districtsState: UIState.loading()));
    
    try {
      final result = await _repository.fetchDistricts(stateId);
      
      if (result is Success<api_models.EnDhanDistrictResponse>) {
        final districts = result.value.document.map((district) => {
          'id': district.id,
          'district_name': district.districtName,
        }).toList();
        emit(state.copyWith(districts: districts, districtsState: UIState.success(result.value)));
      } else if (result is Error) {
        emit(state.copyWith(districtsState: UIState.error((result as Error).type)));
      }
    } catch (e) {
      emit(state.copyWith(districtsState: UIState.error(GenericError())));
    }
  }

  /// Fetch zonal offices
  Future<void> fetchZonalOffices() async {
    emit(state.copyWith(zonalOfficesState: UIState.loading()));
    
    try {
      final result = await _repository.fetchZonalOffices();
      
      if (result is Success<api_models.EnDhanZonalResponse>) {
        final zonalOffices = result.value.document.map((zonal) => {
          'id': zonal.id,
          'zone_name': zonal.zoneName,
        }).toList();
        emit(state.copyWith(zonalOffices: zonalOffices, zonalOfficesState: UIState.success(result.value)));
      } else if (result is Error) {
        emit(state.copyWith(zonalOfficesState: UIState.error((result as Error).type)));
      }
    } catch (e) {
      emit(state.copyWith(zonalOfficesState: UIState.error(GenericError())));
    }
  }

  /// Fetch regional offices by zone ID
  Future<void> fetchRegionalOffices(int zoneId) async {
    emit(state.copyWith(regionalOfficesState: UIState.loading()));
    
    try {
      final result = await _repository.fetchRegionalOffices(zoneId);
      
      if (result is Success<api_models.EnDhanRegionalResponse>) {
        final regionalOffices = result.value.document.map((regional) => {
          'id': regional.id,
          'region_name': regional.regionName,
        }).toList();
        emit(state.copyWith(regionalOffices: regionalOffices, regionalOfficesState: UIState.success(result.value)));
      } else if (result is Error) {
        emit(state.copyWith(regionalOfficesState: UIState.error((result as Error).type)));
      }
    } catch (e) {
      emit(state.copyWith(regionalOfficesState: UIState.error(GenericError())));
    }
  }

  /// Fetch vehicle types
  Future<void> fetchVehicleTypes() async {
    emit(state.copyWith(vehicleTypesState: UIState.loading()));
    
    try {
      final result = await _repository.fetchVehicleTypes();
      
      if (result is Success<api_models.EnDhanVehicleTypeResponse>) {
        final vehicleTypes = result.value.document;
        emit(state.copyWith(vehicleTypes: vehicleTypes, vehicleTypesState: UIState.success(result.value)));
      } else if (result is Error) {
        emit(state.copyWith(vehicleTypesState: UIState.error((result as Error).type)));
      }
    } catch (e) {
      emit(state.copyWith(vehicleTypesState: UIState.error(GenericError())));
    }
  }

  // ==================== Form Field Updates ====================
  
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

  // Set pincode
  void setPincode(String value) {
    emit(state.copyWith(pincode: value));
  }

  // Set selected state ID
  void setSelectedStateId(int? value) {
    // Clear districts when state changes
    emit(state.copyWith(
      selectedStateId: value,
      districts: [], // Clear districts when state changes
      selectedDistrictId: null, // Clear selected district
    ));
  }

  // Set selected district ID
  void setSelectedDistrictId(int? value) {
    emit(state.copyWith(selectedDistrictId: value));
  }

  // Set selected zonal office ID
  void setSelectedZonalOfficeId(int? value) {
    // Clear regional offices when zonal office changes
    emit(state.copyWith(
      selectedZonalOfficeId: value,
      regionalOffices: [], // Clear regional offices when zonal office changes
      selectedRegionalOfficeId: null, // Clear selected regional office
    ));
  }

  // Set selected regional office ID
  void setSelectedRegionalOfficeId(int? value) {
    emit(state.copyWith(selectedRegionalOfficeId: value));
  }

  // Add a new card
  void addCard() {
    final newCards = List<CardFormData>.from(state.cards)..add( CardFormData());
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
      print('Current card: ${currentCard.vehicleNumber} | ${currentCard.vehicleType} | ${currentCard.vinNumber} | ${currentCard.mobile}');
      print('Updated card: ${updatedCard.vehicleNumber} | ${updatedCard.vehicleType} | ${updatedCard.vinNumber} | ${updatedCard.mobile}');
      
      updateCard(cardIndex, updatedCard);
    } else {
      print('=== DEBUG: Card index $cardIndex out of bounds. Total cards: ${state.cards.length} ===');
    }
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

  /// Upload document
  Future<DocumentUploadResponse?> uploadDocument(File file) async {
    emit(state.copyWith(documentUploadState: UIState.loading()));
    
    try {
      final result = await _repository.uploadDocument(file);
      
      if (result is Success<DocumentUploadResponse>) {
        emit(state.copyWith(documentUploadState: UIState.success(result.value)));
        return result.value;
      } else if (result is Error) {
        emit(state.copyWith(documentUploadState: UIState.error((result as Error).type)));
        return null;
      }
    } catch (e) {
      emit(state.copyWith(documentUploadState: UIState.error(GenericError())));
      return null;
    }
    return null;
  }

  // Reset all form data
  void resetFormData() {
    emit(state.copyWith(
      customerName: '',
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
      cards: [ CardFormData()], // Reset to single empty card
    ));
  }

  /// Reset only customer creation state
  void resetCustomerCreationState() {
    emit(state.copyWith(customerCreationState: null));
  }

  /// Reset all state
  void resetState() {
    emit(EnDhanCustomerState.initial());
  }
} 