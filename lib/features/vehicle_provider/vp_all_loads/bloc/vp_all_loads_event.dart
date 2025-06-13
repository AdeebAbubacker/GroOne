import 'package:equatable/equatable.dart';

abstract class VpLoadEvent {}

class FetchVpLoads extends VpLoadEvent {
  final int type;
  final String search;
  final bool forceRefresh;

  FetchVpLoads({required this.type, this.search = "", this.forceRefresh = false});
}
