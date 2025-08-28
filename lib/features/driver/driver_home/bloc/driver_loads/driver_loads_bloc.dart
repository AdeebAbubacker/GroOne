import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/features/driver/driver_home/repository/driver_load_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';

part 'driver_loads_event.dart';
part 'driver_loads_state.dart';



class DriverLoadsBloc extends Bloc<DriverLoadsEvent, DriverLoadsState> {
  final DriverLoadRepository repo;
  int _currentPage = 1;
  bool _isLastPage = false;
  bool _isLoadingMore = false;

  DriverLoadsBloc(this.repo) : super(DriverLoadsInitial()) {
   on<FetchDriverLoads>((event, emit) async {
  if (_isLoadingMore && event.loadMore == true) return;
  
  if (!event.loadMore) {
    _currentPage = 1;
    _isLastPage = false;
    emit(DriverLoadsLoading());
  } else if (_isLastPage) {
    return;
  }

  if (event.loadMore) {
    _isLoadingMore = true;
    _currentPage++;
  }

  try {
    final result = await repo.fetchDriverLoads(
      loadStatus: event.loadStatus,
      search: event.search,
      laneId: event.laneId,
      truckTypeId: event.truckTypeId,
      commodityTypeId: event.commodityTypeId,
      limit: event.limit,
      page: _currentPage,
      forceRefresh: event.forceRefresh,
    );

    if (result is Success<DriverListDataDetails>) {
      final newData = result.value;
      if (event.loadMore && state is DriverLoadsLoaded) {
        final existingData = (state as DriverLoadsLoaded).loads;
        // Combine existing and new data lists as appropriate
        final combinedData = existingData.copyWith(
          // Assuming data is a list inside DriverListDataDetails
          data: [...existingData.data, ...newData.data],
          // Copy other fields if necessary
        );
        emit(DriverLoadsLoaded(combinedData));
      } else {
        emit(DriverLoadsLoaded(newData));
      }
      // Update last page flag based on your API's pagination metadata
      _isLastPage = result.value.pageMeta?.nextPage == null || 
                    result.value.pageMeta?.pageCount == _currentPage;
    } else if (result is Error<DriverListDataDetails>) {
      emit(DriverLoadsError("Failed to load data"));
    }
  } finally {
    _isLoadingMore = false;
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
      } else if (result is Error<VpLoadAcceptModel>) {
        emit(DriverLoadStatusChangeFailed(result.type));
      } else {
       emit(DriverLoadsError("Something went wrong"));
      }
    });
  }
}

