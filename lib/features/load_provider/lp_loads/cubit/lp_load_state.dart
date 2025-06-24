part of 'lp_load_cubit.dart';

class LpLoadState extends Equatable {
  final UIState<List<LpLoadItem>>? lpLoadResponse;
  final UIState<LpLoadGetByIdResponse>? lpLoadById;
  final UIState<LoadMemoData>? lpLoadMemoDetails;
  final UIState<LpLoadMemoOtpResponse>? lpLoadMemoSendOtp;
  final UIState<LpLoadMemoOtpResponse>? lpLoadMemoVerifyOtp;
  final UIState<LoadTruckTypeListModel>? lpLoadTruckTypes;
  final UIState<LpLoadRouteResponse>? lpLoadRouteDetails;
  final UIState<LpLoadCreditCheckResponse>? lpCreditCheck;
  final int selectedTabIndex;

  const LpLoadState({this.lpLoadResponse, this. lpLoadById, this.selectedTabIndex = 1, this.lpLoadMemoDetails, this.lpLoadMemoSendOtp,this.lpLoadMemoVerifyOtp, this.lpLoadTruckTypes, this.lpLoadRouteDetails, this.lpCreditCheck});

  LpLoadState copyWith({
    UIState<List<LpLoadItem>>? lpLoadResponse,
    UIState<LpLoadGetByIdResponse>? lpLoadById,
    UIState<LoadMemoData>? lpLoadMemoDetails,
    UIState<LpLoadMemoOtpResponse>? lpLoadMemoSendOtp,
    UIState<LpLoadMemoOtpResponse>? lpLoadMemoVerifyOtp,
    UIState<LoadTruckTypeListModel>? lpLoadTruckTypes,
    UIState<LpLoadRouteResponse>? lpLoadRouteDetails,
    UIState<LpLoadCreditCheckResponse>? lpCreditCheck,
    int? selectedTabIndex,
  }) {
    return LpLoadState(
      lpLoadResponse: lpLoadResponse ?? this.lpLoadResponse,
      lpLoadById: lpLoadById ?? this.lpLoadById,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      lpLoadMemoDetails: lpLoadMemoDetails ?? this.lpLoadMemoDetails,
      lpLoadMemoSendOtp: lpLoadMemoSendOtp ?? this.lpLoadMemoSendOtp,
      lpLoadMemoVerifyOtp: lpLoadMemoVerifyOtp ?? this.lpLoadMemoVerifyOtp,
      lpLoadTruckTypes: lpLoadTruckTypes ?? this.lpLoadTruckTypes,
      lpLoadRouteDetails: lpLoadRouteDetails ?? this.lpLoadRouteDetails,
      lpCreditCheck: lpCreditCheck ?? this.lpCreditCheck,
    );
  }

  @override
  List<Object?> get props => [lpLoadResponse, lpLoadById, selectedTabIndex, lpLoadMemoDetails, lpLoadMemoSendOtp, lpLoadMemoVerifyOtp, lpLoadTruckTypes, lpLoadRouteDetails, lpCreditCheck];
}
