import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/VpCompanyTypeModel.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/upload_rc_truck_file_model.dart' hide Data;
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/repository/vp_creation_repository.dart';

part 'vp_create_account_state.dart';

class VpCreateAccountCubit extends BaseCubit<VpCreateAccountState> {
  final VpCreationRepository _repository;
  VpCreateAccountCubit(this._repository) : super(VpCreateAccountState());


  // Create Account Api Call
  void _setSendOtpUIState(UIState<UserModel?>? uiState){
    emit(state.copyWith(createAccountUIState: uiState));
  }
  Future<void> createAccount(VpCreationApiRequest req, String userId) async {
    _setSendOtpUIState(UIState.loading());
    Result result = await _repository.requestVpCreation(req, id: userId);
    if (result is Success<UserModel?>) {
      _setSendOtpUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setSendOtpUIState(UIState.error(result.type));
    }
  }


  // Fetch company type Api Call
  void _setCompanyTypeUIState(UIState<List<VpCompanyTypeModel>>? uiState){
    emit(state.copyWith(companyTypeUIState: uiState));
  }
  Future<void> fetchCompanyType() async {
    _setCompanyTypeUIState(UIState.loading());
    Result result = await _repository.getCompanyTypeData();
    if (result is Success<List<VpCompanyTypeModel>>) {
      _setCompanyTypeUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCompanyTypeUIState(UIState.error(result.type));
    }
  }


  // Fetch Truck type Api Call
  void _setTruckTypeUIState(UIState<List<TruckTypeModel>>? uiState){
    emit(state.copyWith(truckTypeUIState: uiState));
  }
  Future<void> fetchTruckType() async {
    _setTruckTypeUIState(UIState.loading());
    Result result = await _repository.getTruckTypeData();
    if (result is Success<List<TruckTypeModel>>) {
      _setTruckTypeUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setTruckTypeUIState(UIState.error(result.type));
    }
  }


  // Fetch Pref Lane Api Call
  void _setPrefLaneUIState(UIState<TruckPrefLaneModel>? uiState){
    emit(state.copyWith(prefLaneUIState: uiState));
  }
  Future<void> fetchPrefLane(String? location) async {
    _setPrefLaneUIState(UIState.loading());
    Result result = await _repository.getPrefTruckLaneData(location);
    if (result is Success<TruckPrefLaneModel>) {
      _setPrefLaneUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setPrefLaneUIState(UIState.error(result.type));
    }
  }


  // Fetch Pref Lane Api Call
  void _setUploadRcTruckFileUIState(UIState<UploadRcTruckFileModel>? uiState){
    emit(state.copyWith(uploadRcFileUIState: uiState));
  }
  Future<void> uploadRcTruckFile(File file, String? userId) async {
    _setUploadRcTruckFileUIState(UIState.loading());
    Result result = await _repository.getUploadRcTruckData(file, userId);
    if (result is Success<UploadRcTruckFileModel>) {
      _setUploadRcTruckFileUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadRcTruckFileUIState(UIState.error(result.type));
    }
  }


  // Reset Rc file ui state
  void resetUploadRcFileUIState(){
    emit(state.copyWith(uploadRcFileUIState: resetUIState<UploadRcTruckFileModel>(state.uploadRcFileUIState)));
  }

  void selectLanes(int index,{bool? selected}){
    List<Item> preferLanes=List.from(state.prefLaneUIState?.data?.data?.items??[]);
    if(preferLanes.isNotEmpty){
      Item lanesItem=  preferLanes[index];
      // final selected=(lanesItem.isSelected??false) ?false:true;
     final selectedLanesItem=lanesItem.copyWith(
      isSelected: selected
    );
      preferLanes[index]=selectedLanesItem;
      emit(state.copyWith(
        prefLaneUIState: UIState.success(TruckPrefLaneModel(data: state.prefLaneUIState?.data?.data?.copyWith(
          items: preferLanes
        )
      ))));
    }
  }


  // Reset UI
  void resetState(){
    emit(state.copyWith(
      createAccountUIState: resetUIState<UserModel?>(state.createAccountUIState),
      companyTypeUIState: resetUIState<List<VpCompanyTypeModel>>(state.companyTypeUIState),
      truckTypeUIState: resetUIState<List<TruckTypeModel>>(state.truckTypeUIState),
      prefLaneUIState: resetUIState<TruckPrefLaneModel>(state.prefLaneUIState),
      uploadRcFileUIState: resetUIState<UploadRcTruckFileModel>(state.uploadRcFileUIState),
    ));
  }


}
