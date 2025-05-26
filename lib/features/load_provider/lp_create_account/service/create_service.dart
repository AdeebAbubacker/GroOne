import 'package:gro_one_app/features/load_provider/lp_create_account/model/lp_company_type_response.dart';

import '../../../../data/model/result.dart';
import '../../../../data/network/api_service.dart';
import '../../../../data/network/api_urls.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/custom_log.dart';
import '../api_request/create_request.dart';
import '../model/create_response.dart';

class LpCreateService {
  final ApiService _apiService;

  LpCreateService(this._apiService);

  Future<Result<CreateResponse>> lpRegister(
    CreateRequest request, {
    required String id,
  }) async
  {
    try {
      final result = await _apiService.put(
        ApiUrls.createLpAccount + id,
        body: request,
      );
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => CreateResponse.fromJson(data),
        );
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<LpCompanyTypeResponse>> getCompanyType() async {
    try {
      final result = await _apiService.get(ApiUrls.companyType);
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value,
          (data) => LpCompanyTypeResponse.fromJson(data),
        );
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }
}
