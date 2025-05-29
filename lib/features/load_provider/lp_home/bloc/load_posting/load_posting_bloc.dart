import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/create_load_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:meta/meta.dart';

part 'load_posting_event.dart';
part 'load_posting_state.dart';

class LoadPostingBloc extends Bloc<LoadPostingEvent, LoadPostingState> {
  final UserInformationRepository _informationRepository;
  final LpHomeRepository _lpHomeRepository;
  LoadPostingBloc(this._informationRepository, this._lpHomeRepository) : super(CreateLoadPostInitial()) {
    getUserId();
    on<CreateLoadPostingEvent>(_onCreateLoadPosting);
  }

  // Get user Id
  String? _userId;
  String? get userId => _userId;
  Future<String?> getUserId() async {
    _userId = await _informationRepository.getUserID();
    return _userId;
  }


  //  Create Load Posting API call
  Future<void> _onCreateLoadPosting(CreateLoadPostingEvent event, Emitter<LoadPostingState> emit) async {
    emit(CreateLoadLoading());
    dynamic result = await _lpHomeRepository.getCreateLoadData(event.apiRequest);
    if (result is Success<CreateLoadModel>) {
      emit(CreateLoadSuccess(result.value));
    } else if (result is Error) {
      emit(CreateLoadError(result.type));
    }
  }


}
