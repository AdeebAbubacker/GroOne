part of 'lp_create_account_cubit.dart';

class LpCreateAccountState extends Equatable {
  final UIState<UserModel?>? createAccountUIState;
  final UIState<List<LpCompanyTypeModel>>? companyTypeUIState;
  const LpCreateAccountState({this.createAccountUIState, this.companyTypeUIState});

  LpCreateAccountState copyWith({
    UIState<UserModel?>? createAccountUIState,
    UIState<List<LpCompanyTypeModel>>? companyTypeUIState,
  }) {
    return LpCreateAccountState(
      createAccountUIState: createAccountUIState ?? this.createAccountUIState,
      companyTypeUIState: companyTypeUIState ?? this.companyTypeUIState,
    );
  }

  @override
  List<Object?> get props => [createAccountUIState, companyTypeUIState];
}


