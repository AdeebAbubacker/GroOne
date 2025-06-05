import 'package:equatable/equatable.dart';
import '../../../../data/model/result.dart';
import '../../model/kavach_product_model.dart';
import 'package:collection/collection.dart';


class KavachProductsListState extends Equatable {
  final List<KavachProduct> products;
  final Map<String, int> quantities;
  final Map<String, int> availableStocks; // Add this
  final bool loading;
  final bool hasMore;
  final int currentPage;
  final ErrorType? error;

  const KavachProductsListState({
    required this.products,
    required this.quantities,
    required this.availableStocks, // Initialize this
    this.loading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
  });

  factory KavachProductsListState.initial() {
    return const KavachProductsListState(
      products: [],
      quantities: {},
      availableStocks: {}, // Initialize to empty map
      loading: false,
      hasMore: true,
      currentPage: 1,
      error: null,
    );
  }

  KavachProductsListState copyWith({
    List<KavachProduct>? products,
    Map<String, int>? quantities,
    Map<String, int>? availableStocks, // Add to copyWith
    bool? loading,
    bool? hasMore,
    int? currentPage,
    ErrorType? error,
  }) {
    return KavachProductsListState(
      products: products ?? this.products,
      quantities: quantities ?? this.quantities,
      availableStocks: availableStocks ?? this.availableStocks, // Update this
      loading: loading ?? this.loading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    products,
    MapEquality().equals(quantities, quantities) ? Object() : quantities,
    MapEquality().equals(availableStocks, availableStocks) ? Object() : availableStocks, // Add to props
    loading,
    hasMore,
    currentPage,
    error,
  ];
}
// class KavachProductsListState extends Equatable {
//   final List<KavachProduct> products;
//   final Map<String, int> quantities;
//   final bool loading;
//   final bool hasMore;
//   final int currentPage;
//   final ErrorType? error;
//
//   const KavachProductsListState({
//     required this.products,
//     required this.quantities,
//     this.loading = false,
//     this.hasMore = true,
//     this.currentPage = 1,
//     this.error,
//   });
//
//   factory KavachProductsListState.initial() {
//     return const KavachProductsListState(
//       products: [],
//       quantities: {},
//       loading: false,
//       hasMore: true,
//       currentPage: 1,
//       error: null,
//     );
//   }
//
//   KavachProductsListState copyWith({
//     List<KavachProduct>? products,
//     Map<String, int>? quantities,
//     bool? loading,
//     bool? hasMore,
//     int? currentPage,
//     ErrorType? error,
//   }) {
//     return KavachProductsListState(
//       products: products ?? this.products,
//       quantities: quantities ?? this.quantities,
//       loading: loading ?? this.loading,
//       hasMore: hasMore ?? this.hasMore,
//       currentPage: currentPage ?? this.currentPage,
//       error: error,
//     );
//   }
//
//   // @override
//   // List<Object?> get props => [products, quantities, loading, hasMore, currentPage, error];
//
//   @override
//   List<Object?> get props => [
//     products,
//     MapEquality().equals(quantities, quantities) ? Object() : quantities,
//     loading,
//     hasMore,
//     currentPage,
//     error,
//   ];
//
// }


