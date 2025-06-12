import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';


class LPHomeCubit extends Cubit<LPHomeState> {
  final LpHomeRepository _truckRepo;
  LPHomeCubit(this._truckRepo) : super(LPHomeState());

  // Fetch Truck Type
  Future<void> fetchTruckTypes() async {
    emit(state.copyWith(truckTypeState: UIState.loading()));
    Result  result = await _truckRepo.getTruckTypeData();
    if (result is Success<LoadTruckTypeListModel>) {
      emit(state.copyWith(truckTypeState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(truckTypeState: UIState.error(result.type)));
    }
  }

  // Fetch Recent Route
  Future<void> fetchRecentRoute() async {
    emit(state.copyWith(recentRouteState: UIState<RecentRoutesModel>.loading()));
    Result result = await _truckRepo.getRecentRouteData();
    if (result is Success<RecentRoutesModel?>) {
      emit(state.copyWith(recentRouteState: UIState<RecentRoutesModel>.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(recentRouteState: UIState<RecentRoutesModel>.error(result.type)));
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


}
