part of 'vp_trip_settlement_cubit.dart';

class VpTripSettlementState extends Equatable {
  final UIState<PodCenterListModel>? tripSettlementUIState;
  const VpTripSettlementState({this.tripSettlementUIState});

  VpTripSettlementState copyWith({
    UIState<PodCenterListModel>? tripSettlementUIState,
  }) {
    return VpTripSettlementState(
      tripSettlementUIState: tripSettlementUIState ?? this.tripSettlementUIState,
    );
  }

  @override
  List<Object?> get props => [
    tripSettlementUIState,
  ];
}

