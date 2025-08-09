import 'package:gro_one_app/features/load_provider/lp_loads/model/load_status_response.dart';
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

class VPLoadStatusInitial extends VpLoadState {}

class VPLoadStatusLoading extends VpLoadState {}

class VPLoadStatusLoaded extends VpLoadState {
  final List<LoadStatusResponse> statuses;
  VPLoadStatusLoaded(this.statuses);
}

class VPLoadStatusError extends VpLoadState {
  final String message;
  VPLoadStatusError(this.message);
}