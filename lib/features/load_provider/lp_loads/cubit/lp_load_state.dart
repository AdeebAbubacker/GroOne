part of 'lp_load_cubit.dart';

class LpLoadState extends Equatable {
  final UIState<List<LpLoadItem>>? lpLoadResponse;
  final int selectedTabIndex;

  const LpLoadState({this.lpLoadResponse,this.selectedTabIndex = 1});

  LpLoadState copyWith({
    UIState<List<LpLoadItem>>? lpLoadResponse,
    int? selectedTabIndex,
  }) {
    return LpLoadState(
      lpLoadResponse: lpLoadResponse ?? this.lpLoadResponse,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [lpLoadResponse, selectedTabIndex];
}
