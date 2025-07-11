import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/upload_rc_truck_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/services/vp_details_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/service/vp_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class LoadDetailsRepository {
  final VpDetailsService _vpDetailsService;
  final VpHomeService _vpHomeService;

  LoadDetailsRepository(this._vpDetailsService,this._vpHomeService);

  Future<Result<LoadDetailsResponseModel>> fetchLoadDetails(String? loadId) async {
    try {
      return await _vpDetailsService.fetchLoadDetails(loadId);
    } catch (e) {
      CustomLog.error(this, "Failed to get upload loadData", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<VpLoadAcceptModel>> changeLoadStatus({
    required String customerId,required String loadId,required int? loadStatus}) async {
    try {
      return await _vpDetailsService.changeLoadStatus(
          loadStatus: loadStatus,
          loadId: loadId,userId: customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}