import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/terms_and_conditions/model/terms_and_conditions_model.dart';
import 'package:gro_one_app/features/terms_and_conditions/service/terms_and_conditions_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class TAndCRepository{
  final TermsAndConditionsService _termsAndConditionsService;
  TAndCRepository(this._termsAndConditionsService);

  /// Get Terms and Conditions Repo
  Future<Result<TermsAndconditionsModel>> getTermsAndConditionsData() async {
    try {
      return await _termsAndConditionsService.fetchTermsAndConditionsData();
    } catch (e) {
      CustomLog.error(this, "Failed to request get load weight data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}