part of 'vp_accept_load_bloc.dart';


sealed class VpAcceptLoadEvent {}

class VpAcceptLoad extends VpAcceptLoadEvent {
  final String loadId;
  VpAcceptLoad({required this.loadId});
}
