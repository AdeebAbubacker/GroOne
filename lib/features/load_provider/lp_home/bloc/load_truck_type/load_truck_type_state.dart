part of 'load_truck_type_bloc.dart';

@immutable
sealed class LoadTruckTypeState {}

/// Load Truck Type
class LoadTruckTypeInitial extends LoadTruckTypeState {}

class LoadTruckTypeLoading extends LoadTruckTypeState {}

class LoadTruckTypeSuccess extends LoadTruckTypeState {
  final List<LoadTruckTypeListModel> loadTruckTypeListModel;
  LoadTruckTypeSuccess(this.loadTruckTypeListModel);
}

class LoadTruckTypeError extends LoadTruckTypeState {
  final ErrorType errorType;
  LoadTruckTypeError(this.errorType);
}
