import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';

abstract class VpLoadState {}

class VpLoadInitial extends VpLoadState {}

class VpLoadLoading extends VpLoadState {}

class VpLoadLoaded extends VpLoadState {
  final List<VpRecentLoadData> loads;
  VpLoadLoaded(this.loads);
}

class VpLoadError extends VpLoadState {
  final String message;
  VpLoadError(this.message);
}
