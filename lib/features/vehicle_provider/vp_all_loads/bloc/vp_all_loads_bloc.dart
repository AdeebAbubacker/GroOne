import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/load_status_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import '../../../../data/model/result.dart';
import '../repository/vp_all_load_repository.dart';
import 'vp_all_loads_state.dart';

class VpLoadCubit extends BaseCubit<VpLoadState> {
  final VpLoadRepository repo;

  VpLoadCubit(this.repo) : super(VpLoadState());

  // Set All loads UI state
  void _setFetchLoadsUIState(
    UIState<List<VpRecentLoadData>>? uiState, {
    int? totalItems,
    int? currentPage,
  }) {
    emit(
      state.copyWith(
        loads: uiState,
        totalPage: totalItems,
        currentPage: currentPage,
      ),
    );
  }

  // Get all loads
  Future<void> fetchVpLoads({
    int? commodityId,
    int? landId,
    int? truckTypeId,
    required int type,
    required String search,
    bool? forceRefresh,
    bool isInit=true,

  }) async {

    if (isInit) {
      _setFetchLoadsUIState(UIState.loading(), currentPage: 1, totalItems: 0);
    }

    final oldLoadData=state.loads?.data??[];
    final totalRecords=state.totalRecords??0;



  if(oldLoadData.isNotEmpty){
    if ((totalRecords) <= ((state.currentPage??0) - 1) * 10 &&  oldLoadData.length>=totalRecords) {
      return; // stop calling API
    }
  }

    Result result = await repo.fetchLoads(
      commodityId: commodityId,
      laneId: landId,
      truckTypeId: truckTypeId,
      type: type,
      search: search,
      page: state.currentPage,
      forceRefresh: forceRefresh ?? false,
    );
    if (result is Success<RecentLoadResponse>) {


      final fetchedLoadData=result.value.recentLoadData??[];

      final modifiedData=[
        ...oldLoadData,
        ...fetchedLoadData
      ];
      _setFetchLoadsUIState(UIState.success(modifiedData),
        totalItems: result.value.totalItem,
        currentPage: (state.currentPage ?? 0) + 1,
      );
    }
  }

  // set loads status UIState
  void _setLoadStatusUIState(UIState<List<LoadStatusResponse>> uiState) {
    emit(state.copyWith(statuses: uiState));
  }

  Future<void> fetchLoadStatus() async {
    _setFetchLoadsUIState(UIState.loading());
    Result result = await repo.fetchLoadStatus();
    if (result is Success<List<LoadStatusResponse>>) {
      _setLoadStatusUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setFetchLoadsUIState(UIState.error(result.type));
    }
  }
}
