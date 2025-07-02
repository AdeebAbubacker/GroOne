part of 'lp_load_cubit.dart';

class LpLoadState extends Equatable {
  final UIState<LpLoadResponse>? lpLoadResponse;
  final UIState<LpLoadGetByIdResponse>? lpLoadById;
  final UIState<LoadMemoData>? lpLoadMemoDetails;
  final UIState<LpLoadMemoOtpResponse>? lpLoadMemoSendOtp;
  final UIState<LpLoadMemoOtpResponse>? lpLoadMemoVerifyOtp;
  final UIState<LoadTruckTypeListModel>? lpLoadTruckTypes;
  final UIState<LpLoadRouteResponse>? lpLoadRouteDetails;
  final UIState<CreditCheckApiResponse>? lpCreditCheck;
  final UIState<LpLoadCreditUpdateResponse>? lpCreditUpdate;
  final UIState<LpLoadAgreeResponse>? lpLoadAgree;
  final UIState<LpLoadVerifyAdvanceResponse>? lpLoadVerifyAdvance;
  final int selectedTabIndex;
  final String? matchingText;
  final Advance? selectedAdvance;
  final int? selectedPercentageId;
  final String? locationDistance;


  const LpLoadState({
    this.lpLoadResponse,
    this.lpLoadById,
    this.selectedTabIndex = 0,
    this.lpLoadMemoDetails,
    this.lpLoadMemoSendOtp,
    this.lpLoadMemoVerifyOtp,
    this.lpLoadTruckTypes,
    this.lpLoadRouteDetails,
    this.lpCreditCheck,
    this.lpCreditUpdate,
    this.lpLoadAgree,
    this.lpLoadVerifyAdvance,
    this.matchingText,
    this.selectedAdvance,
    this.selectedPercentageId,
    this.locationDistance,
  });

  LpLoadState copyWith({
    UIState<LpLoadResponse>? lpLoadResponse,
    UIState<LpLoadGetByIdResponse>? lpLoadById,
    UIState<LoadMemoData>? lpLoadMemoDetails,
    UIState<LpLoadMemoOtpResponse>? lpLoadMemoSendOtp,
    UIState<LpLoadMemoOtpResponse>? lpLoadMemoVerifyOtp,
    UIState<LoadTruckTypeListModel>? lpLoadTruckTypes,
    UIState<LpLoadRouteResponse>? lpLoadRouteDetails,
    UIState<CreditCheckApiResponse>? lpCreditCheck,
    UIState<LpLoadCreditUpdateResponse>? lpCreditUpdate,
    UIState<LpLoadAgreeResponse>? lpLoadAgree,
    UIState<LpLoadVerifyAdvanceResponse>? lpLoadVerifyAdvance,
    int? selectedTabIndex,
    String? matchingText,
    Advance? selectedAdvance,
    int? selectedPercentageId,
    String? locationDistance,
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
      lpCreditUpdate: lpCreditUpdate ?? this.lpCreditUpdate,
      lpLoadAgree: lpLoadAgree ?? this.lpLoadAgree,
      lpLoadVerifyAdvance: lpLoadVerifyAdvance ?? this.lpLoadVerifyAdvance,
      matchingText: matchingText ?? this.matchingText,
      selectedAdvance: selectedAdvance ?? this.selectedAdvance,
      selectedPercentageId: selectedPercentageId ?? this.selectedPercentageId,
      locationDistance: locationDistance ?? this.locationDistance,
    );
  }

  @override
  List<Object?> get props => [
    lpLoadResponse,
    lpLoadById,
    selectedTabIndex,
    lpLoadMemoDetails,
    lpLoadMemoSendOtp,
    lpLoadMemoVerifyOtp,
    lpLoadTruckTypes,
    lpLoadRouteDetails,
    lpCreditCheck,
    lpCreditUpdate,
    lpLoadAgree,
    lpLoadVerifyAdvance,
    matchingText,
    selectedPercentageId,
    selectedAdvance,
    locationDistance
  ];
}
