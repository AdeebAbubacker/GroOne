part of 'lp_load_cubit.dart';

class LpLoadState extends Equatable {
  final UIState<List<LpLoadItem>>? lpLoadResponse;
  final UIState<LoadMemoData>? lpLoadMemoDetails;
  final UIState<LoadTruckTypeListModel>? lpLoadTruckTypes;
  final UIState<LpLoadRouteResponse>? lpLoadRouteDetails;
  final int selectedTabIndex;

  const LpLoadState({this.lpLoadResponse,this.selectedTabIndex = 1, this.lpLoadMemoDetails, this.lpLoadTruckTypes, this.lpLoadRouteDetails});

  LpLoadState copyWith({
    UIState<List<LpLoadItem>>? lpLoadResponse,
    UIState<LoadMemoData>? lpLoadMemoDetails,
    UIState<LoadTruckTypeListModel>? lpLoadTruckTypes,
    UIState<LpLoadRouteResponse>? lpLoadRouteDetails,
    int? selectedTabIndex,
  }) {
    return LpLoadState(
      lpLoadResponse: lpLoadResponse ?? this.lpLoadResponse,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      lpLoadMemoDetails: lpLoadMemoDetails ?? this.lpLoadMemoDetails,
      lpLoadTruckTypes: lpLoadTruckTypes ?? this.lpLoadTruckTypes,
      lpLoadRouteDetails: lpLoadRouteDetails ?? this.lpLoadRouteDetails,
    );
  }

  @override
  List<Object?> get props => [lpLoadResponse, selectedTabIndex, lpLoadMemoDetails, lpLoadTruckTypes, lpLoadRouteDetails];
}
