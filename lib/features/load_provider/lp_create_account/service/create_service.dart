import 'package:gro_one_app/features/load_provider/lp_create_account/model/lp_company_type_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';

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

  Future<Result<UserModel?>> createAccount(LpCreateApiRequest request) async {
    try {
      final url = ApiUrls.createLpAccount;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        final data = UserModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


Future<Result<List<LpCompanyTypeModel>>> fetchGetCompanyTypeData() async {
  try {
    final result = await _apiService.get(ApiUrls.companyType);
    if (result is Success) {
      final responseData = result.value;
      if (responseData is List) {
        final companyTypes = responseData.map((e) => LpCompanyTypeModel.fromJson(e)).toList();
        return Success(companyTypes);
      } else {
        return Error(DeserializationError());
      }
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
