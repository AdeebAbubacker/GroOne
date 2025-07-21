import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/privacy_policy/model/privacy_policy_model.dart';
import 'package:gro_one_app/features/privacy_policy/service/privacy_policy_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class PrivacyRepository{
  final PrivacyPolicyService _privacyPolicyService;
  PrivacyRepository(this._privacyPolicyService);

  /// Get Privacy Policy Repo
  Future<Result<PrivacyDetailsModel>> getPrivacyPolicyData() async {
    try {
      return await _privacyPolicyService.fetchPrivacyPolicy();
    } catch (e) {
      CustomLog.error(this, "Failed to request get load weight data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}