import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/api_request/create_request.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/model/lp_company_type_model.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/repository/create_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';

part 'lp_create_account_state.dart';

class LpCreateAccountCubit extends BaseCubit<LpCreateAccountState> {
  final LpCreateRepository _repository;
  LpCreateAccountCubit(this._repository) : super(LpCreateAccountState());

  // Create Account Api Call
  void _setSendOtpUIState(UIState<UserModel?>? uiState){
    emit(state.copyWith(createAccountUIState: uiState));
  }
  Future<void> createAccount(LpCreateApiRequest req) async {
    _setSendOtpUIState(UIState.loading());
    Result result = await _repository.getCreateAccountData(req);
    if (result is Success<UserModel?>) {
      _setSendOtpUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setSendOtpUIState(UIState.error(result.type));
    }
  }


  // Fetch company type Api Call
  void _setCompanyTypeUIState(UIState<List<LpCompanyTypeModel>>? uiState){
    emit(state.copyWith(companyTypeUIState: uiState));
  }
  Future<void> fetchCompanyType() async {
    _setCompanyTypeUIState(UIState.loading());
    Result result = await _repository.getCompanyTypeData();
    if (result is Success<List<LpCompanyTypeModel>>) {
      _setCompanyTypeUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCompanyTypeUIState(UIState.error(result.type));
    }
  }



  // Reset UI
  void resetState(){
    emit(state.copyWith(
      createAccountUIState: resetUIState<UserModel?>(state.createAccountUIState),
      companyTypeUIState: resetUIState<List<LpCompanyTypeModel>>(state.companyTypeUIState),
    ));
  }



}
