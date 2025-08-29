part of 'vp_create_account_cubit.dart';

class VpCreateAccountState extends Equatable {
  final UIState<UserModel?>? createAccountUIState;
  final UIState<List<VpCompanyTypeModel>>? companyTypeUIState;
  final UIState<List<TruckTypeModel>>? truckTypeUIState;
  final UIState<TruckPrefLaneModel>? prefLaneUIState;
  final UIState<UploadRcTruckFileModel>? uploadRcFileUIState;
  final List<Item>? selectedPreferLanes;
  final int? currentPage;
  const VpCreateAccountState({
    this.createAccountUIState,
    this.companyTypeUIState,
    this.truckTypeUIState,
    this.prefLaneUIState,
    this.uploadRcFileUIState,
    this.currentPage=1,
    this.selectedPreferLanes,

  });

  VpCreateAccountState copyWith({
    UIState<UserModel?>? createAccountUIState,
    UIState<List<VpCompanyTypeModel>>? companyTypeUIState,
    UIState<List<TruckTypeModel>>? truckTypeUIState,
    UIState<TruckPrefLaneModel>? prefLaneUIState,
    UIState<UploadRcTruckFileModel>? uploadRcFileUIState,
    List<Item>? selectedPreferLanes,
    int? currentPage
  }) {
    return VpCreateAccountState(
      selectedPreferLanes: selectedPreferLanes??this.selectedPreferLanes,
      currentPage: currentPage ?? this.currentPage,
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
    uploadRcFileUIState,
    currentPage,
    selectedPreferLanes
  ];
}
