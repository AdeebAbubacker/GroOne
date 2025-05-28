import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/api_request/profile_update_request.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/model/profile_update_response.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/repository/profile_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;
  final UserInformationRepository _userInformationRepository;
  ProfileBloc(this._repository,this._userInformationRepository) : super(ProfileInitial()) {
    on<ProfileUpdateRequested>((event, emit) async {
      emit(ProfileUpdateLoading());
      Result result = await _repository.updateProfileData(event.apiRequest,userId: event.userID);

      if (result is Success<ProfileUpdateResponse>) {
        emit(ProfileUpdateSuccess(result.value));
      } else if (result is Error) {
        emit(ProfileUpdateError(result.type));
      } else {
        emit(ProfileUpdateError(GenericError()));
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
