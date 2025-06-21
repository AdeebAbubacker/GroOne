import 'package:gro_one_app/features/kyc/enum/kyc_document_type.dart';

class KycHelper {

 static KycStage kycStage(int? isKyc) {
    switch (isKyc) {
      case 3:  return KycStage.done;
      case 2:  return KycStage.inProgress;
      case 0:  return KycStage.none;
      default: return KycStage.unknown;
    }
 }

}