part of 'driver_loads_bloc.dart';


abstract class DriverLoadsEvent {}

class FetchDriverLoads extends DriverLoadsEvent {
  final int? loadStatus;
  final String search;
  final int? laneId;
  final int? truckTypeId;
  final int? commodityTypeId;
  final bool forceRefresh;

  FetchDriverLoads({this.loadStatus , this.search = "", this.laneId, this.truckTypeId,this.commodityTypeId, this.forceRefresh = false});
}

class ChangeDriverLoadStatus extends DriverLoadsEvent {
  final String loadId;
  final int loadStatus;
  final String customerId;

  ChangeDriverLoadStatus({required this.loadId, required this.loadStatus,required this.customerId});
}
