import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/verify_location_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart' hide Result;
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';


class LPHomeCubit extends Cubit<LPHomeState> {
  final LpHomeRepository _repo;
  LPHomeCubit(this._repo) : super(LPHomeState());


  // Fetch Truck Type
  Future<void> fetchTruckTypes() async {
    emit(state.copyWith(truckTypeState: UIState<LoadTruckTypeListModel>.loading()));
    Result  result = await _repo.getTruckTypeData();
    if (result is Success<LoadTruckTypeListModel>) {
      emit(state.copyWith(truckTypeState: UIState<LoadTruckTypeListModel>.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(truckTypeState: UIState<LoadTruckTypeListModel>.error(result.type)));
    }
  }


  // Fetch Recent Route
  Future<void> fetchRecentRoute() async {
    emit(state.copyWith(recentRouteState: UIState<RecentRoutesModel>.loading()));
    Result result = await _repo.getRecentRouteData();
    if (result is Success<RecentRoutesModel?>) {
      emit(state.copyWith(recentRouteState: UIState<RecentRoutesModel>.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(recentRouteState: UIState<RecentRoutesModel>.error(result.type)));
    }
  }


  // Fetch Auto Complete
  Future<void> mapAutoComplete(String input) async {
    emit(state.copyWith(autoCompleteState: UIState.loading()));
    Result result = await _repo.getAutoCompleteData(input);
    if (result is Success<AutoCompleteModel>) {
      emit(state.copyWith(autoCompleteState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(autoCompleteState: UIState.error(result.type)));
    }
  }


  // Location Verified Api Call
  Future<void> verifyLocation(VerifyLocationApiRequest request) async {
    emit(state.copyWith(verifyLocationState: UIState.loading()));
    Result result = await _repo.getVerifyLocationData(request);
    if (result is Success<VerifyLocationModel>) {
      emit(state.copyWith(verifyLocationState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(verifyLocationState: UIState.error(result.type)));
    }
  }

  // Kyc Timer
  Future<void> startKycSuccessTimer() async {
    emit(state.copyWith(showSuccessKyc: true));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(showSuccessKyc: false));
  }

  void setDestination(Map<String, dynamic>? destination) {
    emit(state.copyWith(destination: destination));
  }

  void setPickup(Map<String, dynamic>? pickup) {
    emit(state.copyWith(pickup: pickup));
  }

  void clearPickUpAndDestination() {
    emit(state.copyWith(destination: null));
    emit(state.copyWith(pickup: null));
  }


}
