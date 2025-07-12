import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/consignee_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/lp_loads_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/tracking_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_consignee_add_success_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_agree_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_update_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_feedback_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_otp_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_verify_advance_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/tracking_consent_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/tracking_distance_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/repository/lp_all_loads_repository.dart';
import 'package:gro_one_app/features/trip_tracking/helper/trip_tracking_helper.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'lp_load_state.dart';

class LpLoadCubit extends BaseCubit<LpLoadState> {
  final LpLoadRepository _repository;
  final LpLoadPaginationController paginationController = LpLoadPaginationController();

  LpLoadCubit(this._repository) : super(LpLoadState());

  // Updates the UI state related to loading LP loads.
  void _setLoadUIState(UIState<LpLoadResponse>? uiState) {
    emit(state.copyWith(lpLoadResponse: uiState));
  }

  // Fetches the LP loads filtered by the given [type].
  Future<void> getLpLoadsByType({required LoadListApiRequest loadListApiRequest, bool isNextPage = false,}) async {
    // If it's not next page fetch, show loader state


    if (!isNextPage) {
      _setLoadUIState(UIState.loading());
    }

    Result result = await _repository.fetchLoads(request: loadListApiRequest);

    if (result is Success<LpLoadResponse>) {
      final newData = result.value;

      // Get existing data if this is a next page fetch
      final existingData = isNextPage
          ? (state.lpLoadResponse?.data?.data ?? [])
          : [];

      final newItems = newData.data ?? [];

      final List<LpLoadItem> combinedItems = [...existingData, ...newItems];


      // Create new data object with combined items
      final updatedLoadData = newData.copyWith(
        data: combinedItems,
      );

      // Create new response with updated load data
      final combinedResponse = newData.copyWith(
        data: updatedLoadData.data,
      );

      _setLoadUIState(UIState.success(combinedResponse));

      // Update pagination controller
      if (updatedLoadData?.pageMeta != null) {
        paginationController.updatePageMeta(updatedLoadData!.pageMeta!);
      }
    } else if (result is Error) {
      _setLoadUIState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to loading LP loads by ID.
  void _setLoadByIdUIState(UIState<LoadGetByIdResponse>? uiState) {
    emit(state.copyWith(lpLoadById: uiState,));
  }

  // Fetches the LP loads filtered by the given [type].
  Future<void> getLpLoadsById({required String loadId}) async {
    _setLoadByIdUIState(UIState.loading());

    Result result = await _repository.fetchLoadById(loadId: loadId);

    if (result is Success<LoadGetByIdResponse>) {
      emit(state.copyWith(locationDistance: getDistance(result.value.data?.loadRoute?.pickUpLatlon??"0",result.value.data?.loadRoute?.dropLatlon??"0"), isFeedbackAdded: result.value.data?.notes.isNotEmpty));
      _setLoadByIdUIState(UIState.success(result.value));
    } else if (result is Error) {
      _setLoadByIdUIState(UIState.error(result.type));
    }
  }

  String getDistance(String pickUpLatLong,dropLatLong){
    final pickupLatLng = TripTrackingHelper.getLatLngFromString(pickUpLatLong);
    final dropLatLng = TripTrackingHelper.getLatLngFromString(dropLatLong);
    double distanceInMeters = Geolocator.distanceBetween(
      pickupLatLng.latitude,
      pickupLatLng.longitude,
      dropLatLng.latitude,
      dropLatLng.longitude,
    );
    return (distanceInMeters / 1000).toStringAsFixed(2);
  }

  // Updates the UI state related to load Memo Details.
  void _setLoadMemoState(UIState<LpLoadMemoResponse>? uiState) {
    emit(state.copyWith(lpLoadMemoDetails: uiState));
  }

  // Fetches the LP load Memo Details.
  Future<void> getLpLoadsMemoDetails({required String loadId}) async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.fetchMemoDetails(loadId: loadId);

    if (result is Success<LpLoadMemoResponse>) {
      _setLoadMemoState(UIState.success(result.value));
    } else if (result is Error) {
      _setLoadMemoState(UIState.error(result.type));
    }
  }

  // update the selected tab
  void updateSelectedTabIndex(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }


  // Updates the UI state related to load truck.
  void _setTruckTypeState(UIState<List<LoadTruckTypeListModel>>? uiState) {
    emit(state.copyWith(lpLoadTruckTypes: uiState));
  }

  // Fetches the LP load truck Details.
  Future<void> getTruckType() async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.fetchTruckTypeList();

    if (result is Success<List<LoadTruckTypeListModel>>) {
      _setTruckTypeState(UIState.success(result.value));
    } else if (result is Error) {
      _setTruckTypeState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to load truck.
  void _setRouteDetailsState(UIState<LpLoadRouteResponse>? uiState) {
    emit(state.copyWith(lpLoadRouteDetails: uiState));
  }

  // Fetches the LP load route Details.
  Future<void> getRouteDetails() async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.fetchRouteList();

    if (result is Success<LpLoadRouteResponse>) {
      _setRouteDetailsState(UIState.success(result.value));
    } else if (result is Error) {
      _setRouteDetailsState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to lp load memo otp.
  void _setSendOtpState(UIState<LpLoadMemoOtpResponse>? uiState) {
    emit(state.copyWith(lpLoadMemoSendOtp: uiState));
  }

  // Send otp to e-sign memo
  Future<void> sendOtp({required String loadId}) async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.sendOtp(loadId: loadId);

    if (result is Success<LpLoadMemoOtpResponse>) {
      _setSendOtpState(UIState.success(result.value));
    } else if (result is Error) {
      _setSendOtpState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to lp load verify Otp.
  void _setVerifyOtpState(UIState<LpLoadMemoVerifyOtpResponse>? uiState) {
    emit(state.copyWith(lpLoadMemoVerifyOtp: uiState));
  }

  // Verify otp of e-sign memo
  Future<void> verifyOtp({required String otp, required String loadId}) async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.verifyOtp(otp: otp, loadId: loadId);

    if (result is Success<LpLoadMemoVerifyOtpResponse>) {
      _setVerifyOtpState(UIState.success(result.value));
    } else if (result is Error) {
      _setVerifyOtpState(UIState.error(result.type));
    }
  }


  // Updates the UI state related to lp load verify Otp.
  void _setCreditCheckState(UIState<CreditCheckApiResponse>? uiState) {
    emit(state.copyWith(lpCreditCheck: uiState));
  }

  // Credit check
  Future<void> getCreditCheck() async {
    _setCreditCheckState(UIState.loading());

    Result result = await _repository.getCreditCheck();

    if (result is Success<CreditCheckApiResponse>) {
      _setCreditCheckState(UIState.success(result.value));
    } else if (result is Error) {
      _setCreditCheckState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to lp load verify Otp.
  void _setCreditUpdateState(UIState<LpLoadCreditUpdateResponse>? uiState) {
    emit(state.copyWith(lpCreditUpdate: uiState));
  }

  // Credit check
  Future<void> updateCreditCheck({required String creditLimit, required String creditUsed}) async {
    _setCreditUpdateState(UIState.loading());

    Result result = await _repository.updateCreditCheck(creditLimit: creditLimit, creditUsed: creditUsed);

    if (result is Success<LpLoadCreditUpdateResponse>) {
      _setCreditUpdateState(UIState.success(result.value));
    } else if (result is Error) {
      _setCreditUpdateState(UIState.error(result.type));
    }
  }

  Future<String?> getFirstPostedLoadId() async {
    return await _repository.getFirstPostedLoadId();
  }

  Future<void> clearFirstPostedLoadId() async {
    return await _repository.clearFirstPostedLoadId();
  }

  Future<void> setFirstPostedLoadIdIfAbsent(String loadId) async {
    return await _repository.setFirstPostedLoadIdIfAbsent(loadId);
  }

  // Updates the UI state related to lp load Agree.
  void _setLoadAgreeState(UIState<LpLoadAgreeResponse>? uiState) {
    emit(state.copyWith(lpLoadAgree: uiState));
  }

  // Lp load Agree response
  Future<void> loadAgree({required String loadId}) async {
    _setLoadAgreeState(UIState.loading());

    Result result = await _repository.loadAgree(loadId: loadId);

    if (result is Success<LpLoadAgreeResponse>) {
      final agreeData = result.value;
      final defaultAdvance = agreeData.advance.firstWhere(
            (item) => item.percentage == '90.00',
        orElse: () => agreeData.advance.first,
      );

      emit(state.copyWith(
        lpLoadAgree: UIState.success(result.value),
        selectedAdvance: defaultAdvance,
        selectedPercentageId: defaultAdvance.percentageId,
      ));
      _setLoadAgreeState(UIState.success(result.value));
    } else if (result is Error) {
      _setLoadAgreeState(UIState.error(result.type));
    }
  }


  // Updates the UI state related to lp load verify advance.
  void _setLoadVerifyAdvanceState(UIState<LpLoadVerifyAdvanceResponse>? uiState) {
    emit(state.copyWith(lpLoadVerifyAdvance: uiState));
  }

  // Lp load Verify advance
  Future<void> verifyAdvance({required String loadId, required String percentageId}) async {
    _setLoadVerifyAdvanceState(UIState.loading());

    Result result = await _repository.verifyAdvance(loadId: loadId, percentageId: percentageId);

    if (result is Success<LpLoadVerifyAdvanceResponse>) {
      _setLoadVerifyAdvanceState(UIState.success(result.value));
    } else if (result is Error) {
      _setLoadVerifyAdvanceState(UIState.error(result.type));
    }
  }

  void selectAdvance(Advance advance) {
    emit(state.copyWith(
      selectedAdvance: advance,
      selectedPercentageId: advance.percentageId,
    ));
  }

  // Updates the UI state related to lp load update feedback.
  void _setLoadFeedbackState(UIState<LpLoadFeedbackResponse>? uiState) {
    emit(state.copyWith(lpLoadFeedback: uiState));
  }

  // Lp load update feedback
  Future<void> updateFeedback({required String loadId, required String feedback}) async {
    _setLoadFeedbackState(UIState.loading());

    Result result = await _repository.updateFeedback(loadId: loadId, feedback: feedback);

    if (result is Success<LpLoadFeedbackResponse>) {
      emit(state.copyWith(isFeedbackAdded: true));
      _setLoadFeedbackState(UIState.success(result.value));
      ToastMessages.success(message: result.value.message);

    } else if (result is Error) {
      _setLoadFeedbackState(UIState.error(result.type));
    }

  }

  // Updates the UI state related to Document by ID.
  void _setDocumentByIdState(UIState<DocumentDetails>? uiState) {
    emit(state.copyWith(lpDocumentById: uiState));
  }

  // Lp load Document by ID
  Future<void> getDocumentById({required String docId}) async {
    _setDocumentByIdState(UIState.loading());

    Result result = await _repository.getDocumentById(docId: docId);


    if (result is Success<DocumentDetails>) {
      _setDocumentByIdState(UIState.success(result.value));
    } else if (result is Error) {
      _setDocumentByIdState(UIState.error(result.type));
    }

  }


  // Updates the UI state related to tracking consent.
  void _setConsentStatusState(UIState<TrackingConsentStatusResponse>? uiState) {
    emit(state.copyWith(trackingConsent: uiState));
  }

  // Lp load tracking consent
  Future<void> getConsentStatus({required String mobileNumber}) async {
    _setConsentStatusState(UIState.loading());

    Result result = await _repository.getConsentStatus(mobileNumber: mobileNumber);

    if (result is Success<TrackingConsentStatusResponse>) {
      _setConsentStatusState(UIState.success(result.value));
    } else if (result is Error) {
      _setConsentStatusState(UIState.error(result.type));
    }

  }

  // Updates the UI state related to tracking distance.
  void _setTrackingDistanceState(UIState<TrackingDistanceResponse>? uiState) {
    emit(state.copyWith(trackingDistance: uiState));
  }

  // Lp load tracking distance
  Future<void> getTrackingDistance({required TrackingDistanceApiRequest request}) async {
    _setTrackingDistanceState(UIState.loading());

    Result result = await _repository.getTrackingDistance(request: request);

    if (result is Success<TrackingDistanceResponse>) {
      _setTrackingDistanceState(UIState.success(result.value));
    } else if (result is Error) {
      _setTrackingDistanceState(UIState.error(result.type));
    }

  }
 

  
  // Adds a consignee to the load.
  void _setaddConsigneeState(UIState<ConsigneAddedSuccessModel>? uiState) {
    emit(state.copyWith(lpAddConsignee: uiState));
  }

  // Create New consignee to a load
  Future<void> addConsignee({required AddConsigneeApiRequest addConsigneeReq}) async {
    _setaddConsigneeState(UIState.loading());

    Result result = await _repository.addConsignee(addConsigneeReq: addConsigneeReq);

    if (result is Success<ConsigneAddedSuccessModel>) {
      _setaddConsigneeState(UIState.success(result.value));
    } else if (result is Error) {
      _setaddConsigneeState(UIState.error(result.type));
    }    
  }

   // Updates consignee to the load.
  void _updateConsigneeState(UIState<ConsigneAddedSuccessModel>? uiState) {
    emit(state.copyWith(lpUpdateConsignee: uiState));
  }

  // Updates Excisting consignee to a load
  Future<void> updateConsignee({required UpdateConsigneeApiRequest updateConsigneeReq,required String consigneeId}) async {
    _updateConsigneeState(UIState.loading());

    Result result = await _repository.updateConsignee(updateConsigneeReq: updateConsigneeReq,consigneeId: consigneeId);

    if (result is Success<ConsigneAddedSuccessModel>) {
      _updateConsigneeState(UIState.success(result.value));
    } else if (result is Error) {
      _updateConsigneeState(UIState.error(result.type));
    }    
  }
 
  void updateFeedbackText(String text) {
    final currentLoadById = state.lpLoadById?.data?.data;
    if (currentLoadById != null) {
      final updatedLoadData = currentLoadById.copyWith(notes: text);
      emit(state.copyWith(
        lpLoadById: UIState.success(
          LoadGetByIdResponse(data: updatedLoadData, message: ''),
        ),
      ));
    }
  }

  void markDocumentAsDownloaded(String fileName) {
    final updatedDownloads = Map<String, bool>.from(state.downloadedFiles);
    updatedDownloads[fileName] = true;
    emit(state.copyWith(downloadedFiles: updatedDownloads));
  }

  Future<void> downloadAndOpenDocument(String downloadKey, String docUrl) async {
    final uri = Uri.parse(docUrl);
    final fileName = path.basename(uri.path);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, fileName);
    final file = File(filePath);

    try {
      if (await file.exists()) {
        await OpenFilex.open(filePath);
        markDocumentAsDownloaded(downloadKey);
      } else {
        final dio = Dio();
        await dio.download(docUrl, filePath);
        markDocumentAsDownloaded(downloadKey);
        await OpenFilex.open(filePath);
      }
    } catch (e) {
      ToastMessages.error(message: 'Failed to download the document ');
    }
  }

}

class LpLoadPaginationController {
  int currentPage = 1;
  int totalPages = 1;
  bool isFetchingMore = false;

  void reset() {
    currentPage = 1;
    totalPages = 1;
    isFetchingMore = false;
  }

  void updatePageMeta(PageMeta pageMeta) {
    currentPage = pageMeta.page;
    totalPages = pageMeta.pageCount;
  }

  bool get hasMorePages => currentPage < totalPages;
}