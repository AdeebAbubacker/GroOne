import '../../model/kavach_order_list_model.dart';

abstract class KavachOrderListState {}

class KavachOrderListInitial extends KavachOrderListState {}

class KavachOrderListLoading extends KavachOrderListState {}

class KavachOrderListLoaded extends KavachOrderListState {
  final List<KavachOrderListOrderItem> orders;
  final bool hasReachedMax;
  final int page;

  KavachOrderListLoaded({
    required this.orders,
    required this.hasReachedMax,
    required this.page,
  });

  KavachOrderListLoaded copyWith({
    List<KavachOrderListOrderItem>? orders,
    bool? hasReachedMax,
    int? page,
  }) {
    return KavachOrderListLoaded(
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }
}

class KavachOrderListError extends KavachOrderListState {
  final String message;

  KavachOrderListError(this.message);
}

class InvoiceDownloading extends KavachOrderListState {}

class InvoiceDownloaded extends KavachOrderListState {
  final String url;
  InvoiceDownloaded(this.url);
}