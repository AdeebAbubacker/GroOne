import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/repository/load_details_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/repository/vp_repository.dart';
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
      emit(state.copyWith(loadDetailsUIState: UIState.success(result.value)));
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

  updatePossibleDeliveryDateDate(String? possibleDeliveryTime) {
    emit(state.copyWith(possibleDeliveryDate: possibleDeliveryTime));
  }


  Future scheduleTripApi(ScheduleTripRequest scheduleTripRequest) async {
    emit(state.copyWith(scheduleTripResponse: UIState.loading()));
    Result result = await _vHomeRepository.scheduleTripResponse(
      apiRequest: scheduleTripRequest,
    );
    if (result is Success<ScheduleTripResponse>) {
      emit(state.copyWith(scheduleTripResponse: UIState.success(result.value)));
    } else if (result is Error) {
      emit(state.copyWith(scheduleTripResponse: UIState.error(result.type)));
    } else {
      emit(state.copyWith(scheduleTripResponse: UIState.error(GenericError())));
    }
  }
}
