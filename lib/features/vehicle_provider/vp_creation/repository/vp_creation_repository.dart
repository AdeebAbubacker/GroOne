import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/service/vp_creation_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class VpCreationRepository {
  final VpCreationService _vpCreationService;
  VpCreationRepository(this._vpCreationService);

  Future<Result<VpCreationModel>> requestSignIn(VpCreationApiRequest request) async {
    try {
      return await _vpCreationService.fetchVpCreationData(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request vp creation", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}