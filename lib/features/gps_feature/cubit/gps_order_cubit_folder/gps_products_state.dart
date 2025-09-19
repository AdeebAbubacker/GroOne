part of 'gps_products_cubit.dart';

class GpsProductsState extends Equatable {
  final List<GpsProduct> products;
  final GpsProductListMeta? meta;
  final bool hasMorePages;
  String searchQuery;
  final UIState<GpsProductListResponse>? productsState;
  Map<String, int> quantities;
  final Map<String, int> availableStocks;
  bool? refreshModelList;
  bool refresh;

  GpsProductsState({
    required this.products,
    this.meta,
    required this.hasMorePages,
    required this.searchQuery,
    this.productsState,
    required this.quantities,
    required this.availableStocks,
    this.refreshModelList,
    this.refresh = false,
  });

  factory GpsProductsState.initial() {
    return GpsProductsState(
      products: [],
      hasMorePages: false,
      searchQuery: '',
      productsState: null,
      quantities: {},
      availableStocks: {},
      refreshModelList: false,
    );
  }

  GpsProductsState copyWith({
    List<GpsProduct>? products,
    GpsProductListMeta? meta,
    bool? hasMorePages,
    bool? refresh,
    String? searchQuery,
    UIState<GpsProductListResponse>? productsState,
    Map<String, int>? quantities,
    Map<String, int>? availableStocks,
    bool? refreshModelList,
  }) {
    return GpsProductsState(
      products: products ?? this.products,
      meta: meta ?? this.meta,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      searchQuery: searchQuery ?? this.searchQuery,
      productsState: productsState ?? this.productsState,
      quantities: quantities ?? this.quantities,
      availableStocks: availableStocks ?? this.availableStocks,
      refreshModelList: refreshModelList ?? this.refreshModelList,
      refresh: refresh ?? this.refresh,
    );
  }

  @override
  List<Object?> get props => [
    products,
    meta,
    hasMorePages,
    searchQuery,
    productsState,
    quantities,
    availableStocks,
  ];

  @override
  String toString() {
    return 'GpsProductsState{products: ${products.length}, hasMorePages: $hasMorePages, searchQuery: $searchQuery, productsState: $productsState, quantities: $quantities, availableStocks: $availableStocks}';
  }
}
