import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_location_screens/lp_select_pick_point/repository/lp_map_select_pick_point_repository.dart';
import 'package:meta/meta.dart';

part 'lp_map_select_pick_point_event.dart';
part 'lp_map_select_pick_point_state.dart';

class LpMapSelectPickPointBloc extends Bloc<LpMapSelectPickPointEvent, LpMapSelectPickPointState> {
  final LpMapSelectPickPointRepository _repository;

  LpMapSelectPickPointBloc(this._repository) : super(LpMapSelectPickPointInitial()) {
    on<FetchCurrentLatLong>(_onFetchCurrentLatLong);
  }

  // Fetch current lat & long
  Future<void> _onFetchCurrentLatLong(FetchCurrentLatLong event, Emitter<LpMapSelectPickPointState> emit) async {
    emit(LatLongLoading());
    await Future.delayed(const Duration(seconds: 2));
    dynamic result = await _repository.getCurrentLatLongData();
    if (result is Success<geo.Position>) {
      emit(LatLongSuccess(result.value));
    } else if (result is Error) {
      emit(LatLongError(result.type));
    }
  }

}

