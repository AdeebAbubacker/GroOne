part of 'vp_trip_statement_cubit.dart';

class VpTripStatementState extends Equatable {
  final UIState<TripStatementResponse>? tripStatementUIState;
  const VpTripStatementState({this.tripStatementUIState});

  VpTripStatementState copyWith({
    UIState<TripStatementResponse>? tripSettlementUIState,
  }) {
    return VpTripStatementState(
      tripStatementUIState: tripSettlementUIState ?? tripStatementUIState,
    );
  }

  @override
  List<Object?> get props => [
    tripStatementUIState,
  ];
}

