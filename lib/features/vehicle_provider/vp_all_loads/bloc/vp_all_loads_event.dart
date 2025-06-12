import 'package:equatable/equatable.dart';

abstract class VpLoadEvent {}

class FetchVpLoads extends VpLoadEvent {
  final int type;
  final String search;
  FetchVpLoads({required this.type, this.search = ""});
}
