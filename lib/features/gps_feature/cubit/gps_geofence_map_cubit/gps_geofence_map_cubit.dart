import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/result.dart';
import '../../../load_provider/lp_home/api_request/verify_location_api_request.dart';
import '../../../load_provider/lp_home/model/auto_complete_model.dart';
import '../../../load_provider/lp_home/model/verify_location.dart';
import '../../repository/gps_repository.dart';
import 'gps_geofence_map_state.dart';

class GpsGeofenceMapCubit extends Cubit<GpsGeofenceMapState> {
  final GpsRepository repository;

  GpsGeofenceMapCubit(this.repository) : super(GpsGeofenceMapInitial());

  void resetAutoCompleteState() {
    emit(GpsGeofenceMapInitial());
  }


  Future<void> fetchAutoComplete(String input) async {
    emit(GpsGeofenceMapLoading());
    final result = await repository.getAutoCompleteData(input);
    if (result is Success<AutoCompleteModel>) {
      emit(GpsGeofenceMapAutoCompleteLoaded(result.value));
    } else if (result is Error) {
      final errorResult = result as Error;
      final errorType = errorResult.type;
      emit(GpsGeofenceMapError(
          errorType is ErrorWithMessage ? errorType.message : "Autocomplete failed"));
    }
  }

  Future<void> verifyLocation(VerifyLocationApiRequest request) async {
    emit(GpsGeofenceMapLoading());
    final result = await repository.getVerifyLocationData(request);
    if (result is Success<VerifyLocationModel>) {
      emit(GpsGeofenceMapVerifyLocationLoaded(result.value));
    } else if (result is Error) {
      final errorResult = result as Error;
      final errorType = errorResult.type;
      emit(GpsGeofenceMapError(
          errorType is ErrorWithMessage ? errorType.message : "Verify location failed"));
    }
  }
}
