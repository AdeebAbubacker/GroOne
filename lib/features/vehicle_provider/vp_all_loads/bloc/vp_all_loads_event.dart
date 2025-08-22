import 'package:equatable/equatable.dart';

abstract class VpLoadEvent {}

class FetchVpLoads extends VpLoadEvent {
  final int type;
  final String search;
  final bool forceRefresh;

  // filter parameter

  final int? commodityId;
  final int? truckTypeId;
  final int? laneId;

  FetchVpLoads({
    required this.type,
    this.search = "",
    this.forceRefresh = false,
    this.commodityId,
    this.truckTypeId,
    this.laneId,
  });
}

class FetchLoadStatus extends VpLoadEvent {
  final bool forceRefresh;
  FetchLoadStatus({this.forceRefresh = false});
}
