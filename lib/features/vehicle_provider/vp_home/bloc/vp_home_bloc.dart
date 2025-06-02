import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/repository/vp_repository.dart';
import 'package:gro_one_app/utils/extensions/nullable_extensions.dart';
import 'package:meta/meta.dart';

part 'vp_home_event.dart';

part 'vp_home_state.dart';

class VpHomeBloc extends Bloc<VpHomeEvent, VpHomeState> {
  final VpHomeRepository _vHomeRepository;
  final UserInformationRepository _userInformationRepository;

  VpHomeBloc(this._vHomeRepository, this._userInformationRepository) : super(VpHomeInitial()) {

    on<VpMyLoadListRequested>((event, emit) async {
      emit(VpMyLoadListLoading());

      Result result = await _vHomeRepository.getVpMyLoad(await _userInformationRepository.getUserID()??'');

      if (result is Success<VpMyLoadResponse>) {
        emit(VpMyLoadListSuccess(result.value));
      } else if (result is Error) {
        emit(VpMyLoadListError(result.type));
      } else {
        emit(VpMyLoadListError(GenericError()));
      }
    });

    on<VpVehicleListRequested>((event, emit) async {
      emit(VpMyLoadListLoading());
      Result result = await _vHomeRepository.getVehicleDetails(
        userId: event.userId,
      );

      if (result is Success<VehicleListResponse>) {
        emit(VpVehicleListSuccess(result.value));
      } else if (result is Error) {
        emit(VpMyLoadListError(result.type));
      } else {
        emit(VpMyLoadListError(GenericError()));
      }
    });



    on<VpDriverDetailsRequested>((event, emit) async {
      emit(VpMyLoadListLoading());
      Result result = await _vHomeRepository.getDriverDetails(
        userId: event.userId,
      );

      if (result is Success<DriverListResponse>) {
        emit(VpDriverListSuccess(result.value));
      } else if (result is Error) {
        emit(VpMyLoadListError(result.type));
      } else {
        emit(VpMyLoadListError(GenericError()));
      }
    });

    on<ScheduleTripRequested>((event, emit) async {
      emit(ScheduleTripLoading());
      Result result = await _vHomeRepository.scheduleTripResponse(
        apiRequest: event.apiRequest,
      );

      if (result is Success<ScheduleTripResponse>) {
        emit(ScheduleTripSuccess(result.value));
      } else if (result is Error) {
        emit(ScheduleTripError(result.type));
      } else {
        emit(ScheduleTripError(GenericError()));
      }
    });
  }

  String? _userId;

  String? get userId => _userId;

  Future<String?> getUserId() async {
    _userId = await _userInformationRepository.getUserID();
    return _userId;
  }
}
