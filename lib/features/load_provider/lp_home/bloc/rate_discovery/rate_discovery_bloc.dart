import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/rate_discovery_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/rate_discovery_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';
import 'package:meta/meta.dart';

part 'rate_discovery_event.dart';
part 'rate_discovery_state.dart';

class RateDiscoveryBloc extends Bloc<RateDiscoveryEvent, RateDiscoveryState> {
  final LpHomeRepository _lpHomeRepository;
  RateDiscoveryBloc(this._lpHomeRepository) : super(RateDiscoveryInitial()) {
    on<RateDiscoveryEvent>(_onCreateLoadPosting);
  }

  //  Create Load Posting API call
  Future<void> _onCreateLoadPosting(RateDiscoveryEvent event, Emitter<RateDiscoveryState> emit) async {
    emit(RateDiscoveryLoading());
    dynamic result = await _lpHomeRepository.getRateDiscoveryData(event.apiRequest);
    if (result is Success<RateDiscoveryModel>) {
      emit(RateDiscoverySuccess(result.value));
    } else if (result is Error) {
      emit(RateDiscoveryError(result.type));
    }
  }

}
