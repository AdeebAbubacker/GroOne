import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/model/pod_center_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/service/vp_trip_settlement_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpTripSettlementRepository {
  final VpTripSettlementService _service;
  VpTripSettlementRepository(this._service);

  /// Trip Settlement Repo
  Future<Result<PodCenterListModel>> getTripSettlementData() async {
    try {
      return await _service.fetchTripSettlement();
    } catch (e) {
      CustomLog.error(this, "Failed to request trip settlement data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

}