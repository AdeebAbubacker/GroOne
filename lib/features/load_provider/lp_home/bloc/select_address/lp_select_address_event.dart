part of 'lp_select_address_bloc.dart';

@immutable
sealed class LpMapSelectPickPointEvent {}

class FetchCurrentLatLong extends LpMapSelectPickPointEvent {}

