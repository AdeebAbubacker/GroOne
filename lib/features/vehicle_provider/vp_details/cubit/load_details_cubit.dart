import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/trip_tracking/helper/trip_tracking_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
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
    switch(status){
      case 3 :
        loadStatus=LoadStatus.accepted;
        break;
      case 4:
        loadStatus=LoadStatus.assigned;
        break;
      default:
        loadStatus=LoadStatus.matching;
    }
    emit(state.copyWith(loadStatus:loadStatus));
  }


  Future<void> getLoadDetails(int loadId) async {
    emit(state.copyWith(loadDetailsUIState: UIState.loading()));
    Result result = await _loadDetailsRepository.fetchLoadDetails(loadId);
    if (result is Success<LoadDetailsResponseModel>) {
      emit(state.copyWith(
          locationDistance: getDistance(result.value.data?.pickUpLatlon??"0",result.value.data?.dropLatlon??"0"),
          loadDetailsUIState: UIState.success(result.value)));
      acceptLoad(state.loadDetailsUIState?.data?.data?.loadStatus);
    }
    if (result is Error) {
      emit(state.copyWith(loadDetailsUIState: UIState.error(result.type)));
    }
  }

  Future<void> changedLoadStatus(
    int load, {
    int? customerId,
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
      acceptLoad(result.value.data?.load?.loadStatus);
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
      Result result = await _vHomeRepository.getGoogleDirectionResponse(
          pickUpLat,
          pickUpLong,
          dropLat,
          dropLong
      );
      if (result is Success<DirectionResponse>) {
        emit(state.copyWith(directionApiResponse: UIState.success(result.value)));
        print("routing is ${state.directionApiResponse?.data?.routes.first.overviewPolyline.points}");
      } else if (result is Error) {
        emit(state.copyWith(directionApiResponse: UIState.error(result.type)));
        ToastMessages.error(message: getErrorMsg(errorType: state.scheduleTripResponse?.errorType??GenericError()));
      } else {
        emit(state.copyWith(directionApiResponse: UIState.error(GenericError())));
        ToastMessages.error(message: getErrorMsg(errorType: state.scheduleTripResponse?.errorType??GenericError()));
      }
    }catch(e){
      ToastMessages.error(message:e.toString(),);
      emit(state.copyWith(directionApiResponse: UIState.error(DeserializationError())));
    }
  }



  void resetState(){
    emit(state.copyWith(
      possibleDeliveryDate: "",
      scheduleTripResponse: resetUIState<ScheduleTripResponse>(state.scheduleTripResponse),
    ));
  }
}
