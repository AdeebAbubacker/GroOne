abstract class KavachProductsListEvent {}

class FetchKavachProducts extends KavachProductsListEvent {
  final String search;
  final int page;
  final bool isLoadMore;

  FetchKavachProducts({this.search = "", this.page = 1, this.isLoadMore = false});
}

class IncrementQuantity extends KavachProductsListEvent {
  final String productId;
  IncrementQuantity(this.productId);
}

class DecrementQuantity extends KavachProductsListEvent {
  final String productId;
  DecrementQuantity(this.productId);
}
