import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/destination_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/pick_up_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart';

class LPHomeState extends Equatable {
  final UIState<LoadTruckTypeListModel>? truckTypeUIState;
  final UIState<RecentRoutesModel>? recentRouteUIState;
  final UIState<AutoCompleteModel>? autoCompleteUIState;
  final UIState<VerifyLocationModel>? verifyLocationUIState;
  final bool showSuccessKyc;
  final DestinationModel? destination;
  final PickUpModel? pickup;
  const LPHomeState({
    this.truckTypeUIState,
    this.recentRouteUIState,
    this.autoCompleteUIState,
    this.verifyLocationUIState,
    this.showSuccessKyc = false,
    this.destination,
    this.pickup,
  });

  LPHomeState copyWith({
    UIState<RecentRoutesModel>? recentRouteState,
    UIState<LoadTruckTypeListModel>? truckTypeState,
    UIState<AutoCompleteModel>? autoCompleteUIState,
    UIState<VerifyLocationModel>? verifyLocationUIState,
    bool? showSuccessKyc,
    DestinationModel? destination,
    PickUpModel? pickup,
  }) {
    return LPHomeState(
      truckTypeUIState: truckTypeState ?? this.truckTypeUIState,
      recentRouteUIState: recentRouteState ?? this.recentRouteUIState,
      autoCompleteUIState: autoCompleteUIState ?? this.autoCompleteUIState,
      verifyLocationUIState: verifyLocationUIState ?? this.verifyLocationUIState,
      showSuccessKyc: showSuccessKyc ?? this.showSuccessKyc,
      destination: destination ?? this.destination,
      pickup: pickup ?? this.pickup,
    );
  }

  @override
  List<Object?> get props => [
    truckTypeUIState,
    recentRouteUIState,
    autoCompleteUIState,
    verifyLocationUIState,
    showSuccessKyc,
    destination,
    pickup,
  ];
}
