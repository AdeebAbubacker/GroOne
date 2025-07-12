import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/lp_loads_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_agree_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_update_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_otp_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_verify_advance_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/repository/lp_all_loads_repository.dart';
import 'package:gro_one_app/features/trip_tracking/helper/trip_tracking_helper.dart';

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
      emit(state.copyWith(locationDistance: getDistance(result.value.data?.loadRoute?.pickUpLatlon??"0",result.value.data?.loadRoute?.dropLatlon??"0")));
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