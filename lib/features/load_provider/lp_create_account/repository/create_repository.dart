import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/api_request/create_request.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/model/create_response.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/model/lp_company_type_response.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/service/create_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class LpCreateRepository {
  final LpCreateService _lpCreateService;

  LpCreateRepository(this._lpCreateService);

  Future<Result<CreateResponse>> lpCreateRegistration(
    CreateRequest request, {
    required String id,
  }) async {
    try {
      return await _lpCreateService.lpRegister(request, id: id);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpCompanyTypeResponse>> getCompanyType(
   ) async {
    try {
      return await _lpCreateService.getCompanyType();
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
