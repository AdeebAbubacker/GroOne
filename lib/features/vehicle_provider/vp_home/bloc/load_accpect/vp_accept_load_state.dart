import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';

sealed class VpAcceptLoadState {
  Set<String>? loadingLoadIds;

  VpAcceptLoadState({this.loadingLoadIds});
}

final class VpAcceptLoadInitial extends VpAcceptLoadState {
  Set<String>? ids;
  VpAcceptLoadInitial({this.ids}) : super(loadingLoadIds: ids);
}

class VpAcceptLoadLoading extends VpAcceptLoadState {
  Set<String>? ids;
  VpAcceptLoadLoading(this.ids) : super(loadingLoadIds: ids);
}

class VpAcceptLoadError extends VpAcceptLoadState {
  final ErrorType errorType;
  Set<String>? ids;
  VpAcceptLoadError(this.errorType,this.ids) : super(loadingLoadIds:ids );
}

class VpAcceptLoadSuccess extends VpAcceptLoadState {
  final VpLoadAcceptModel vpLoadAcceptModel;
  Set<String>? ids;
  VpAcceptLoadSuccess(this.vpLoadAcceptModel,this.ids) : super(loadingLoadIds: ids);
}
