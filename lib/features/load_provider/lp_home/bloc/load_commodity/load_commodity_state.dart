part of 'load_commodity_bloc.dart';

@immutable
sealed class LoadCommodityState {}

final class LoadCommodityInitial extends LoadCommodityState {}

class LoadCommodityLoading extends LoadCommodityState {}

class LoadCommoditySuccess extends LoadCommodityState {
  final List<LoadCommodityListModel> commodityListModel;
  LoadCommoditySuccess(this.commodityListModel);
}

class LoadCommodityError extends LoadCommodityState {
  final ErrorType errorType;
  LoadCommodityError(this.errorType);
}



