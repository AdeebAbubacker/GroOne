part of 'load_truck_type_bloc.dart';

@immutable
sealed class LoadTruckTypeEvent {}

class LoadTruckType extends LoadTruckTypeEvent {
  LoadTruckType();
}