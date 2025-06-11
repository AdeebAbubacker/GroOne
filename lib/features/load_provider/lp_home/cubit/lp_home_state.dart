import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';

class LPHomeState extends Equatable {
  final UIState<LoadTruckTypeListModel>? truckTypeState;
  final bool showSuccessKyc;
  final Map<String, dynamic>? destination;
  final Map<String, dynamic>? pickup;
  const LPHomeState({this.truckTypeState, this.showSuccessKyc = false, this.destination, this.pickup,});

  LPHomeState copyWith({
    UIState<LoadTruckTypeListModel>?
    truckTypeState,
    bool? showSuccessKyc,
    Map<String, dynamic>? destination,
    Map<String, dynamic>? pickup,
  }) {
    return LPHomeState(
      truckTypeState: truckTypeState ?? this.truckTypeState,
      showSuccessKyc: showSuccessKyc ?? this.showSuccessKyc,
      destination: destination ?? this.destination,
      pickup: pickup ?? this.pickup,
    );
  }

  @override
  List<Object?> get props => [truckTypeState, showSuccessKyc, destination, pickup];

}
