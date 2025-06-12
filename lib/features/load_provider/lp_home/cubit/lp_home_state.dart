import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';

class LPHomeState extends Equatable {
  final UIState<LoadTruckTypeListModel>? truckTypeState;
  final UIState<RecentRoutesModel>? recentRouteState;
  final bool showSuccessKyc;
  final Map<String, dynamic>? destination;
  final Map<String, dynamic>? pickup;
  const LPHomeState({this.truckTypeState, this.showSuccessKyc = false, this.destination, this.pickup, this.recentRouteState});

  LPHomeState copyWith({
    recentRouteState,
    truckTypeState,
    bool? showSuccessKyc,
    Map<String, dynamic>? destination,
    Map<String, dynamic>? pickup,
  }) {
    return LPHomeState(
      truckTypeState: truckTypeState ?? this.truckTypeState,
      recentRouteState: recentRouteState ?? this.recentRouteState,
      showSuccessKyc: showSuccessKyc ?? this.showSuccessKyc,
      destination: destination ?? this.destination,
      pickup: pickup ?? this.pickup,
    );
  }

  @override
  List<Object?> get props => [truckTypeState, recentRouteState, showSuccessKyc, destination, pickup];

}
