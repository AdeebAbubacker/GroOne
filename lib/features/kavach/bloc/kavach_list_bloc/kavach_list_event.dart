abstract class KavachEvent {}

class FetchKavachProducts extends KavachEvent {
  final String search;
  FetchKavachProducts({this.search = ""});
}

class IncrementQuantity extends KavachEvent {
  final String productId;
  IncrementQuantity(this.productId);
}

class DecrementQuantity extends KavachEvent {
  final String productId;
  DecrementQuantity(this.productId);
}
