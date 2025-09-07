import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/repository/vp_repository.dart';

part 'vp_home_state.dart';


class VpHomeCubit extends BaseCubit<VpsHomeState> {
  final VpHomeRepository _vHomeRepository;
  final UserInformationRepository _userInformationRepository;

  VpHomeCubit(this._vHomeRepository, this._userInformationRepository)
      : super(const VpsHomeState());
  
  int _driverCurrentPage = 1;
  bool _driverIsLastPage = false;
  /// Fetch driver list


Future<void> fetchDrivers({
  String? search,
  bool loadMore = false,
}) async {
  if (_driverIsLastPage && loadMore) return;

  if (!loadMore) {
    _driverCurrentPage = 1;
    _driverIsLastPage = false;
    emit(state.copyWith(driverUIState: UIState.loading()));
  } else {
    _driverCurrentPage++;
  }

  final userId = await _userInformationRepository.getUserID();

  final result = await _vHomeRepository.getDriverDetails(
    userId: userId ?? '',
    search: search,
    page: _driverCurrentPage,
    limit: 10,
  );

  if (result is Success<DriverListResponse>) {
    final newDrivers = result.value.data;
    final totalPages = result.value.pageMeta.pageCount;

    if (loadMore) {
      final existing = state.driverUIState?.data?.data ?? [];
      emit(state.copyWith(
        driverUIState: UIState.success(
          DriverListResponse(
            data: [...existing, ...newDrivers],
            total: result.value.total,
            pageMeta: result.value.pageMeta,
          ),
        ),
      ));
    } else {
      emit(state.copyWith(driverUIState: UIState.success(result.value)));
    }

    // ✅ Stop fetching when last page reached
    _driverIsLastPage = _driverCurrentPage >= totalPages;
  } else if (result is Error<DriverListResponse>) {
    emit(state.copyWith(driverUIState: UIState.error(result.type)));
  }
}


  /// Fetch vehicle list
  Future<void> fetchVehicles({String? search}) async {
    emit(state.copyWith(vehicleUIState: UIState.loading()));

    final userId = await _userInformationRepository.getUserID();

    final result = await _vHomeRepository.getVehicleDetails(
      userId: userId ?? '',
      search: search,
    );

    if (result is Success<VehicleListResponse>) {
      emit(state.copyWith(vehicleUIState: UIState.success(result.value)));
    } else if (result is Error<VehicleListResponse>) {
      emit(state.copyWith(vehicleUIState: UIState.error(result.type)));
    }
  }


}
