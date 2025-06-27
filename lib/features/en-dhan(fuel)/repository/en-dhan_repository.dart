import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/api_request/en-dhan_api_request.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/model/en_dhan_kyc_model.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/model/en_dhan_models.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/service/en-dhan_services.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class EnDhanRepository {
  final EnDhanService _enDhanService;
  
  EnDhanRepository(this._enDhanService);

  /// Check KYC Documents Repository
  Future<Result<EnDhanKycCheckModel>> checkKycDocuments(int customerId) async {
    try {
      return await _enDhanService.checkKycDocuments(customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to check KYC documents", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Upload KYC Documents Repository
  Future<Result<EnDhanKycModel>> uploadKycDocuments(EnDhanKycApiRequest request) async {
    try {
      return await _enDhanService.uploadKycDocuments(request);
    } catch (e) {
      CustomLog.error(this, "Failed to upload KYC documents", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
