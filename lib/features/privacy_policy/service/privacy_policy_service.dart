import 'package:gro_one_app/features/privacy_policy/model/privacy_policy_model.dart';
import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../../../utils/app_string.dart';
import '../../../utils/custom_log.dart';


class PrivacyPolicyService {
  final ApiService _apiService;
  PrivacyPolicyService(this._apiService);

  /// Get Privacy Policy
  Future<Result<PrivacyDetailsModel>> fetchPrivacyPolicy() async {
    try {
      final url = ApiUrls.privacyPolicy;
      final result = await _apiService.get(url);
      if (result is Success) {
         final data = PrivacyDetailsModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }
}
