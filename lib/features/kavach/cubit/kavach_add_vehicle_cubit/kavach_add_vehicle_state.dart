import '../../../../data/ui_state/ui_state.dart';
import '../../model/kavach_commodity_model.dart';
import '../../model/kavach_truck_type_model.dart';
import '../../model/kavach_vehicle_document_upload_model.dart';

class KavachAddVehicleFormState {
  final UIState<List<TruckTypeModel>> truckTypes;
  final UIState<List<CommodityModel>> commodities;
  final UIState<KavachVehicleDocumentUploadModel> vehicleDocUpload;

  const KavachAddVehicleFormState({
    required this.truckTypes,
    required this.commodities,
    required this.vehicleDocUpload,
  });

  factory KavachAddVehicleFormState.initial() => KavachAddVehicleFormState(
    truckTypes: UIState.initial(),
    commodities: UIState.initial(),
    vehicleDocUpload: UIState.initial(),
  );

  KavachAddVehicleFormState copyWith({
    UIState<List<TruckTypeModel>>? truckTypes,
    UIState<List<CommodityModel>>? commodities,
    UIState<KavachVehicleDocumentUploadModel>? vehicleDocUpload,
  }) {
    return KavachAddVehicleFormState(
      truckTypes: truckTypes ?? this.truckTypes,
      commodities: commodities ?? this.commodities,
      vehicleDocUpload: vehicleDocUpload ?? this.vehicleDocUpload,
    );
  }
}
