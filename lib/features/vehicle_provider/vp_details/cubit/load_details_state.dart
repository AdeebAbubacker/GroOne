import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/tracking_distance_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/get_damage_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/upload_damage_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/direction_api_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';

class LoadDetailsState extends Equatable {
  final LoadStatus? loadStatus;
  final UIState<LoadDetailModel>? loadDetailsUIState;
  final UIState<VpLoadAcceptModel>? vpLoadStatus;
  final UIState<DirectionResponse>? directionApiResponse;
  final UIState<ScheduleTripResponse>? scheduleTripResponse;
  final UIState<DamageModel>? settlementUIState;
  final UIState<DamageModel>? createDamageUIState;
  final UIState<DamageModel>? editDamageUIState;
  final UIState<DamageModel>? deleteDamageUIState;
  final String? possibleDeliveryDate;
  final String? locationDistance;
  final UIState<UploadDamageFileModel>? uploadDamageUIState;
  final UIState<GetDamageListModel>? damageListUIState;
  final List<DocumentEntity>? tripDocumentList ;
  final UIState<TrackingDistanceResponse>? trackingDistance;
  final int? loadStatusId;

  const LoadDetailsState({
    this.trackingDistance,
    this.directionApiResponse,
    this.scheduleTripResponse,
    this.locationDistance,
    this.loadStatus = LoadStatus.matching,
    this.loadDetailsUIState,
    this.createDamageUIState,
    this.settlementUIState,
    this.editDamageUIState,
    this.deleteDamageUIState,
    this.vpLoadStatus,
    this.possibleDeliveryDate,
    this.loadStatusId,
    this.uploadDamageUIState,
    this.damageListUIState,
    this.tripDocumentList
  });

  LoadDetailsState copyWith({
    UIState<TrackingDistanceResponse>? trackingDistance,
    UIState<VpLoadAcceptModel>? vpLoadStatus,
    LoadStatus? loadStatus,
    String? loadDetails,
    UIState<DirectionResponse>? directionApiResponse,
    UIState<LoadDetailModel>? loadDetailsUIState,
    UIState<ScheduleTripResponse>? scheduleTripResponse,
    UIState<DamageModel>? settlementUIState,
    UIState<DamageModel>? createDamageUIState,
    UIState<DamageModel>? editDamageUIState,
    UIState<DamageModel>? deleteDamageUIState,
    String? possibleDeliveryDate,
    String? locationDistance,
    int? loadStatusId,
    UIState<UploadDamageFileModel>? uploadDamageUIState,
    UIState<GetDamageListModel>? damageListUIState,
    List<DocumentEntity>? tripDocumentList

  }) {
    return LoadDetailsState(
      trackingDistance: trackingDistance ?? this.trackingDistance,
      tripDocumentList:tripDocumentList?? this.tripDocumentList ,
      loadStatusId: loadStatusId?? this.loadStatusId,
      directionApiResponse: directionApiResponse ?? this.directionApiResponse,
      locationDistance: locationDistance ?? this.locationDistance,
      scheduleTripResponse: scheduleTripResponse ?? this.scheduleTripResponse,
      vpLoadStatus: vpLoadStatus ?? this.vpLoadStatus,
      loadStatus: loadStatus ?? this.loadStatus,
      settlementUIState : settlementUIState ?? this.settlementUIState,
      createDamageUIState: createDamageUIState ?? this.createDamageUIState,
      editDamageUIState: editDamageUIState ?? this.editDamageUIState,
      deleteDamageUIState: deleteDamageUIState ?? this.deleteDamageUIState,
      loadDetailsUIState: loadDetailsUIState ?? this.loadDetailsUIState,
      possibleDeliveryDate: possibleDeliveryDate ?? this.possibleDeliveryDate,
      uploadDamageUIState: uploadDamageUIState ?? this.uploadDamageUIState,
      damageListUIState: damageListUIState ?? this.damageListUIState,
    );
  }

  @override
  List<Object?> get props => [
    loadStatus,
    loadDetailsUIState,
    vpLoadStatus,
    possibleDeliveryDate,
    scheduleTripResponse,
    directionApiResponse,
    settlementUIState,
    loadStatusId,
    createDamageUIState,
    editDamageUIState,
    deleteDamageUIState,
    uploadDamageUIState,
    locationDistance,
    damageListUIState,
    tripDocumentList,
    trackingDistance
  ];

}


