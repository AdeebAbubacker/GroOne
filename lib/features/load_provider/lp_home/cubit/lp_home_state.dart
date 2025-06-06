import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';

class LPHomeState extends Equatable {
  final UIState<LoadTruckTypeListModel>? truckTypeState;
  final bool showSuccessKyc;
  const LPHomeState({this.truckTypeState, this.showSuccessKyc = false});

  LPHomeState copyWith({UIState<LoadTruckTypeListModel>? truckTypeState, bool? showSuccessKyc}) {
    return LPHomeState(
      truckTypeState: truckTypeState ?? this.truckTypeState,
      showSuccessKyc: showSuccessKyc ?? this.showSuccessKyc,
    );
  }

  @override
  List<Object?> get props => [truckTypeState, showSuccessKyc];

}
