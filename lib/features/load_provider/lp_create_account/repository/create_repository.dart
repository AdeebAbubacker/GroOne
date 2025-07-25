import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/service/create_service.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/api_request/create_request.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/model/lp_company_type_model.dart';


class LpCreateRepository {
  final LpCreateService _lpCreateService;
  final AuthRepository _authRepository;
  LpCreateRepository(this._lpCreateService, this._authRepository);


  /// Create Account Repo
  Future<Result<UserModel?>> getCreateAccountData(LpCreateApiRequest request) async {
    try {
      Result<dynamic> result =  await _lpCreateService.createAccount(request);
      if (result is Success<UserModel?>) {
        if(result.value != null){
          Result saveUserResult = await _authRepository.saveUserInfoFromCreateAccount(result.value!);
          if(saveUserResult is Success){
            return result;
          }
          if(saveUserResult is Error){
            return Error(saveUserResult.type);
          }
        }
      }
      if(result is Error){
        return Error(result.type);
      }
      return Error(GenericError());
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Get Company Type
  Future<Result<List<LpCompanyTypeModel>>> getCompanyTypeData() async {
    try {
      return await _lpCreateService.fetchGetCompanyTypeData();
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}
