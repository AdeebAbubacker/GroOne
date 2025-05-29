import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';
import 'package:meta/meta.dart';

part 'load_truck_type_event.dart';
part 'load_truck_type_state.dart';

class LoadTruckTypeBloc extends Bloc<LoadTruckTypeEvent, LoadTruckTypeState> {
  final LpHomeRepository _lpHomeRepository;
  LoadTruckTypeBloc(this._lpHomeRepository) : super(LoadTruckTypeInitial()) {
    on<LoadTruckTypeEvent>(_onLoadTruckType);
  }


  // Load Commodity Api Call
  Future<void> _onLoadTruckType(LoadTruckTypeEvent event, Emitter<LoadTruckTypeState> emit) async {
    emit(LoadTruckTypeLoading());
    dynamic result = await _lpHomeRepository.getTruckTypeData();
    if (result is Success<LoadTruckTypeListModel>) {
      print("Load Type Success");
      emit(LoadTruckTypeSuccess(result.value));
    } else if (result is Error) {
      emit(LoadTruckTypeError(result.type));
    }
  }

}
