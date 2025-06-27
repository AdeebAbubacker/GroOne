import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/lp_loads_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_update_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_otp_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/repository/lp_all_loads_repository.dart';

part 'lp_load_state.dart';

class LpLoadCubit extends BaseCubit<LpLoadState> {
  final LpLoadRepository _repository;
  LpLoadCubit(this._repository) : super(LpLoadState());

  // Updates the UI state related to loading LP loads.
  void _setLoadUIState(UIState<List<LpLoadItem>>? uiState) {
    emit(state.copyWith(lpLoadResponse: uiState));
  }

  // Fetches the LP loads filtered by the given [type].
  Future<void> getLpLoadsByType({required LoadListApiRequest loadListApiRequest}) async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.fetchLoads(request: loadListApiRequest);

    if (result is Success<List<LpLoadItem>>) {
      _setLoadUIState(UIState.success(result.value));
    } else if (result is Error) {
      _setLoadUIState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to loading LP loads by ID.
  void _setLoadByIdUIState(UIState<LpLoadGetByIdResponse>? uiState) {
    emit(state.copyWith(lpLoadById: uiState));
  }

  // Fetches the LP loads filtered by the given [type].
  Future<void> getLpLoadsById({required int loadId}) async {
    _setLoadByIdUIState(UIState.loading());

    Result result = await _repository.fetchLoadById(loadId: loadId);

    if (result is Success<LpLoadGetByIdResponse>) {
      _setLoadByIdUIState(UIState.success(result.value));
    } else if (result is Error) {
      _setLoadByIdUIState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to load Memo Details.
  void _setLoadMemoState(UIState<LoadMemoData>? uiState) {
    emit(state.copyWith(lpLoadMemoDetails: uiState));
  }

  // Fetches the LP load Memo Details.
  Future<void> getLpLoadsMemoDetails({required int loadId}) async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.fetchMemoDetails(loadId: loadId);

    if (result is Success<LoadMemoData>) {
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
  void _setTruckTypeState(UIState<LoadTruckTypeListModel>? uiState) {
    emit(state.copyWith(lpLoadTruckTypes: uiState));
  }

  // Fetches the LP load truck Details.
  Future<void> getTruckType() async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.fetchTruckTypeList();

    if (result is Success<LoadTruckTypeListModel>) {
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
  Future<void> sendOtp() async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.sendOtp();

    if (result is Success<LpLoadMemoOtpResponse>) {
      _setSendOtpState(UIState.success(result.value));
    } else if (result is Error) {
      _setSendOtpState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to lp load verify Otp.
  void _setVerifyOtpState(UIState<LpLoadMemoOtpResponse>? uiState) {
    emit(state.copyWith(lpLoadMemoVerifyOtp: uiState));
  }

  // Verify otp of e-sign memo
  Future<void> verifyOtp({required String otp}) async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.verifyOtp(otp: otp);

    if (result is Success<LpLoadMemoOtpResponse>) {
      _setVerifyOtpState(UIState.success(result.value));
    } else if (result is Error) {
      _setVerifyOtpState(UIState.error(result.type));
    }
  }


  // apply filter
  Future<void> applyFilter({required int fromRoute, required int toRoute, required String truckType, required String loadPostedDate}) async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.applyFilter(fromRoute: fromRoute, toRoute: toRoute, truckType: truckType, loadPostedDate: loadPostedDate);

    if (result is Success<List<LpLoadItem>>) {
      _setLoadUIState(UIState.success(result.value));
    } else if (result is Error) {
      _setLoadUIState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to lp load verify Otp.
  void _setCreditCheckState(UIState<LpLoadCreditCheckResponse>? uiState) {
    emit(state.copyWith(lpCreditCheck: uiState));
  }

  // Credit check
  Future<void> getCreditCheck() async {
    _setCreditCheckState(UIState.loading());

    Result result = await _repository.getCreditCheck();

    if (result is Success<LpLoadCreditCheckResponse>) {
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

}
