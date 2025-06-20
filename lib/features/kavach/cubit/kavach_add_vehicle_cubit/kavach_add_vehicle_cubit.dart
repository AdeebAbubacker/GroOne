import 'dart:io';
import 'package:bloc/bloc.dart';
import '../../../../data/model/result.dart';
import '../../../../data/ui_state/ui_state.dart';
import '../../api_request/kavach_add_vehicle_request.dart';
import '../../model/kavach_commodity_model.dart';
import '../../model/kavach_truck_type_model.dart';
import '../../model/kavach_vehicle_document_upload_model.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_add_vehicle_state.dart';

class KavachAddVehicleFormCubit extends Cubit<KavachAddVehicleFormState> {
  final KavachRepository repository;

  KavachAddVehicleFormCubit(this.repository)
      : super(KavachAddVehicleFormState.initial());

  Future<void> fetchTruckTypes() async {
    emit(state.copyWith(truckTypes: UIState.loading()));
    final result = await repository.fetchTruckTypes();
    if (result is Success<List<TruckTypeModel>>) {
      emit(state.copyWith(truckTypes: UIState.success(result.value)));
    } else {
      emit(state.copyWith(truckTypes: UIState.error(GenericError())));
    }
  }

  Future<void> fetchCommodities() async {
    emit(state.copyWith(commodities: UIState.loading()));
    final result = await repository.fetchCommodities();
    if (result is Success<List<CommodityModel>>) {
      emit(state.copyWith(commodities: UIState.success(result.value)));
    } else {
      emit(state.copyWith(commodities: UIState.error(GenericError())));
    }
  }

  Future<void> uploadVehicleDoc(File file) async {
    emit(state.copyWith(vehicleDocUpload: UIState.loading()));
    final result = await repository.getUploadGstData(file);
    if (result is Success<KavachVehicleDocumentUploadModel>) {
      emit(state.copyWith(vehicleDocUpload: UIState.success(result.value)));
    } else {
      emit(state.copyWith(vehicleDocUpload: UIState.error(GenericError())));
    }
  }

  Future<Result<void>> addVehicle(KavachAddVehicleRequest request) async {
    return await repository.addVehicle(request);
  }
}
