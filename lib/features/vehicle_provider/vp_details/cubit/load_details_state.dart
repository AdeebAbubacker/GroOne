import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';

class LoadDetailsState extends Equatable {
  final LoadStatus? loadStatus;

  final UIState<LoadDetailsResponseModel>? loadDetailsUIState;
  final UIState<VpLoadAcceptModel>? vpLoadStatus;
  final UIState<ScheduleTripResponse>? scheduleTripResponse;
  final String? possibleDeliveryDate;


  const LoadDetailsState({
    this.scheduleTripResponse,
    this.loadStatus=LoadStatus.matching, this.loadDetailsUIState,this.vpLoadStatus,this.possibleDeliveryDate});

  LoadDetailsState copyWith({
    UIState<VpLoadAcceptModel>? vpLoadStatus,
    LoadStatus? loadStatus,
    UIState<LoadDetailsResponseModel>? loadDetailsUIState,
    UIState<ScheduleTripResponse>? scheduleTripResponse,
    String? possibleDeliveryDate
  }) {
    return LoadDetailsState(

        scheduleTripResponse:scheduleTripResponse?? this.scheduleTripResponse ,
        vpLoadStatus: vpLoadStatus ?? this.vpLoadStatus,
        loadStatus: loadStatus ?? this.loadStatus,
        loadDetailsUIState: loadDetailsUIState ?? this.loadDetailsUIState,
        possibleDeliveryDate: possibleDeliveryDate ?? this.possibleDeliveryDate,

    );
  }

  @override
  List<Object?> get props => [loadStatus, loadDetailsUIState,vpLoadStatus,possibleDeliveryDate,
    scheduleTripResponse
  ];
}
