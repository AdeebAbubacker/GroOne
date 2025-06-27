import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/api_request/en-dhan_api_request.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/model/en_dhan_kyc_model.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/model/en_dhan_models.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class EnDhanService {
  final ApiService _apiService;
  
  EnDhanService(this._apiService);

  /// Check KYC Documents Existence
  Future<Result<EnDhanKycCheckModel>> checkKycDocuments(int customerId) async {
    try {
      final url = "${ApiUrls.enDhanKycCheck}/$customerId";
      final result = await _apiService.get(url);
      
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value, 
          (data) => EnDhanKycCheckModel.fromJson(data)
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

  /// Upload KYC Documents
  Future<Result<EnDhanKycModel>> uploadKycDocuments(EnDhanKycApiRequest request) async {
    try {
      final url = ApiUrls.enDhanKycUpload;
      final result = await _apiService.post(url, body: request.toJson());
      
      if (result is Success) {
        return await _apiService.getResponseStatus(
          result.value, 
          (data) => EnDhanKycModel.fromJson(data)
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
