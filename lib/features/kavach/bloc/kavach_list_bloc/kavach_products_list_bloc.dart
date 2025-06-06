import 'package:bloc/bloc.dart';
import '../../../../data/model/result.dart';
import '../../../../utils/toast_messages.dart';
import '../../model/kavach_product_model.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_products_list_event.dart';
import 'kavach_products_list_state.dart';

class KavachProductsListBloc extends Bloc<KavachProductsListEvent, KavachProductsListState> {
  final KavachRepository repository;

  KavachProductsListBloc(this.repository) : super(KavachProductsListState.initial()) {
    on<FetchKavachProducts>(_onFetch);
    on<IncrementQuantity>(_onIncrement);
    on<DecrementQuantity>(_onDecrement);
    on<TryIncrementQuantity>((event, emit) async {
      final stockResult = await repository.fetchAvailableStock(
        productId: event.productId,
      );

      if (stockResult is Success<int>) {
        final availableStock = stockResult.value;
        final currentQty = state.quantities[event.productId] ?? 0;

        if (currentQty < availableStock) {
          final updatedQuantities = Map<String, int>.from(state.quantities);
          updatedQuantities[event.productId] = currentQty + 1;
          emit(state.copyWith(quantities: updatedQuantities));
        } else {
          ToastMessages.alert(message: 'Unable to add more items');
        }
      } else if (stockResult is Error) {
        ToastMessages.error(message: 'Failed to check stock availability.');
      }
    });
    on<UpdateKavachQuantities>((event, emit) {
      // Emit updated quantities including zeros to reset them properly
      emit(state.copyWith(quantities: Map.from(event.updatedQuantities)));
    }); }

  // Future<void> _onFetch(FetchKavachProducts event, Emitter<KavachProductsListState> emit) async {
  //   if (state.loading) return;
  //
  //   emit(state.copyWith(loading: true, error: null));
  //
  //   final result = await repository.fetchProducts(search: event.search, page: event.page);
  //
  //   if (result is Success<List<KavachProduct>>) {
  //     final products = result.value;
  //     final newProductList = event.isLoadMore
  //         ? [...state.products, ...products]
  //         : products;
  //
  //     final updatedQuantities = Map<String, int>.from(state.quantities);
  //     for (var product in products) {
  //       updatedQuantities.putIfAbsent(product.id, () => 0);
  //     }
  //
  //     emit(state.copyWith(
  //       products: newProductList,
  //       quantities: updatedQuantities,
  //       loading: false,
  //       hasMore: products.isNotEmpty,
  //       currentPage: event.page,
  //     ));
  //   }
  //   if (result is Error<List<KavachProduct>>) {
  //     emit(state.copyWith(error: result.type, loading: false));
  //   }
  // }
  Future<void> _onFetch(FetchKavachProducts event, Emitter<KavachProductsListState> emit) async {
    if (state.loading) return;

    emit(state.copyWith(loading: true, error: null));

    final result = await repository.fetchProducts(search: event.search, page: event.page);

    if (result is Success<List<KavachProduct>>) {
      final products = result.value;
      final newProductList = event.isLoadMore
          ? [...state.products, ...products]
          : products;

      final updatedQuantities = Map<String, int>.from(state.quantities);
      final updatedAvailableStocks = Map<String, int>.from(state.availableStocks); // New map for stocks

      // Fetch available stock for each product (consider optimizing this if API can return it)
      for (var product in products) {
        updatedQuantities.putIfAbsent(product.id, () => 0);
        // Assuming you want to fetch stock for each product upon initial load
        final stockResult = await repository.fetchAvailableStock(productId: product.id);
        if (stockResult is Success<int>) {
          updatedAvailableStocks[product.id] = stockResult.value;
        } else {
          updatedAvailableStocks[product.id] = 0; // Default to 0 or handle error
        }
      }

      emit(state.copyWith(
        products: newProductList,
        quantities: updatedQuantities,
        availableStocks: updatedAvailableStocks, // Pass the updated stocks
        loading: false,
        hasMore: products.isNotEmpty,
        currentPage: event.page,
      ));
    }
    if (result is Error<List<KavachProduct>>) {
      emit(state.copyWith(error: result.type, loading: false));
    }
  }


  void _onIncrement(IncrementQuantity event, Emitter<KavachProductsListState> emit) {
    final updated = Map<String, int>.from(state.quantities);
    // updated[event.productId] = (updated[event.productId] ?? 1) + 1;
    updated[event.productId] = (updated[event.productId] ?? 0) + 1;

    emit(state.copyWith(quantities: updated));
  }

  void _onDecrement(DecrementQuantity event, Emitter<KavachProductsListState> emit) {
    final updated = Map<String, int>.from(state.quantities);
    final currentQty = updated[event.productId] ?? 0;

    if (currentQty > 0) {
      updated[event.productId] = currentQty - 1;
      emit(state.copyWith(quantities: updated));
    }
  }
}
class UpdateKavachQuantities extends KavachProductsListEvent {
  final Map<String, int> updatedQuantities;
  UpdateKavachQuantities(this.updatedQuantities);
}