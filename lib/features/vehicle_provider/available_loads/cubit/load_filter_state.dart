import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';

class LoadFilterState extends Equatable {
  final UIState<List<LoadCommodityListModel>>? commodityResponseUIState;
  final UIState<TruckPrefLaneModel>? truckTypeLaneUIState;
  final UIState<List<TruckTypeModel>>? truckTypeUIState;

  // Constructor
  const LoadFilterState({
    this.commodityResponseUIState,
    this.truckTypeLaneUIState,
    this.truckTypeUIState,
  });

  // copyWith
  LoadFilterState copyWith({
    UIState<List<LoadCommodityListModel>>? commodityResponseUIState,
    UIState<TruckPrefLaneModel>? truckTypeLaneUIState,
    UIState<List<TruckTypeModel>>? truckTypeUIState,
  }) {
    return LoadFilterState(
      commodityResponseUIState: commodityResponseUIState ?? this.commodityResponseUIState,
      truckTypeLaneUIState: truckTypeLaneUIState ?? this.truckTypeLaneUIState,
      truckTypeUIState: truckTypeUIState ?? this.truckTypeUIState,
    );
  }

  @override
  List<Object?> get props => [
    commodityResponseUIState,
    truckTypeLaneUIState,
    truckTypeUIState,
  ];
}
