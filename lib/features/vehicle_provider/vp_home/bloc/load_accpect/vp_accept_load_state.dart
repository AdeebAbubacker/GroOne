import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';

sealed class VpAcceptLoadState {}

final class VpAcceptLoadInitial extends VpAcceptLoadState {}

class VpAcceptLoadLoading extends VpAcceptLoadState {}

class VpAcceptLoadError extends VpAcceptLoadState {
  final ErrorType errorType;
  VpAcceptLoadError(this.errorType);
}

class VpAcceptLoadSuccess extends VpAcceptLoadState {
  final VpLoadAcceptModel vpLoadAcceptModel;
  VpAcceptLoadSuccess(this.vpLoadAcceptModel);
}