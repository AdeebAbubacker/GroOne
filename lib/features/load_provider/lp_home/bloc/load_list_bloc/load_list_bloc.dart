import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/get_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_detail_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';
import 'package:meta/meta.dart';

part 'load_list_event.dart';

part 'load_list_state.dart';

class LoadListBloc extends Bloc<LoadListEvent, LoadListState> {
  final LpHomeRepository _lpHomeRepository;

  LoadListBloc(this._lpHomeRepository) : super(LoadListInitial()) {
    on<GetLoadRequested>((event, emit) async {
      emit(GetLoadLoading());
      Result result = await _lpHomeRepository.getLoads(
        userId: event.userId ?? "",
      );

      if (result is Success<GetLoadResponse>) {
        emit(GetLoadSuccess(result.value));
      } else if (result is Error) {
        emit(GetLoadError(result.type));
      } else {
        emit(GetLoadError(GenericError()));
      }
    });
    on<GetLoadDetailsRequested>((event, emit) async {
      emit(GetLoadLoading());
      Result result = await _lpHomeRepository.getLoadDetails(
        userId: event.userId ?? "",
      );

      if (result is Success<LoadDetailResponse>) {
        emit(GetLoadDetailsSuccess(result.value));
      } else if (result is Error) {
        emit(GetLoadError(result.type));
      } else {
        emit(GetLoadError(GenericError()));
      }
    });
  }
}
