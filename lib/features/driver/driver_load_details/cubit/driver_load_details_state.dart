part of 'driver_load_details_cubit.dart';


class DriverLoadDetailsState extends Equatable {
  final LoadStatus? loadStatus;
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
  final UIState<TrackingDistanceResponse>? trackingDistance;
  final String? locationDistance;
  final int? loadStatusId;

  const DriverLoadDetailsState({
    this.trackingDistance,
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
     this.locationDistance,
     this.loadStatusId,
     this.loadStatus = LoadStatus.assigned,
  });

  DriverLoadDetailsState copyWith({
     UIState<TrackingDistanceResponse>? trackingDistance,
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
     String? locationDistance,
     int? loadStatusId,
     LoadStatus? loadStatus,
  }) {
    return DriverLoadDetailsState(
       trackingDistance: trackingDistance ?? this.trackingDistance,
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
       locationDistance: locationDistance ?? this.locationDistance,
        loadStatusId: loadStatusId?? this.loadStatusId,
        loadStatus: loadStatus ?? this.loadStatus, 
     );
  }

  @override
  List<Object?> get props => [
        loadStatus,
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
         trackingDistance,
          locationDistance,
         loadStatusId,  
      ];
}
