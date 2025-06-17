import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/destination_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/pick_up_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/rate_discovery_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart';

class LPHomeState extends Equatable {
  final UIState<LoadTruckTypeListModel>? truckTypeUIState;
  final UIState<RecentRoutesModel>? recentRouteUIState;
  final UIState<AutoCompleteModel>? autoCompleteUIState;
  final UIState<VerifyLocationModel>? verifyLocationUIState;
  final UIState<RateDiscoveryModel>? rateDiscoveryUIState;
  final bool showSuccessKyc;
  final UIState<DestinationModel>? destination;
  final UIState<PickUpModel>? pickup;
  final num? locationId;
  final num? laneId;
  const LPHomeState({
    this.truckTypeUIState,
    this.recentRouteUIState,
    this.autoCompleteUIState,
    this.verifyLocationUIState,
    this.rateDiscoveryUIState,
    this.showSuccessKyc = false,
    this.destination,
    this.pickup,
    this.locationId,
    this.laneId,
  });

  LPHomeState copyWith({
    UIState<RecentRoutesModel>? recentRouteState,
    UIState<LoadTruckTypeListModel>? truckTypeState,
    UIState<AutoCompleteModel>? autoCompleteUIState,
    UIState<VerifyLocationModel>? verifyLocationUIState,
    UIState<RateDiscoveryModel>? rateDiscoveryUIState,
    bool? showSuccessKyc,
    UIState<DestinationModel>? destination,
    UIState<PickUpModel>? pickup,
    num? locationId,
    num? laneId,
  }) {
    return LPHomeState(
      truckTypeUIState: truckTypeState ?? this.truckTypeUIState,
      recentRouteUIState: recentRouteState ?? this.recentRouteUIState,
      autoCompleteUIState: autoCompleteUIState ?? this.autoCompleteUIState,
      verifyLocationUIState: verifyLocationUIState ?? this.verifyLocationUIState,
      rateDiscoveryUIState: rateDiscoveryUIState ?? this.rateDiscoveryUIState,
      showSuccessKyc: showSuccessKyc ?? this.showSuccessKyc,
      destination: destination ?? this.destination,
      pickup: pickup ?? this.pickup,
      locationId: locationId ?? this.locationId,
      laneId: laneId ?? this.laneId,
    );
  }

  @override
  List<Object?> get props => [
    truckTypeUIState,
    recentRouteUIState,
    autoCompleteUIState,
    verifyLocationUIState,
    rateDiscoveryUIState,
    showSuccessKyc,
    destination,
    pickup,
    locationId,
    laneId
  ];
}
