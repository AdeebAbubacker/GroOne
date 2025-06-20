part of 'lp_load_cubit.dart';

class LpLoadState extends Equatable {
  final UIState<List<LpLoadItem>>? lpLoadResponse;
  final UIState<LoadMemoData>? lpLoadMemoDetails;
  final int selectedTabIndex;

  const LpLoadState({this.lpLoadResponse,this.selectedTabIndex = 1, this.lpLoadMemoDetails});

  LpLoadState copyWith({
    UIState<List<LpLoadItem>>? lpLoadResponse,
    UIState<LoadMemoData>? lpLoadMemoDetails,
    int? selectedTabIndex,
  }) {
    return LpLoadState(
      lpLoadResponse: lpLoadResponse ?? this.lpLoadResponse,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      lpLoadMemoDetails: lpLoadMemoDetails ?? this.lpLoadMemoDetails,
    );
  }

  @override
  List<Object?> get props => [lpLoadResponse, selectedTabIndex, lpLoadMemoDetails];
}
