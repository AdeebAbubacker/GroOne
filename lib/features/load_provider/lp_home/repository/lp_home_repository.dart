import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/service/lp_home_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class LpHomeRepository{
  final LpHomeService _lpHomeService;
  LpHomeRepository(this._lpHomeService);
  Future<Result<ProfileDetailResponse>> getUserDetails({required String userId}) async {
    try {
      return await _lpHomeService.getProfileDetails(id: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}