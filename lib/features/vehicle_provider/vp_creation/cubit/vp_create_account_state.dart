part of 'vp_create_account_cubit.dart';

class VpCreateAccountState extends Equatable {
  final UIState<UserModel?>? createAccountUIState;
  final UIState<List<VpCompanyTypeModel>>? companyTypeUIState;
  final UIState<List<TruckTypeModel>>? truckTypeUIState;
  final UIState<TruckPrefLaneModel>? prefLaneUIState;
  final UIState<UploadRcTruckFileModel>? uploadRcFileUIState;
  const VpCreateAccountState({
    this.createAccountUIState,
    this.companyTypeUIState,
    this.truckTypeUIState,
    this.prefLaneUIState,
    this.uploadRcFileUIState,
  });

  VpCreateAccountState copyWith({
    UIState<UserModel?>? createAccountUIState,
    UIState<List<VpCompanyTypeModel>>? companyTypeUIState,
    UIState<List<TruckTypeModel>>? truckTypeUIState,
    UIState<TruckPrefLaneModel>? prefLaneUIState,
    UIState<UploadRcTruckFileModel>? uploadRcFileUIState,
  }) {
    return VpCreateAccountState(
      createAccountUIState: createAccountUIState ?? this.createAccountUIState,
      companyTypeUIState: companyTypeUIState ?? this.companyTypeUIState,
      truckTypeUIState: truckTypeUIState ?? this.truckTypeUIState,
      prefLaneUIState: prefLaneUIState ?? this.prefLaneUIState,
      uploadRcFileUIState: uploadRcFileUIState ?? this.uploadRcFileUIState,
    );
  }

  @override
  List<Object?> get props => [
    createAccountUIState,
    companyTypeUIState,
    truckTypeUIState,
    prefLaneUIState,
    uploadRcFileUIState
  ];
}
