import '../../../../data/ui_state/ui_state.dart';
import '../../models/gps_vehicle_models.dart';
import '../../models/gps_truck_length_model.dart';
import '../../models/gps_commodity_model.dart';

class GpsVehicleState {
  final UIState<List<GpsVehicleModel>> vehicles;
  final UIState<GpsAddVehicleResponse> addVehicle;
  final UIState<GpsDocumentUploadResponse> documentUpload;
  final UIState<List<String>> truckTypes;
  final UIState<List<GpsTruckLengthModel>> truckLengths;
  final UIState<List<GpsCommodityModel>> commodities;
  final UIState<bool> vehicleVerification;

  GpsVehicleState({
    UIState<List<GpsVehicleModel>>? vehicles,
    UIState<GpsAddVehicleResponse>? addVehicle,
    UIState<GpsDocumentUploadResponse>? documentUpload,
    UIState<List<String>>? truckTypes,
    UIState<List<GpsTruckLengthModel>>? truckLengths,
    UIState<List<GpsCommodityModel>>? commodities,
    UIState<bool>? vehicleVerification,
  }) : vehicles = vehicles ?? UIState.initial(),
       addVehicle = addVehicle ?? UIState.initial(),
       documentUpload = documentUpload ?? UIState.initial(),
       truckTypes = truckTypes ?? UIState.initial(),
       truckLengths = truckLengths ?? UIState.initial(),
       commodities = commodities ?? UIState.initial(),
       vehicleVerification = vehicleVerification ?? UIState.initial();

  GpsVehicleState copyWith({
    UIState<List<GpsVehicleModel>>? vehicles,
    UIState<GpsAddVehicleResponse>? addVehicle,
    UIState<GpsDocumentUploadResponse>? documentUpload,
    UIState<List<String>>? truckTypes,
    UIState<List<GpsTruckLengthModel>>? truckLengths,
    UIState<List<GpsCommodityModel>>? commodities,
    UIState<bool>? vehicleVerification,
  }) {
    return GpsVehicleState(
      vehicles: vehicles ?? this.vehicles,
      addVehicle: addVehicle ?? this.addVehicle,
      documentUpload: documentUpload ?? this.documentUpload,
      truckTypes: truckTypes ?? this.truckTypes,
      truckLengths: truckLengths ?? this.truckLengths,
      commodities: commodities ?? this.commodities,
      vehicleVerification: vehicleVerification ?? this.vehicleVerification,
    );
  }
} 