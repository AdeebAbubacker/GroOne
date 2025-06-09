abstract class KavachOrderListEvent {}

// class FetchKavachOrderList extends KavachOrderListEvent {
//   final bool isRefresh;
//   FetchKavachOrderList({this.isRefresh = false});
// }
class FetchKavachOrderList extends KavachOrderListEvent {
  final bool isRefresh;
  final int? status; // Nullable for "All"
  final bool forceRefresh; // Nullable for "All"

  FetchKavachOrderList({this.isRefresh = false, this.forceRefresh = false, this.status});
}
