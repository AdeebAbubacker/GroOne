import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/repository/vp_repository.dart';

part 'vp_accept_load_event.dart';

class VpAcceptLoadBloc extends Bloc<VpAcceptLoadEvent, VpAcceptLoadState> {
  final VpHomeRepository _vHomeRepository;
  final UserInformationRepository _userInformationRepository;
  VpAcceptLoadBloc(this._vHomeRepository, this._userInformationRepository) : super(VpAcceptLoadInitial()) {

    on<VpAcceptLoad>((event, emit) async {
      emit(VpAcceptLoadLoading());
      Result result = await _vHomeRepository.getLoadAcceptData(
          userId: await _userInformationRepository.getUserID()??'',
          loadId: event.loadId
      );
      if (result is Success<VpLoadAcceptModel>) {
        emit(VpAcceptLoadSuccess(result.value));
        await Future.delayed(const Duration(milliseconds: 100)); // slight delay to ensure UI handles it
        emit(VpAcceptLoadInitial()); // Reset UI state
      }
      if (result is Error) {
        emit(VpAcceptLoadError(result.type));
        await Future.delayed(const Duration(milliseconds: 100));
        emit(VpAcceptLoadInitial()); // Reset state after error
      }
    });
  }
}

