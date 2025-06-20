import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/model/lp_company_type_response.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/repository/create_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/log_out_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/log_out_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/repository/vp_creation_repository.dart';

part 'vp_creation_event.dart';
part 'vp_creation_state.dart';

class VpCreationBloc extends Bloc<VpCreationEvent, VpCreationState> {
  final VpCreationRepository _repository;
  final LpCreateRepository _lpCreateRepository;
  VpCreationBloc(this._repository, this._lpCreateRepository) : super(VpCreationInitial())  {
    on<VpCreationRequested>(createVpApiCall);
    on<LogoutRequested>(logout);
    on<LogoutAPIRequested>(logOutApiCall);
    on<GetTruckTypeEvent>(fetchTruckType);
    on<VpResetEvent>(resetUIState);
    on<VpCompanyTypeEvent>(fetchCompanyTypeApiCall);
    on<GetTruckPrefLaneEvent>(fetchTruckPrefLane);
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


  // Company type
  Future<void> fetchCompanyTypeApiCall(VpCompanyTypeEvent event, Emitter<VpCreationState> emit) async {
    emit(VpCompanyTypeLoading());
    Result result = await _lpCreateRepository.getCompanyType();
    if (result is Success<LpCompanyTypeResponse>) {
      emit(VpCompanyTypeSuccess(result.value));
    }
    if (result is Error) {
      emit(VpCompanyTypeError(result.type));
    }
  }


  // Get Truck Type Api Call
  Future<void> fetchTruckType(GetTruckTypeEvent event, Emitter<VpCreationState> emit) async {
    emit(TruckTypeLoading());
    Result result = await _repository.getTruckTypeData();
    if (result is Success<TruckTypeModel>) {
      emit(TruckTypeSuccess(result.value));
    }
    if (result is Error) {
      emit(VpCreationError(result.type));
    }
  }

  // Get Truck Pref Api Call
  Future<void> fetchTruckPrefLane(GetTruckPrefLaneEvent event, Emitter<VpCreationState> emit) async {
    emit(TruckPrefLaneLoading());
    Result result = await _repository.getPrefTruckLaneData(event.location);
    if (result is Success<TruckPrefLaneModel>) {
      emit(TruckPrefLaneSuccess(result.value));
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

  // Reset UI State
  void resetUIState(VpResetEvent event, Emitter emit) {
    emit(VpCreationInitial());
  }


}
