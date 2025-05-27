import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/repository/vp_creation_repository.dart';

part 'vp_creation_event.dart';
part 'vp_creation_state.dart';

class VpCreationBloc extends Bloc<VpCreationEvent, VpCreationState> {
  final VpCreationRepository _repository;
  VpCreationBloc(this._repository) : super(VpCreationInitial()) {

    // Vehicle provider creation api call
    on<VpCreationRequested>((event, emit) async {
      emit(VpCreationLoading());
      Result result = await _repository.requestVpCreation(event.apiRequest, id: event.id);
      if (result is Success<UserModel?>) {
        emit(VpCreationSuccess(result.value));
      }
      if (result is Error) {
        emit(VpCreationError(result.type));
      }
    });


    // Logout
    on<LogoutRequested>((event, emit) async {
      emit(LogoutLoading());
      Result result = await _repository.signOut(); // You must define this in your repository
      if (result is Success<bool>) {
        emit(LogoutSuccess());
      } else if (result is Error) {
        emit(LogoutError(result.type));
      }
    });




  }
}
