import '../../../../data/ui_state/ui_state.dart';
import '../../model/kavach_commodity_model.dart';
import '../../model/kavach_truck_length_model.dart';
import '../../model/kavach_vehicle_document_upload_model.dart';

class KavachAddVehicleFormState {
  final UIState<List<CommodityModel>> commodities;
  final UIState<KavachVehicleDocumentUploadModel> vehicleDocUpload;
  final UIState<List<String>> truckTypes;
  final UIState<List<TruckLengthModel>> truckLengths;
  final UIState<bool> vehicleVerification;

  const KavachAddVehicleFormState({
    required this.truckTypes,
    required this.truckLengths,
    required this.commodities,
    required this.vehicleDocUpload,
    required this.vehicleVerification,
  });

  factory KavachAddVehicleFormState.initial() => KavachAddVehicleFormState(
    truckTypes: UIState.initial(),
    truckLengths: UIState.initial(),
    commodities: UIState.initial(),
    vehicleDocUpload: UIState.initial(),
    vehicleVerification: UIState.initial(),
  );

  KavachAddVehicleFormState copyWith({
    UIState<List<String>>? truckTypes,
    UIState<List<TruckLengthModel>>? truckLengths,
    UIState<List<CommodityModel>>? commodities,
    UIState<KavachVehicleDocumentUploadModel>? vehicleDocUpload,
    UIState<bool>? vehicleVerification,
  }) {
    return KavachAddVehicleFormState(
      truckTypes: truckTypes ?? this.truckTypes,
      truckLengths: truckLengths ?? this.truckLengths,
      commodities: commodities ?? this.commodities,
      vehicleDocUpload: vehicleDocUpload ?? this.vehicleDocUpload,
      vehicleVerification: vehicleVerification ?? this.vehicleVerification
    );
  }
}

