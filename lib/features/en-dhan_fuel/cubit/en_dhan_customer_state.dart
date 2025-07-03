

import 'package:equatable/equatable.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/card_form_data.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_models.dart' as api_models;

import '../../../data/ui_state/ui_state.dart';
import '../model/document_upload_response.dart';

class EnDhanCustomerState extends Equatable {
  // UI States
  final UIState<api_models.EnDhanCustomerCreationResponse>? customerCreationState;
  final UIState<api_models.EnDhanStateResponse>? statesState;
  final UIState<api_models.EnDhanDistrictResponse>? districtsState;
  final UIState<api_models.EnDhanZonalResponse>? zonalOfficesState;
  final UIState<api_models.EnDhanRegionalResponse>? regionalOfficesState;
  final UIState<api_models.EnDhanVehicleTypeResponse>? vehicleTypesState;
  final UIState<DocumentUploadResponse>? documentUploadState;

  // Customer Form fields
  final String customerName;
  final String title;
  final String mobile;
  final String email;
  final String address1;
  final String address2;
  final String cityName;
  final String pincode;
  final String pan;
  final int? selectedStateId;
  final int? selectedDistrictId;
  final int? selectedZonalOfficeId;
  final int? selectedRegionalOfficeId;
  final List<CardFormData> cards;
  
  // Master Data
  final List<dynamic> states;
  final List<dynamic> districts;
  final List<dynamic> zonalOffices;
  final List<dynamic> regionalOffices;
  final List<String> vehicleTypes;

  const EnDhanCustomerState({
    this.customerCreationState,
    this.statesState,
    this.districtsState,
    this.zonalOfficesState,
    this.regionalOfficesState,
    this.vehicleTypesState,
    this.documentUploadState,
    this.customerName = '',
    this.title = '',
    this.mobile = '',
    this.email = '',
    this.address1 = '',
    this.address2 = '',
    this.cityName = '',
    this.pincode = '',
    this.pan = '',
    this.selectedStateId,
    this.selectedDistrictId,
    this.selectedZonalOfficeId,
    this.selectedRegionalOfficeId,
    required this.cards,
    this.states = const [],
    this.districts = const [],
    this.zonalOffices = const [],
    this.regionalOffices = const [],
    this.vehicleTypes = const [],
  });

  /// Factory constructor for initial state
  factory EnDhanCustomerState.initial() {
    return EnDhanCustomerState(
      cards: [CardFormData()],
    );
  }

  EnDhanCustomerState copyWith({
    UIState<api_models.EnDhanCustomerCreationResponse>? customerCreationState,
    UIState<api_models.EnDhanStateResponse>? statesState,
    UIState<api_models.EnDhanDistrictResponse>? districtsState,
    UIState<api_models.EnDhanZonalResponse>? zonalOfficesState,
    UIState<api_models.EnDhanRegionalResponse>? regionalOfficesState,
    UIState<api_models.EnDhanVehicleTypeResponse>? vehicleTypesState,
    UIState<DocumentUploadResponse>? documentUploadState,
    String? customerName,
    String? title,
    String? mobile,
    String? email,
    String? address1,
    String? address2,
    String? cityName,
    String? pincode,
    String? pan,
    int? selectedStateId,
    int? selectedDistrictId,
    int? selectedZonalOfficeId,
    int? selectedRegionalOfficeId,
    List<CardFormData>? cards,
    List<dynamic>? states,
    List<dynamic>? districts,
    List<dynamic>? zonalOffices,
    List<dynamic>? regionalOffices,
    List<String>? vehicleTypes,
  }) {
    return EnDhanCustomerState(
      customerCreationState: customerCreationState ?? this.customerCreationState,
      statesState: statesState ?? this.statesState,
      districtsState: districtsState ?? this.districtsState,
      zonalOfficesState: zonalOfficesState ?? this.zonalOfficesState,
      regionalOfficesState: regionalOfficesState ?? this.regionalOfficesState,
      vehicleTypesState: vehicleTypesState ?? this.vehicleTypesState,
      documentUploadState: documentUploadState ?? this.documentUploadState,
      customerName: customerName ?? this.customerName,
      title: title ?? this.title,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      cityName: cityName ?? this.cityName,
      pincode: pincode ?? this.pincode,
      pan: pan ?? this.pan,
      selectedStateId: selectedStateId ?? this.selectedStateId,
      selectedDistrictId: selectedDistrictId ?? this.selectedDistrictId,
      selectedZonalOfficeId: selectedZonalOfficeId ?? this.selectedZonalOfficeId,
      selectedRegionalOfficeId: selectedRegionalOfficeId ?? this.selectedRegionalOfficeId,
      cards: cards ?? this.cards,
      states: states ?? this.states,
      districts: districts ?? this.districts,
      zonalOffices: zonalOffices ?? this.zonalOffices,
      regionalOffices: regionalOffices ?? this.regionalOffices,
      vehicleTypes: vehicleTypes ?? this.vehicleTypes,
    );
  }

  @override
  List<Object?> get props => [
    customerCreationState,
    statesState,
    districtsState,
    zonalOfficesState,
    regionalOfficesState,
    vehicleTypesState,
    documentUploadState,
    customerName,
    mobile,
    email,
    address1,
    address2,
    cityName,
    pincode,
    pan,
    selectedStateId,
    selectedDistrictId,
    selectedZonalOfficeId,
    selectedRegionalOfficeId,
    cards,
    states,
    districts,
    zonalOffices,
    regionalOffices,
    vehicleTypes,
  ];
} 