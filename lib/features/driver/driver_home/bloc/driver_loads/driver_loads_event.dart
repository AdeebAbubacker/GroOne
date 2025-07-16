part of 'driver_loads_bloc.dart';


abstract class DriverLoadsEvent {}

class FetchDriverLoads extends DriverLoadsEvent {
  final int type;
  final String search;
  final bool forceRefresh;

  FetchDriverLoads({required this.type, this.search = "", this.forceRefresh = false});
}
