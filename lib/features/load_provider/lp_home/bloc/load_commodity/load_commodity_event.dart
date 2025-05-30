part of 'load_commodity_bloc.dart';

@immutable
sealed class LoadCommodityEvent {}

class LoadCommodity extends LoadCommodityEvent {
  LoadCommodity();
}


