abstract class KavachOrderListEvent {}

// class FetchKavachOrderList extends KavachOrderListEvent {
//   final bool isRefresh;
//   FetchKavachOrderList({this.isRefresh = false});
// }
class FetchKavachOrderList extends KavachOrderListEvent {
  final bool isRefresh;
  final int? status;
  final bool forceRefresh;

  FetchKavachOrderList({this.isRefresh = false, this.forceRefresh = false, this.status});
}


class DownloadInvoiceEvent extends KavachOrderListEvent {
  final String orderId;
  DownloadInvoiceEvent(this.orderId);
}
