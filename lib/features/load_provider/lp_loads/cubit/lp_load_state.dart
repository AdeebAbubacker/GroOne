part of 'lp_load_cubit.dart';

class LpLoadState extends Equatable {
  final UIState<LpLoadResponse>? lpLoadResponse;
  final UIState<LoadGetByIdResponse>? lpLoadById;
  final UIState<LpLoadMemoResponse>? lpLoadMemoDetails;
  final UIState<TripStatementResponse>? lpLoadTripDetails;
  final UIState<LpLoadMemoOtpResponse>? lpLoadMemoSendOtp;
  final UIState<LpLoadMemoVerifyOtpResponse>? lpLoadMemoVerifyOtp;
  final UIState<List<LoadTruckTypeListModel>>? lpLoadTruckTypes;
  final UIState<LpLoadRouteResponse>? lpLoadRouteDetails;
  final UIState<CreditCheckApiResponse>? lpCreditCheck;
  final UIState<LpLoadCreditUpdateResponse>? lpCreditUpdate;
  final UIState<LpLoadAgreeResponse>? lpLoadAgree;
  final UIState<LpLoadVerifyAdvanceResponse>? lpLoadVerifyAdvance;
  final UIState<LpLoadFeedbackResponse>? lpLoadFeedback;
  final UIState<DocumentDetails>? lpDocumentById;
  final UIState<TrackingDistanceResponse>? trackingDistance;
  final UIState<ConsigneAddedSuccessModel>? lpAddConsignee;
  final UIState<ConsigneAddedSuccessModel>? lpUpdateConsignee;
  final UIState<OrderAddedSuccess>? lpAddCustomerPaymentOption;
  final UIState<LpCreateOrderResponse>? lpCreateOrder;
  final UIState<List<LoadStatusResponse>>? loadStatus;
  final int selectedTabIndex;
  final String? matchingText;
  final Advance? selectedAdvance;
  final int? selectedPercentageId;
  final String? locationDistance;
  final String? downloadingKey;
  final bool? isFeedbackAdded;
  final bool isFieldUpdatble;
  final  bool isFeedBackUpdatble;
  final Map<String, bool> downloadedFiles;
  final List<String>? allDamageImageList;




  const LpLoadState({
    this.lpLoadResponse,
    this.lpLoadById,
    this.selectedTabIndex = 0,
    this.lpLoadMemoDetails,
    this.lpLoadTripDetails,
    this.lpLoadMemoSendOtp,
    this.lpLoadMemoVerifyOtp,
    this.lpLoadTruckTypes,
    this.lpLoadRouteDetails,
    this.lpCreditCheck,
    this.lpCreditUpdate,
    this.lpLoadAgree,
    this.lpLoadVerifyAdvance,
    this.lpLoadFeedback,
    this.lpDocumentById,
    this.trackingDistance,
    this.lpAddCustomerPaymentOption,
    this.lpCreateOrder,
    this.lpAddConsignee,
    this.lpUpdateConsignee,
    this.matchingText,
    this.selectedAdvance,
    this.selectedPercentageId,
    this.locationDistance,
    this.downloadingKey,
    this.isFeedbackAdded = false,
    this.downloadedFiles = const {},
    this.allDamageImageList,
    this.loadStatus,
    this.isFieldUpdatble = true,
    this.isFeedBackUpdatble = false,
  });

  LpLoadState copyWith({
    UIState<LpLoadResponse>? lpLoadResponse,
    UIState<LoadGetByIdResponse>? lpLoadById,
    UIState<LpLoadMemoResponse>? lpLoadMemoDetails,
    UIState<TripStatementResponse>? lpLoadTripDetails,
    UIState<LpLoadMemoOtpResponse>? lpLoadMemoSendOtp,
    UIState<LpLoadMemoVerifyOtpResponse>? lpLoadMemoVerifyOtp,
    UIState<List<LoadTruckTypeListModel>>? lpLoadTruckTypes,
    UIState<LpLoadRouteResponse>? lpLoadRouteDetails,
    UIState<CreditCheckApiResponse>? lpCreditCheck,
    UIState<LpLoadCreditUpdateResponse>? lpCreditUpdate,
    UIState<LpLoadAgreeResponse>? lpLoadAgree,
    UIState<LpLoadVerifyAdvanceResponse>? lpLoadVerifyAdvance,
    UIState<LpLoadFeedbackResponse>? lpLoadFeedback,
    UIState<DocumentDetails>? lpDocumentById,
    UIState<TrackingDistanceResponse>? trackingDistance,
    UIState<ConsigneAddedSuccessModel>? lpAddConsignee,
    UIState<ConsigneAddedSuccessModel>? lpUpdateConsignee,
    UIState<OrderAddedSuccess>? lpAddCustomerPaymentOption,
    UIState<LpCreateOrderResponse>? lpCreateOrder,
    UIState<List<LoadStatusResponse>>? loadStatus,
    int? selectedTabIndex,
    String? matchingText,
    Advance? selectedAdvance,
    int? selectedPercentageId,
    String? locationDistance,
    String? downloadingKey,
    bool? isFeedbackAdded,
    bool isFieldUpdatble = true,
    bool isFeedBackUpdatble = false,
    Map<String, bool>? downloadedFiles,
    List<String>? allDamageImageList
  }) {
    return LpLoadState(
      lpLoadResponse: lpLoadResponse ?? this.lpLoadResponse,
      lpLoadById: lpLoadById ?? this.lpLoadById,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      lpLoadMemoDetails: lpLoadMemoDetails ?? this.lpLoadMemoDetails,
      lpLoadTripDetails: lpLoadTripDetails ?? this.lpLoadTripDetails,
      lpLoadMemoSendOtp: lpLoadMemoSendOtp ?? this.lpLoadMemoSendOtp,
      lpLoadMemoVerifyOtp: lpLoadMemoVerifyOtp ?? this.lpLoadMemoVerifyOtp,
      lpLoadTruckTypes: lpLoadTruckTypes ?? this.lpLoadTruckTypes,
      lpLoadRouteDetails: lpLoadRouteDetails ?? this.lpLoadRouteDetails,
      lpCreditCheck: lpCreditCheck ?? this.lpCreditCheck,
      lpCreditUpdate: lpCreditUpdate ?? this.lpCreditUpdate,
      lpLoadAgree: lpLoadAgree ?? this.lpLoadAgree,
      lpLoadVerifyAdvance: lpLoadVerifyAdvance ?? this.lpLoadVerifyAdvance,
      lpLoadFeedback: lpLoadFeedback ?? this.lpLoadFeedback,
      lpDocumentById: lpDocumentById ?? this.lpDocumentById,
      trackingDistance: trackingDistance ?? this.trackingDistance,
      lpAddConsignee: lpAddConsignee ?? this.lpAddConsignee,
      lpUpdateConsignee: lpUpdateConsignee ?? this.lpUpdateConsignee,
      matchingText: matchingText ?? this.matchingText,
      selectedAdvance: selectedAdvance ?? this.selectedAdvance,
      selectedPercentageId: selectedPercentageId ?? this.selectedPercentageId,
      locationDistance: locationDistance ?? this.locationDistance,
      downloadingKey: downloadingKey ?? this.downloadingKey,
      lpAddCustomerPaymentOption: lpAddCustomerPaymentOption ?? this.lpAddCustomerPaymentOption,
      lpCreateOrder: lpCreateOrder ?? this.lpCreateOrder,
      isFeedbackAdded: isFeedbackAdded ?? this.isFeedbackAdded,
      downloadedFiles: downloadedFiles ?? this.downloadedFiles,
      allDamageImageList: allDamageImageList ?? this.allDamageImageList,
      loadStatus: loadStatus ?? this.loadStatus,
      isFieldUpdatble : isFieldUpdatble ?? this.isFieldUpdatble,
      isFeedBackUpdatble: isFeedBackUpdatble ?? this.isFeedBackUpdatble,
    );
  }

  @override
  List<Object?> get props => [
    lpLoadResponse,
    lpLoadById,
    selectedTabIndex,
    lpLoadMemoDetails,
    lpLoadTripDetails,
    lpLoadMemoSendOtp,
    lpLoadMemoVerifyOtp,
    lpLoadTruckTypes,
    lpLoadRouteDetails,
    lpCreditCheck,
    lpCreditUpdate,
    lpLoadAgree,
    lpLoadVerifyAdvance,
    lpLoadFeedback,
    lpDocumentById,
    trackingDistance,
    lpAddConsignee,
    lpUpdateConsignee,
    matchingText,
    selectedPercentageId,
    selectedAdvance,
    locationDistance,
    downloadingKey,
    lpAddCustomerPaymentOption,
    lpCreateOrder,
    isFeedbackAdded,
    downloadedFiles,
    allDamageImageList,
    loadStatus,
    isFieldUpdatble,
    isFeedBackUpdatble,
  ];
}
