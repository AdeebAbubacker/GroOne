import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/repository/vp_repository.dart';

part 'vp_recent_load_list_event.dart';
part 'vp_recent_load_list_state.dart';

class VpRecentLoadListBloc extends Bloc<VpRecentLoadListEvent, VpRecentLoadListState> {
  final VpHomeRepository _vHomeRepository;
  VpRecentLoadListBloc(this._vHomeRepository) : super(VpRecentLoadListInitial()) {

    on<VpRecentLoad>((event, emit) async {
      emit(VpRecentLoadListLoading());
      Result result = await _vHomeRepository.getVpRecentLoadData();
      if (result is Success<VpRecentLoadResponse>) {
        emit(VpRecentLoadListSuccess(result.value));
      }
      if (result is Error) {
        emit(VpRecentLoadListError(result.type));
        await Future.delayed(const Duration(milliseconds: 100));
        emit(VpRecentLoadListInitial());
      }
    });


  }
}
