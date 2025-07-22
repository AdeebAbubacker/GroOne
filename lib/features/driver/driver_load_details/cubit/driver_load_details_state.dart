// part of 'driver_load_details_cubit.dart';


// class DriverLoadDetailsState extends Equatable {
//   final UIState<DriverLoadDetailsModel>? lpLoadByUIState;
//   final UIState<UploadDamageFileModel>? uploadDamageUIState;
//   final UIState<GetDamageListModel>? damageListUIState;
//   final UIState<VpLoadAcceptModel>? loadStatusUIState;
//   final bool? isUpdateDamage;

//   const DriverLoadDetailsState({
//     this.lpLoadByUIState,
//     this.uploadDamageUIState,
//     this.damageListUIState,
//      this.loadStatusUIState,
//     this.isUpdateDamage,
//   });

//   DriverLoadDetailsState copyWith({
//     UIState<DriverLoadDetailsModel>? lpLoadById,
//     UIState<UploadDamageFileModel>? uploadDamageUIState,
//     UIState<GetDamageListModel>? damageListUIState,
//     UIState<VpLoadAcceptModel>? loadStatusUiUpdate,
//     bool? isUpdateDamage,
//   }) {
//     return DriverLoadDetailsState(
//       lpLoadByUIState: lpLoadById ?? this.lpLoadByUIState,
//       uploadDamageUIState: uploadDamageUIState ?? this.uploadDamageUIState,
//       damageListUIState: damageListUIState ?? this.damageListUIState,
//       isUpdateDamage: isUpdateDamage ?? this.isUpdateDamage,
//       loadStatusUIState: loadStatusUiUpdate ?? this.loadStatusUIState
//     );
//   }

//   @override
//   List<Object?> get props => [
//         lpLoadById,
//         uploadDamageUIState,
//         damageListUIState,
//         isUpdateDamage,
//         loadStatusUIState,
//       ];
// }


part of 'driver_load_details_cubit.dart';


class DriverLoadDetailsState extends Equatable {
  final UIState<DriverLoadDetailsModel>? lpLoadById;
  final UIState<UploadDamageFileModel>? uploadDamageUIState;
  final UIState<GetDamageListModel>? damageListUIState;
  final UIState<VpLoadAcceptModel>? loadStatusUIState;
  final UIState<DeleteDamageModel>? deleteDamageUIState;
  final bool? isUpdateDamage;
  final List<DocumentEntity>? tripDocumentList ;
  final UIState<DamageModel>? createDamageUIState;
  final UIState<DamageModel>? settlementUIState;
  final UIState<UpdateDamageModel>? updateDamageUIState;

  const DriverLoadDetailsState({
    this.lpLoadById,
    this.uploadDamageUIState,
    this.damageListUIState,
     this.loadStatusUIState,
    this.isUpdateDamage,
     this.tripDocumentList,
     this.deleteDamageUIState,
     this.createDamageUIState,
     this.settlementUIState,
     this.updateDamageUIState,
  });

  DriverLoadDetailsState copyWith({
    UIState<DriverLoadDetailsModel>? lpLoadById,
    UIState<UploadDamageFileModel>? uploadDamageUIState,
    UIState<GetDamageListModel>? damageListUIState,
    UIState<VpLoadAcceptModel>? loadStatusUiUpdate,
    UIState<DeleteDamageModel>? deleteDamageUIState,
    List<DocumentEntity>? tripDocumentList,
     UIState<DamageModel>? createDamageUIState,
     UIState<DamageModel>? settlementUIState,
     UIState<UpdateDamageModel>? updateDamageUIState,
    bool? isUpdateDamage,
  }) {
    return DriverLoadDetailsState(
      lpLoadById: lpLoadById ?? this.lpLoadById,
      uploadDamageUIState: uploadDamageUIState ?? this.uploadDamageUIState,
      damageListUIState: damageListUIState ?? this.damageListUIState,
      isUpdateDamage: isUpdateDamage ?? this.isUpdateDamage,
      loadStatusUIState: loadStatusUiUpdate ?? this.loadStatusUIState,
      tripDocumentList:tripDocumentList?? this.tripDocumentList ,
       deleteDamageUIState: deleteDamageUIState ?? this.deleteDamageUIState,
       createDamageUIState: createDamageUIState ?? this.createDamageUIState,
       settlementUIState : settlementUIState ?? this.settlementUIState,
       updateDamageUIState: updateDamageUIState ?? this.updateDamageUIState,
    );
  }

  @override
  List<Object?> get props => [
        lpLoadById,
        uploadDamageUIState,
        damageListUIState,
        isUpdateDamage,
        loadStatusUIState,
        tripDocumentList,
        deleteDamageUIState,
        createDamageUIState,
        settlementUIState,
        updateDamageUIState,
      ];
}
