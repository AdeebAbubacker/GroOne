import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/load_status_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';

class VpLoadState extends Equatable {
  final UIState<List<VpRecentLoadData>>? loads;
  final UIState<List<LoadStatusResponse>>? statuses;
  final int? currentPage;
  final int? totalRecords;


  const VpLoadState({
    this.loads,
    this.statuses,
    this.currentPage,
    this.totalRecords
  });

  VpLoadState copyWith({
    UIState<List<VpRecentLoadData>>? loads,
    UIState<List<LoadStatusResponse>>? statuses,
     int? currentPage,
     int? totalPage,
  }) {
    return VpLoadState(
      loads: loads ?? this.loads,
      statuses: statuses ?? this.statuses,
      currentPage: currentPage ?? this.currentPage,
      totalRecords: totalPage ?? this.totalRecords
    );
  }
  @override
  List<Object?> get props => [
    loads,
    statuses,
    currentPage,
    totalRecords
  ];
}


