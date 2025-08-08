import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/terms_and_conditions/model/terms_and_conditions_model.dart';



class TermsAndConditionsService {
  final ApiService _apiService;
  TermsAndConditionsService(this._apiService);

  /// Get Terms And Conditions
  Future<Result<TermsAndConditionsModel>> fetchTermsAndConditionsData() async {
    try {
      final url = ApiUrls.termsAndConditions;

      final result = await _apiService.get(url);
      if (result is Success) {
         final data = TermsAndConditionsModel.fromJson(result.value);
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
