import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/model/pod_center_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/model/trip_statement_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/service/vp_trip_settlement_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpTripStatementRepository {
  final VpTripStatementService _service;
  VpTripStatementRepository(this._service);

  /// Trip Settlement Repo
  Future<Result<TripStatementResponse>> getTripStatementData(String? loadID) async {
    try {
      return await _service.fetchTripStatement(loadID);
    } catch (e) {
      CustomLog.error(this, "Failed to request trip settlement data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

}