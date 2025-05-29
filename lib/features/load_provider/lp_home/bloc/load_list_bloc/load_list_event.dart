part of 'load_list_bloc.dart';

@immutable
sealed class LoadListEvent {}
class GetLoadRequested extends LoadListEvent {
  final  String userId;
  GetLoadRequested(this.userId);
}class GetLoadDetailsRequested extends LoadListEvent {
  final  String userId;
  GetLoadDetailsRequested(this.userId);
}