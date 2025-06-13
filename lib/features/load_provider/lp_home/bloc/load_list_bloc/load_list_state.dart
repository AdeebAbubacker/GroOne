part of 'load_list_bloc.dart';

@immutable
sealed class LoadListState {}

final class LoadListInitial extends LoadListState {}
class GetLoadLoading extends LoadListState {}

class GetLoadDetailsLoading extends LoadListState {}

class GetLoadSuccess extends LoadListState {
  final LPGetLoadModel getLoadResponse;

  GetLoadSuccess(this.getLoadResponse);
}
class GetLoadDetailsSuccess extends LoadListState {
  final LoadDetailResponse loadDetailResponse;

  GetLoadDetailsSuccess(this.loadDetailResponse);
}
class GetLoadError extends LoadListState {
  final ErrorType errorType;

  GetLoadError(this.errorType);
}
