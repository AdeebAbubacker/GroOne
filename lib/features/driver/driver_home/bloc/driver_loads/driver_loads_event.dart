part of 'driver_loads_bloc.dart';


abstract class DriverLoadsEvent {}

class FetchDriverLoads extends DriverLoadsEvent {
  final int? loadStatus;
  final String search;
  final int? laneId;
  final int? truckTypeId;
  final int? commodityTypeId;
  final int? page;
  final int? limit;
  final bool forceRefresh;
  final bool loadMore;

  FetchDriverLoads({this.loadStatus , this.search = "", this.laneId, this.truckTypeId,this.commodityTypeId,this.limit,this.page, this.forceRefresh = false,this.loadMore = false,});
}

class ChangeDriverLoadStatus extends DriverLoadsEvent {
  final String loadId;
  final int loadStatus;
  final String customerId;

  ChangeDriverLoadStatus({required this.loadId, required this.loadStatus,required this.customerId});
}

