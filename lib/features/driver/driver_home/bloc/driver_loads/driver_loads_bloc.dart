import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/features/driver/driver_home/repository/driver_load_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';

part 'driver_loads_event.dart';
part 'driver_loads_state.dart';



class DriverLoadsBloc extends Bloc<DriverLoadsEvent, DriverLoadsState> {
  final DriverLoadRepository repo;

  DriverLoadsBloc(this.repo) : super(DriverLoadsInitial()) {
    on<FetchDriverLoads>((event, emit) async {
      emit(DriverLoadsLoading());
      final result = await repo.fetchDriverLoads(
        loadStatus: event.loadStatus,
        search: event.search,
        laneId: event.laneId,
        truckTypeId: event.truckTypeId, 
        commodityTypeId: event.commodityTypeId,  
        forceRefresh: event.forceRefresh
        );
      if (result is Success<List<DriverLoadDetails>>) {
        emit(DriverLoadsLoaded(result.value));
      } else {
        emit(DriverLoadsError("Failed to load data"));
      }
    });

  on<ChangeDriverLoadStatus>((event, emit) async {
      emit(DriverLoadStatusChanging());

      final userId = await repo.userRepo.getUserID() ?? "";
      final result = await repo.changeLoadStatus(
        customerId: event.customerId,
        loadId: event.loadId,
        loadStatus: event.loadStatus,
        
      );

      if (result is Success<VpLoadAcceptModel>) {
        emit(DriverLoadStatusChanged(result.value));
      } else if (result is Error) {
        emit(DriverLoadStatusChangeFailed("Failed to change status"));
      } else {
        emit(DriverLoadStatusChangeFailed("Unknown error occurred"));
      }
    });
  }
}

