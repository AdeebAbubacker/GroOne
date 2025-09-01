import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/api_request/submit_pod_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/model/pod_center_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/repository/pod_dispatch_repository.dart';

part 'pod_dispatch_state.dart';

class PodDispatchCubit extends BaseCubit<PodDispatchState> {
  final PodDispatchRepository _repository;
  PodDispatchCubit(this._repository) : super(PodDispatchState());

  // Fetch Pod Center Api Call
  void _setPodCenterUIState(UIState<PodCenterListModel>? uiState){
    emit(state.copyWith(podCenterListUIState: uiState));
  }
  Future<void> fetchPodCenterList() async {
    _setPodCenterUIState(UIState.loading());
    Result result = await _repository.getPodCenterListData();
    if (result is Success<PodCenterListModel>) {
      _setPodCenterUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setPodCenterUIState(UIState.error(result.type));
    }
  }


  // Fetch Pod Center Api Call
  void _setSubmitPodIState(UIState<bool>? uiState){
    emit(state.copyWith(submitPodUIState: uiState));
  }

  Future<bool?> submitPod(SubmitPodApiRequest request) async {
    _setSubmitPodIState(UIState.loading());
    Result result = await _repository.getSubmitPodData(request);
    if (result is Success<bool>) {
      _setSubmitPodIState(UIState.success(result.value));
      return true;
    }
    if (result is Error) {
      _setSubmitPodIState(UIState.error(result.type));
      return false;
    }
    return false;
  }


  void resetState(){
    emit(state.copyWith(
      podCenterListUIState : resetUIState<PodCenterListModel>(state.podCenterListUIState),
      submitPodUIState : resetUIState<bool>(state.submitPodUIState),
    ));
  }



}
