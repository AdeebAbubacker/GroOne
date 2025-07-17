import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/driver/driver_home/repository/driver_load_repository.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/driver/driver_load_details/repository/driver_loads_details_repository.dart';

part 'driver_load_details_state.dart';


class DriverLoadDetailsCubit extends BaseCubit<DriverLoadDetailsState> {
  final DriverLoadsDetailsRepository _repository;

  DriverLoadDetailsCubit(this._repository) : super(DriverLoadDetailsState());


  // Updates the UI state related to loading LP loads by ID.
  void _setLoadByIdUIState(UIState<DriverLoadDetailsModel>? uiState) {
    emit(state.copyWith(lpLoadById: uiState,));
  }

  // Fetches the LP loads filtered by the given [type].
Future<void> getLpLoadsById({required String loadId}) async {
  _setLoadByIdUIState(UIState.loading());

  Result result = await _repository.fetchDriversLoadById(loadId: 'd');

  if (result is Success<DriverLoadDetailsModel>) {
    _setLoadByIdUIState(UIState.success(result.value)); 
  } else if (result is Error) {
    _setLoadByIdUIState(UIState.error(result.type));
  }
}
}

