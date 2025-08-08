import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:meta/meta.dart';

part 'lp_home_event.dart';

part 'lp_home_state.dart';

class LpHomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserInformationRepository _userInformationRepository;
  LpHomeBloc(this._userInformationRepository) : super(HomeInitial());

  String? _userId;
  String? get userId => _userId;
  Future<String?> getUserId() async {
    _userId = await _userInformationRepository.getUserID();
    return _userId;
  }
}
