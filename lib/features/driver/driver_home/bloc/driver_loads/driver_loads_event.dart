part of 'driver_loads_bloc.dart';


abstract class DriverLoadsEvent {}

class FetchDriverLoads extends DriverLoadsEvent {
  final int loadStatus;
  final String search;
  final bool forceRefresh;

  FetchDriverLoads({required this.loadStatus, this.search = "", this.forceRefresh = false});
}
