abstract class KavachProductsListEvent {}

class FetchKavachProducts extends KavachProductsListEvent {
  final String search;
  final int page;
  final bool isLoadMore;
  final Map<String, String?>? preferences;

  FetchKavachProducts({this.search = "", this.page = 1, this.isLoadMore = false,this.preferences,});
}

class FetchMastersData extends KavachProductsListEvent {}

class UpdateUserPreferences extends KavachProductsListEvent {
  final Map<String, String?> preferences;
  
  UpdateUserPreferences(this.preferences);
}

class IncrementQuantity extends KavachProductsListEvent {
  final String productId;
  IncrementQuantity(this.productId);
}

class DecrementQuantity extends KavachProductsListEvent {
  final String productId;
  DecrementQuantity(this.productId);
}

class TryIncrementQuantity extends KavachProductsListEvent {
  final String productId;
  TryIncrementQuantity({required this.productId});
}

class UpdateKavachQuantities extends KavachProductsListEvent {
  final Map<String, int> updatedQuantities;
  UpdateKavachQuantities(this.updatedQuantities);
}
