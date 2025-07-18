import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';
import 'package:meta/meta.dart';

part 'load_commodity_event.dart';
part 'load_commodity_state.dart';

class LoadCommodityBloc extends Bloc<LoadCommodityEvent, LoadCommodityState> {
  final LpHomeRepository _lpHomeRepository;
  LoadCommodityBloc(this._lpHomeRepository) : super(LoadCommodityInitial()) {
    on<LoadCommodityEvent>(_onLoadCommodity);
  }

  // Load Commodity Api Call
  Future<void> _onLoadCommodity(LoadCommodityEvent event, Emitter<LoadCommodityState> emit) async {
    emit(LoadCommodityLoading());
    dynamic result = await _lpHomeRepository.getLoadCommodityData();
    if (result is Success<List<LoadCommodityListModel>>) {
      emit(LoadCommoditySuccess(result.value));
    } else if (result is Error) {
      emit(LoadCommodityError(result.type));
    }
  }

}
