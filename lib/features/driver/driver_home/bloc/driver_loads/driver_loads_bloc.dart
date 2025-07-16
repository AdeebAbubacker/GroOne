import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/features/driver/driver_home/repository/driver_load_repository.dart';

part 'driver_loads_event.dart';
part 'driver_loads_state.dart';



class DriverLoadsBloc extends Bloc<DriverLoadsEvent, DriverLoadsState> {
  final DriverLoadRepository repo;

  DriverLoadsBloc(this.repo) : super(DriverLoadsInitial()) {
    on<FetchDriverLoads>((event, emit) async {
      emit(DriverLoadsLoading());
      final result = await repo.fetchDriverLoads(type: event.type,search: event.search,forceRefresh: event.forceRefresh);
      if (result is Success<List<DriverLoadDetails>>) {
        emit(DriverLoadsLoaded(result.value));
      } else {
        emit(DriverLoadsError("Failed to load data"));
      }
    });
  }
}

