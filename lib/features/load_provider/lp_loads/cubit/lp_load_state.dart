part of 'lp_load_cubit.dart';

class LpLoadState extends Equatable {
  final UIState<List<LpLoadItem>>? lpLoadResponse;

  const LpLoadState({this.lpLoadResponse});

  LpLoadState copyWith({
    UIState<List<LpLoadItem>>? lpLoadResponse,
  }) {
    return LpLoadState(
      lpLoadResponse: lpLoadResponse ?? this.lpLoadResponse,
    );
  }

  @override
  List<Object?> get props => [lpLoadResponse];
}
