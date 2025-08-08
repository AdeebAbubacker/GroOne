import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/terms_and_conditions/model/terms_and_conditions_model.dart';
import 'package:gro_one_app/features/terms_and_conditions/service/terms_and_conditions_service.dart';

class TAndCRepository{
  final TermsAndConditionsService _termsAndConditionsService;
  TAndCRepository(this._termsAndConditionsService);

  /// Get Terms and Conditions Repo
  Future<Result<TermsAndConditionsModel>> getTermsAndConditionsData() async {
    try {
      return await _termsAndConditionsService.fetchTermsAndConditionsData();
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}