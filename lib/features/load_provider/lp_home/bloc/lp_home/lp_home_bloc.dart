import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/get_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:meta/meta.dart';

part 'lp_home_event.dart';

part 'lp_home_state.dart';

class LpHomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserInformationRepository _userInformationRepository;
  final LpHomeRepository _lpHomeRepository;

  LpHomeBloc(this._lpHomeRepository, this._userInformationRepository) : super(HomeInitial()) {

    on<GetProfileDetailApiRequest>((event, emit) async {
      emit(ProfileLoading());
      Result result = await _lpHomeRepository.getUserDetails(userId: event.userId);
      if (result is Success<ProfileDetailModel>) {
        emit(ProfileDetailSuccess(result.value));
      } else if (result is Error) {
        emit(ProfileDetailError(result.type));
      } else {
        emit(ProfileDetailError(GenericError()));
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
