import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/api_request/create_request.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/model/lp_company_type_model.dart';



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
      return Error(DeserializationError());
    }
  }


Future<Result<List<LpCompanyTypeModel>>> fetchGetCompanyTypeData() async {
  try {
    // Add debugging for company-type API call
    print('🔐 LP Company Type API: Starting API call to ${ApiUrls.companyType}');
    
    // Check if token is available before making the API call
    bool hasToken = await _apiService.hasValidToken();
    print('🔐 LP Company Type API: Token available: $hasToken');
    
    if (!hasToken) {
      print('🔐 LP Company Type API: No token available - API call may fail');
    }
    
    final result = await _apiService.get(ApiUrls.companyType);
    
    if (result is Success) {
      print('🔐 LP Company Type API: Success response received');
      final responseData = result.value;
      if (responseData is List) {
        final companyTypes = responseData.map((e) => LpCompanyTypeModel.fromJson(e)).toList();
        print('🔐 LP Company Type API: Parsed ${companyTypes.length} company types');
        return Success(companyTypes);
      } else {
        print('🔐 LP Company Type API: Response is not a list');
        return Error(DeserializationError());
      }
    } else if (result is Error) {
      print('🔐 LP Company Type API: Error response - ${result.type}');
      return Error(result.type);
    } else {
      print('🔐 LP Company Type API: Unknown response type');
      return Error(GenericError());
    }
  } catch (e) {
    print('🔐 LP Company Type API: Exception caught - $e');
    return Error(DeserializationError());
  }
}

}
