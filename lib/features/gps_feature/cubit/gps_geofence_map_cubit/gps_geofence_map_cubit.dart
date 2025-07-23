import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/result.dart';
import '../../../load_provider/lp_home/api_request/verify_location_api_request.dart';
import '../../../load_provider/lp_home/model/auto_complete_model.dart';
import '../../../load_provider/lp_home/model/verify_location.dart';
import '../../repository/gps_repository.dart';
import 'gps_geofence_map_state.dart';

class GpsGeofenceMapCubit extends Cubit<GpsGeofenceMapState> {
  final GpsRepository repository;
  bool _isClosed = false;

  GpsGeofenceMapCubit(this.repository) : super(GpsGeofenceMapInitial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(GpsGeofenceMapInitial());
  }

  void resetAutoCompleteState() {
    if (!_isClosed) {
      emit(GpsGeofenceMapInitial());
    }
  }

  Future<void> fetchAutoComplete(String input) async {
    if (_isClosed) return;
    
    if (!_isClosed) {
      emit(GpsGeofenceMapLoading());
    }
    
    final result = await repository.getAutoCompleteData(input);
    
    if (_isClosed) return;
    
    if (result is Success<AutoCompleteModel>) {
      if (!_isClosed) {
        emit(GpsGeofenceMapAutoCompleteLoaded(result.value));
      }
    } else if (result is Error) {
      final errorResult = result as Error;
      final errorType = errorResult.type;
      if (!_isClosed) {
        emit(GpsGeofenceMapError(
            errorType is ErrorWithMessage ? errorType.message : "Autocomplete failed"));
      }
    }
  }

  Future<void> verifyLocation(VerifyLocationApiRequest request) async {
    if (_isClosed) return;
    
    if (!_isClosed) {
      emit(GpsGeofenceMapLoading());
    }
    
    final result = await repository.getVerifyLocationData(request);
    
    if (_isClosed) return;
    
    if (result is Success<VerifyLocationModel>) {
      if (!_isClosed) {
        emit(GpsGeofenceMapVerifyLocationLoaded(result.value));
      }
    } else if (result is Error) {
      final errorResult = result as Error;
      final errorType = errorResult.type;
      if (!_isClosed) {
        emit(GpsGeofenceMapError(
            errorType is ErrorWithMessage ? errorType.message : "Verify location failed"));
      }
    }
  }
}
