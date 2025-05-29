import '../../model/kavach_product.dart';

class KavachState {
  final List<KavachProduct> products;
  final Map<String, int> quantities;
  final bool loading;
  final String? error;

  KavachState({
    required this.products,
    required this.quantities,
    this.loading = false,
    this.error,
  });

  KavachState copyWith({
    List<KavachProduct>? products,
    Map<String, int>? quantities,
    bool? loading,
    String? error,
  }) {
    return KavachState(
      products: products ?? this.products,
      quantities: quantities ?? this.quantities,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  factory KavachState.initial() => KavachState(products: [], quantities: {});
}
