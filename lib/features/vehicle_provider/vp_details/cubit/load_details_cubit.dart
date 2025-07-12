import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/trip_tracking/helper/trip_tracking_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/damage_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/get_damage_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/upload_damage_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/repository/load_details_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/direction_api_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/repository/vp_repository.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

import 'load_details_state.dart';

class LoadDetailsCubit extends BaseCubit<LoadDetailsState> {
  final LoadDetailsRepository _loadDetailsRepository;
  final VpHomeRepository _vHomeRepository;
  LoadDetailsCubit(this._loadDetailsRepository,this._vHomeRepository) : super(LoadDetailsState());

  acceptLoad(int? status) {
    LoadStatus? loadStatus;
    loadStatus=switch(status){
      3 => LoadStatus.accepted,
      4 => LoadStatus.assigned,
      5 => LoadStatus.loading,
      6=>LoadStatus.unloading,
      7=>LoadStatus.inTransit,
      8=>LoadStatus.completed,
      null||  int() => throw LoadStatus.matching};
      emit(state.copyWith(
        loadStatusId: status,
        loadStatus:loadStatus));
  }


  Future<void> getLoadDetails(String loadId) async {
    emit(state.copyWith(loadDetailsUIState: UIState.loading()));
    Result result = await _loadDetailsRepository.fetchLoadDetails(loadId.toString());
    if (result is Success<LoadDetailModel>) {
      emit(state.copyWith(
          locationDistance: getDistance(result.value.data?.loadRoute?.pickUpLatlon??"0",result.value.data?.loadRoute?.dropLatlon??"0"),
          loadDetailsUIState: UIState.success(result.value)));

      acceptLoad(state.loadDetailsUIState?.data?.data?.loadStatusId);
    }
    if (result is Error) {
      emit(state.copyWith(loadDetailsUIState: UIState.error(result.type)));
    }
  }

  Future<void> changedLoadStatus(
    String load, {
    String? customerId,
    int? loadStatus,
  }) async {
    emit(state.copyWith(vpLoadStatus: UIState.loading()));
    Result result = await _loadDetailsRepository.changeLoadStatus(
      customerId: customerId.toString(),
      loadStatus: loadStatus,
      loadId: load.toString(),
    );
    if (result is Success<VpLoadAcceptModel>) {
      emit(state.copyWith(vpLoadStatus: UIState.success(result.value)));
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // slight delay to ensure UI handles it
      acceptLoad(result.value.data?.loadStatus);
    }

    if (result is Error) {
      emit(state.copyWith(vpLoadStatus: UIState.error(result.type)));
      ToastMessages.error(message: getErrorMsg(errorType: state.vpLoadStatus!.errorType!));
    }
  }

   String getDistance(String pickUpLatLong,dropLatLong){
    final pickupLatLng = TripTrackingHelper.getLatLngFromString(pickUpLatLong);
    final dropLatLng = TripTrackingHelper.getLatLngFromString(dropLatLong);
    double distanceInMeters = Geolocator.distanceBetween(
      pickupLatLng.latitude,
      pickupLatLng.longitude,
      dropLatLng.latitude,
      dropLatLng.longitude,
    );
    return (distanceInMeters / 1000).toStringAsFixed(2);
  }

  updatePossibleDeliveryDateDate(String? possibleDeliveryTime) {
    emit(state.copyWith(possibleDeliveryDate: possibleDeliveryTime));
  }


  Future scheduleTripApi(ScheduleTripRequest scheduleTripRequest) async {
    emit(state.copyWith(scheduleTripResponse: UIState.loading()));
    try{
    Result result = await _vHomeRepository.scheduleTripResponse(
      apiRequest: scheduleTripRequest,
    );
    if (result is Success<ScheduleTripResponse>) {
      emit(state.copyWith(scheduleTripResponse: UIState.success(result.value)));
      Navigator.pop(navigatorKey.currentState!.context);
    } else if (result is Error) {
      emit(state.copyWith(scheduleTripResponse: UIState.error(result.type)));
      ToastMessages.error(message: getErrorMsg(errorType: state.scheduleTripResponse?.errorType??GenericError()));
    } else {
      emit(state.copyWith(scheduleTripResponse: UIState.error(GenericError())));
      ToastMessages.error(message: getErrorMsg(errorType: state.scheduleTripResponse?.errorType??GenericError()));
    }
  }catch(e){
      ToastMessages.error(message:e.toString(),);
      emit(state.copyWith(scheduleTripResponse: UIState.error(DeserializationError())));
      }
  }


  Future getMapRouting({String? pickUpLat,String? pickUpLong,String? dropLat,String? dropLong}) async {
    emit(state.copyWith(directionApiResponse: UIState.loading()));
    try{
      DirectionResponse? directionResponse = await _vHomeRepository.getGoogleDirectionResponse(
          pickUpLat,
          pickUpLong,
          dropLat,
          dropLong
      );
      if (directionResponse!=null) {
        emit(state.copyWith(directionApiResponse: UIState.success(directionResponse)));
      }
    }catch(e){
      ToastMessages.error(message:e.toString(),);
      emit(state.copyWith(directionApiResponse: UIState.error(DeserializationError())));
    }
  }


  // Create Damage Api Call
  void _setDamageUIState(UIState<DamageModel>? uiState){
    emit(state.copyWith(createDamageUIState: uiState));
  }
  Future<void> createDamage(DamageApiRequest req) async {
    _setDamageUIState(UIState.loading());
    Result result = await _loadDetailsRepository.getSubmitDamageData(req);
    if (result is Success<DamageModel>) {
      _setDamageUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setDamageUIState(UIState.error(result.type));
    }
  }


  //  Damage list Api Call
  void _setDamageListUIState(UIState<GetDamageListModel>? uiState){
    emit(state.copyWith(damageListUIState: uiState));
  }
  Future<void> fetchDamageList(String loadId) async {
    _setDamageListUIState(UIState.loading());
    Result result = await _loadDetailsRepository.getDamageListData(loadId);
    if (result is Success<GetDamageListModel>) {
      _setDamageListUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setDamageListUIState(UIState.error(result.type));
    }
  }


  // // Upload TDS File
  void _setUploadDamageFileUIState(UIState<UploadDamageFileModel>? uiState){
    emit(state.copyWith(uploadDamageUIState: uiState));
  }
  Future<void> uploadDamageFile(File file) async {
    _setUploadDamageFileUIState(UIState.loading());
    Result result = await _loadDetailsRepository.getUploadDamageFileData(file);
    if (result is Success<UploadDamageFileModel>) {
      _setUploadDamageFileUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadDamageFileUIState(UIState.error(result.type));
    }
  }


  void resetUploadDamageFileUIState(){
    emit(state.copyWith(uploadDamageUIState: resetUIState<UploadDamageFileModel>(state.uploadDamageUIState)));
  }


  void resetSubmitDamageUIState(){
    emit(state.copyWith(createDamageUIState: resetUIState<DamageModel>(state.createDamageUIState)));
  }


  void resetState(){
    emit(state.copyWith(
      possibleDeliveryDate: "",
      scheduleTripResponse: resetUIState<ScheduleTripResponse>(state.scheduleTripResponse),
      uploadDamageUIState: resetUIState<UploadDamageFileModel>(state.uploadDamageUIState),
      createDamageUIState : resetUIState<DamageModel>(state.createDamageUIState),
    ));
  }
}
