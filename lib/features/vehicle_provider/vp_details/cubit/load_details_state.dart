import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/direction_api_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';

class LoadDetailsState extends Equatable {
  final LoadStatus? loadStatus;

  final UIState<LoadDetailsResponseModel>? loadDetailsUIState;
  final UIState<VpLoadAcceptModel>? vpLoadStatus;
  final UIState<DirectionResponse>? directionApiResponse;
  final UIState<ScheduleTripResponse>? scheduleTripResponse;
  final String? possibleDeliveryDate;
  final String? locationDistance;
  final int? loadStatusId;

  const LoadDetailsState({
    this.directionApiResponse,
    this.scheduleTripResponse,
    this.locationDistance,
    this.loadStatus = LoadStatus.matching,
    this.loadDetailsUIState,
    this.vpLoadStatus,
    this.possibleDeliveryDate,
    this.loadStatusId,
  });

  LoadDetailsState copyWith({
    UIState<VpLoadAcceptModel>? vpLoadStatus,
    LoadStatus? loadStatus,
    String? loadDetails,
    UIState<DirectionResponse>? directionApiResponse,
    UIState<LoadDetailsResponseModel>? loadDetailsUIState,
    UIState<ScheduleTripResponse>? scheduleTripResponse,
    String? possibleDeliveryDate,
    String? locationDistance,
    int? loadStatusId
  }) {
    return LoadDetailsState(
      loadStatusId: loadStatusId?? this.loadStatusId,
      directionApiResponse: directionApiResponse ?? this.directionApiResponse,
      locationDistance: locationDistance ?? this.locationDistance,
      scheduleTripResponse: scheduleTripResponse ?? this.scheduleTripResponse,
      vpLoadStatus: vpLoadStatus ?? this.vpLoadStatus,
      loadStatus: loadStatus ?? this.loadStatus,
      loadDetailsUIState: loadDetailsUIState ?? this.loadDetailsUIState,
      possibleDeliveryDate: possibleDeliveryDate ?? this.possibleDeliveryDate,
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
    loadStatusId
  ];
}
