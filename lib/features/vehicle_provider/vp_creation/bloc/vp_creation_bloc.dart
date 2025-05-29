import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/log_out_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/log_out_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/repository/vp_creation_repository.dart';

part 'vp_creation_event.dart';
part 'vp_creation_state.dart';

class VpCreationBloc extends Bloc<VpCreationEvent, VpCreationState> {
  final VpCreationRepository _repository;
  final UserInformationRepository? _informationRepository;
  VpCreationBloc(this._repository, this._informationRepository) : super(VpCreationInitial())  {
    on<VpCreationRequested>(createVpApiCall);
    on<LogoutRequested>(logout);
    on<LogoutAPIRequested>(logOutApiCall);

  }


  // Vehicle provider creation api call
  Future<void> createVpApiCall(VpCreationRequested event, Emitter<VpCreationState> emit) async {
    emit(VpCreationLoading());
    Result result = await _repository.requestVpCreation(event.apiRequest, id: event.id);
    if (result is Success<UserModel?>) {
      emit(VpCreationSuccess(result.value));
    }
    if (result is Error) {
      emit(VpCreationError(result.type));
    }
  }

  //log Out
  Future<void> logOutApiCall(LogoutAPIRequested event, Emitter<VpCreationState> emit) async {
    emit(LogOutAPILoading());
    Result result = await _repository.logOut(event.apiRequest, );
    if (result is Success<LogOutResponse>) {
      emit(LogOutAPISuccess(result.value));
    }
    if (result is Error) {
      emit(VpCreationError(result.type));
    }
  }

  // Logout call
  Future<void> logout(event, emit) async {
    emit(LogoutLoading());
    Result result = await _repository.signOut(); // You must define this in your repository
    if (result is Success<bool>) {
      emit(LogoutSuccess());
    }
    if (result is Error) {
      emit(LogoutError(result.type));
    }
  }


}
