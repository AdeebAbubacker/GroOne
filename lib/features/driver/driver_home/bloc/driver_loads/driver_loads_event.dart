part of 'driver_loads_bloc.dart';


abstract class DriverLoadsEvent {}

class FetchDriverLoads extends DriverLoadsEvent {
  final int? loadStatus;
  final String search;
  final int? laneId;
  final bool forceRefresh;

  FetchDriverLoads({this.loadStatus , this.search = "", this.laneId, this.forceRefresh = false});
}
