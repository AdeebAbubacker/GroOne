import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'vehicle_detail_event.dart';
part 'vehicle_detail_state.dart';

class VehicleDetailCubit extends Cubit<VehicleDetailState> {
  VehicleDetailCubit() : super(const VehicleDetailState());

  void toggleTraffic() {
    emit(state.copyWith(trafficEnabled: !state.trafficEnabled));
  }

  void toggleMapType() {
    final newMapType =
        state.mapType == MapType.normal ? MapType.satellite : MapType.normal;
    emit(state.copyWith(mapType: newMapType));
  }
}
