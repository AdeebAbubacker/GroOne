part of 'gps_products_cubit.dart';

class GpsProductsState extends Equatable {
  final List<GpsProduct> products;
  final GpsProductListMeta? meta;
  final bool hasMorePages;
  final String searchQuery;
  final UIState<GpsProductListResponse>? productsState;

  const GpsProductsState({
    required this.products,
    this.meta,
    required this.hasMorePages,
    required this.searchQuery,
    this.productsState,
  });

  factory GpsProductsState.initial() {
    return const GpsProductsState(
      products: [],
      hasMorePages: false,
      searchQuery: '',
      productsState: null,
    );
  }

  GpsProductsState copyWith({
    List<GpsProduct>? products,
    GpsProductListMeta? meta,
    bool? hasMorePages,
    String? searchQuery,
    UIState<GpsProductListResponse>? productsState,
  }) {
    return GpsProductsState(
      products: products ?? this.products,
      meta: meta ?? this.meta,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      searchQuery: searchQuery ?? this.searchQuery,
      productsState: productsState ?? this.productsState,
    );
  }

  @override
  List<Object?> get props => [
        products,
        meta,
        hasMorePages,
        searchQuery,
        productsState,
      ];

  @override
  String toString() {
    return 'GpsProductsState{products: ${products.length}, hasMorePages: $hasMorePages, searchQuery: $searchQuery, productsState: $productsState}';
  }
} 