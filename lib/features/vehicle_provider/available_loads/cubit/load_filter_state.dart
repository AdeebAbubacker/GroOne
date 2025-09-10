import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';

class LoadFilterState extends Equatable {
  final UIState<List<LoadCommodityListModel>>? commodityResponseUIState;
  final UIState<TruckPrefLaneModel>? truckTypeLaneUIState;
  final UIState<List<TruckTypeModel>>? truckTypeUIState;
  final bool? isFilterApplied;
  final Item? selectedPrefLanes;



  final Map<String,dynamic>? selectedTruckType;
  final Map<String,dynamic>? selectedLaneType;
  final Map<String,dynamic>? selectedCommodity;
  final int? currentPage;






  // Constructor
  const LoadFilterState({
    this.selectedPrefLanes,
    this.commodityResponseUIState,
    this.truckTypeLaneUIState,
    this.truckTypeUIState,
    this.isFilterApplied,
    this.selectedTruckType,
    this.selectedLaneType,
    this.selectedCommodity,
    this.currentPage=1
  });

  // copyWith
  LoadFilterState copyWith({
    UIState<List<LoadCommodityListModel>>? commodityResponseUIState,
    UIState<TruckPrefLaneModel>? truckTypeLaneUIState,
    UIState<List<TruckTypeModel>>? truckTypeUIState,
     Map<String,dynamic>? selectedTruckType,
     Map<String,dynamic>? selectedLaneType,
     Map<String,dynamic>? selectedCommodity,
    bool? isFilterApplied,
    int? currentPage,
    Item? selectedPrefLanes

  }) {
    return LoadFilterState(
selectedPrefLanes:  selectedPrefLanes ?? this.selectedPrefLanes,
      currentPage: currentPage??this.currentPage,
      commodityResponseUIState: commodityResponseUIState ?? this.commodityResponseUIState,
      truckTypeLaneUIState: truckTypeLaneUIState ?? this.truckTypeLaneUIState,
      truckTypeUIState: truckTypeUIState ?? this.truckTypeUIState,
      isFilterApplied: isFilterApplied ?? this.isFilterApplied,
      selectedCommodity: selectedCommodity??this.selectedCommodity,
      selectedLaneType: selectedLaneType??this.selectedLaneType,
      selectedTruckType: selectedTruckType ?? this.selectedTruckType
    );
  }

  @override
  List<Object?> get props => [
    commodityResponseUIState,
    truckTypeLaneUIState,
    truckTypeUIState,

    isFilterApplied,
    selectedCommodity,
    selectedLaneType,
    selectedTruckType,

    currentPage,
    selectedPrefLanes

  ];
}
