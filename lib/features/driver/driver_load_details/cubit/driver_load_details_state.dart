part of 'driver_load_details_cubit.dart';


class DriverLoadDetailsState extends Equatable {
  final UIState<DriverLoadDetailsModel>? lpLoadById;
  final UIState<UploadDamageFileModel>? uploadDamageUIState;
  final UIState<GetDamageListModel>? damageListUIState;
  final UIState<VpLoadAcceptModel>? loadStatusUIState;
  final bool? isUpdateDamage;

  const DriverLoadDetailsState({
    this.lpLoadById,
    this.uploadDamageUIState,
    this.damageListUIState,
     this.loadStatusUIState,
    this.isUpdateDamage,
  });

  DriverLoadDetailsState copyWith({
    UIState<DriverLoadDetailsModel>? lpLoadById,
    UIState<UploadDamageFileModel>? uploadDamageUIState,
    UIState<GetDamageListModel>? damageListUIState,
    UIState<VpLoadAcceptModel>? loadStatusUiUpdate,
    bool? isUpdateDamage,
  }) {
    return DriverLoadDetailsState(
      lpLoadById: lpLoadById ?? this.lpLoadById,
      uploadDamageUIState: uploadDamageUIState ?? this.uploadDamageUIState,
      damageListUIState: damageListUIState ?? this.damageListUIState,
      isUpdateDamage: isUpdateDamage ?? this.isUpdateDamage,
      loadStatusUIState: loadStatusUiUpdate ?? this.loadStatusUIState
    );
  }

  @override
  List<Object?> get props => [
        lpLoadById,
        uploadDamageUIState,
        damageListUIState,
        isUpdateDamage,
        loadStatusUIState,
      ];
}
