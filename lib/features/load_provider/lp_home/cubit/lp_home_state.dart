import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/LPGetLoadModel.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/destination_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/pick_up_model.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/rate_discovery_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart';

class LPHomeState extends Equatable {
  final UIState<LoadTruckTypeListModel>? truckTypeUIState;
  final UIState<RecentRoutesModel>? recentRouteUIState;
  final UIState<AutoCompleteModel>? autoCompleteUIState;
  final UIState<VerifyLocationModel>? verifyLocationUIState;
  final UIState<RateDiscoveryModel>? rateDiscoveryUIState;
  final UIState<LoadWeightModel>? loadWeightUIState;
  final UIState<ProfileDetailModel>? profileDetailUIState;
  final UIState<LpGetLoadModel>? lpGetLoadUIState;
  final bool showSuccessKyc;
  final UIState<DestinationModel>? destination;
  final UIState<PickUpModel>? pickup;
  final int? pickupLocationId;
  final int? destinationLocationId;
  final num? laneId;
  final LoadWeightData? selectedWeight;
  final String? matchingText;
  final String? blueId;

  const LPHomeState({
    this.truckTypeUIState,
    this.recentRouteUIState,
    this.autoCompleteUIState,
    this.verifyLocationUIState,
    this.rateDiscoveryUIState,
    this.loadWeightUIState,
    this.profileDetailUIState,
    this.lpGetLoadUIState,
    this.showSuccessKyc = false,
    this.destination,
    this.pickup,
    this.pickupLocationId,
    this.destinationLocationId,
    this.laneId,
    this.selectedWeight,
    this.matchingText,
    this.blueId,
  });

  LPHomeState copyWith({
    UIState<RecentRoutesModel>? recentRouteState,
    UIState<LoadTruckTypeListModel>? truckTypeState,
    UIState<AutoCompleteModel>? autoCompleteUIState,
    UIState<VerifyLocationModel>? verifyLocationUIState,
    UIState<RateDiscoveryModel>? rateDiscoveryUIState,
    UIState<LoadWeightModel>? loadWeightUIState,
    UIState<ProfileDetailModel>? profileDetailUIState,
    UIState<LpGetLoadModel>? getLoadListUIState,
    bool? showSuccessKyc,
    UIState<DestinationModel>? destination,
    UIState<PickUpModel>? pickup,
    int? pickupLocationId,
    int? destinationLocationId,
    num? laneId,
    LoadWeightData? selectedWeight,
    String? matchingText,
    String? blueId,
  }) {
    return LPHomeState(
      truckTypeUIState: truckTypeState ?? this.truckTypeUIState,
      recentRouteUIState: recentRouteState ?? this.recentRouteUIState,
      autoCompleteUIState: autoCompleteUIState ?? this.autoCompleteUIState,
      verifyLocationUIState: verifyLocationUIState ?? this.verifyLocationUIState,
      rateDiscoveryUIState: rateDiscoveryUIState ?? this.rateDiscoveryUIState,
      loadWeightUIState: loadWeightUIState ?? this.loadWeightUIState,
      profileDetailUIState: profileDetailUIState ?? this.profileDetailUIState,
      lpGetLoadUIState: getLoadListUIState ?? this.lpGetLoadUIState,
      showSuccessKyc: showSuccessKyc ?? this.showSuccessKyc,
      destination: destination ?? this.destination,
      pickup: pickup ?? this.pickup,
      pickupLocationId: pickupLocationId ?? this.pickupLocationId,
      destinationLocationId: destinationLocationId ?? this.destinationLocationId,
      laneId: laneId ?? this.laneId,
      selectedWeight: selectedWeight ?? this.selectedWeight,
      matchingText: matchingText ?? this.matchingText,
      blueId: blueId ?? this.blueId,
    );
  }

  @override
  List<Object?> get props => [
    truckTypeUIState,
    recentRouteUIState,
    autoCompleteUIState,
    verifyLocationUIState,
    rateDiscoveryUIState,
    loadWeightUIState,
    profileDetailUIState,
    lpGetLoadUIState,
    showSuccessKyc,
    destination,
    pickup,
    pickupLocationId,
    destinationLocationId,
    laneId,
    selectedWeight,
    matchingText,
    blueId,
  ];
}
