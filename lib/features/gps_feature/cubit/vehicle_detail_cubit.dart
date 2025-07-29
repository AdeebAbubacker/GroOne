import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'vehicle_detail_event.dart';
part 'vehicle_detail_state.dart';

class VehicleDetailCubit extends Cubit<VehicleDetailState> {
  bool _isClosed = false;
  
  VehicleDetailCubit() : super(const VehicleDetailState());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(const VehicleDetailState());
  }

  void toggleTraffic() {
    if (!_isClosed) {
      emit(state.copyWith(trafficEnabled: !state.trafficEnabled));
    }
  }

  void toggleMapType() {
    if (!_isClosed) {
      final newMapType =
          state.mapType == MapType.normal ? MapType.satellite : MapType.normal;
      emit(state.copyWith(mapType: newMapType));
    }
  }
}
