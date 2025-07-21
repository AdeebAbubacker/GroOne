import 'package:gro_one_app/features/terms_and_conditions/model/terms_and_conditions_model.dart';
import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../../../utils/app_string.dart';
import '../../../utils/custom_log.dart';


class TermsAndConditionsService {
  final ApiService _apiService;
  TermsAndConditionsService(this._apiService);

  /// Get Terms And Conditions
  Future<Result<TermsAndconditionsModel>> fetchTermsAndConditionsData() async {
    try {
      final url = ApiUrls.termsAndConditions;

      final result = await _apiService.get(url);
      if (result is Success) {
         final data = TermsAndconditionsModel.fromJson(result.value);
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
