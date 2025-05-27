import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/api_request/create_request.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/model/lp_company_type_response.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/service/create_service.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';

import '../../../vehicle_provider/vp_creation/model/vp_creation_model.dart';
import '../model/create_response.dart';

class LpCreateRepository {
  final LpCreateService _lpCreateService;
  final AuthRepository _authRepository;
  LpCreateRepository(this._lpCreateService, this._authRepository);

  // Future<Result<UserModel?>> lpCreateRegistration(
  //   CreateRequest request, {
  //   required String id,
  // }) async {
  //   try {
  //     Result<dynamic> result =  await _lpCreateService.lpRegister(request,id: id);
  //     if (result is Success<UserModel?>) {
  //       if(result.value != null){
  //         Result saveUserResult = await _authRepository.saveUserInfoFromCreateAccount(result.value!);
  //         if(saveUserResult is Success){
  //           return result;
  //         }
  //         if(saveUserResult is Error){
  //           return Error(saveUserResult.type);
  //         }
  //       }
  //     }
  //     if(result is Error){
  //       return Error(result.type);
  //     }
  //
  //     return Error(GenericError());
  //
  //
  //
  //   } catch (e) {
  //     CustomLog.error(this, "Failed to request Login In", e);
  //     return Error(ErrorWithMessage(message: e.toString()));
  //   }
  // }

  Future<Result<UserModel?>> lpCreateRegistration(CreateRequest request,{required String id}) async {
    try {
      Result<dynamic> result =  await _lpCreateService.lpRegister(request,id: id);
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
      CustomLog.error(this, "Failed to request vp creation", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }






  Future<Result<LpCompanyTypeResponse>> getCompanyType(
   ) async {
    try {
      return await _lpCreateService.getCompanyType();
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
