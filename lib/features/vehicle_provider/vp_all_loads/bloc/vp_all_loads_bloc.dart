import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import '../../../../data/model/result.dart';
import '../repository/vp_all_load_repository.dart';
import 'vp_all_loads_event.dart';
import 'vp_all_loads_state.dart';

class VpLoadBloc extends Bloc<VpLoadEvent, VpLoadState> {
  final VpLoadRepository repo;

  VpLoadBloc(this.repo) : super(VpLoadInitial()) {
    on<FetchVpLoads>((event, emit) async {
      emit(VpLoadLoading());
      final result = await repo.fetchLoads(type: event.type, search: event.search, forceRefresh: event.forceRefresh);
      if (result is Success<List<VpRecentLoadData>>) {
        emit(VpLoadLoaded(result.value));
      } else {
        emit(VpLoadError("Failed to load data"));
      }
    });
  }
}
