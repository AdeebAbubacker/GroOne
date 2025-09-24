import 'package:bloc/bloc.dart';
import '../../../../data/model/result.dart';
import '../../../../utils/toast_messages.dart';
import '../../model/kavach_product_model.dart';
import '../../model/kavach_masters_model.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_products_list_event.dart';
import 'kavach_products_list_state.dart';

class KavachProductsListBloc
    extends Bloc<KavachProductsListEvent, KavachProductsListState> {
  final KavachRepository repository;

  KavachProductsListBloc(this.repository)
    : super(KavachProductsListState.initial()) {
    on<FetchKavachProducts>(_onFetch);
    on<FetchMastersData>(_onFetchMastersData);
    on<UpdateUserPreferences>(_onUpdateUserPreferences);
    on<IncrementQuantity>(_onIncrement);
    on<DecrementQuantity>(_onDecrement);
    on<TryIncrementQuantity>(_onTryIncrementQuantity);
    on<UpdateKavachQuantities>(_onUpdateKavachQuantities);
    on<ClearKavachQuantities>(_onClearKavachQuantities);
  }

  /// Handles fetching Kavach products with optional search and preferences
  Future<void> _onFetch(
    FetchKavachProducts event,
    Emitter<KavachProductsListState> emit,
  ) async {
    if (state.loading) return;

    emit(state.copyWith(loading: true, error: null));

    final result = await repository.fetchProducts(
      search: event.search,
      page: event.page,
      preferences: event.preferences,
    );

    final updatedProductsById =
        state.allProductsById != null
            ? Map<String, KavachProduct>.from(state.allProductsById!)
            : <String, KavachProduct>{};

    if (result is Success<List<KavachProduct>>) {
      final products = result.value;

      for (final product in products) {
        updatedProductsById[product.id] = product;
      }

      final newProductList =
          event.isLoadMore ? [...state.products, ...products] : products;

      final updatedQuantities = Map<String, int>.from(state.quantities);
      final updatedAvailableStocks = Map<String, int>.from(
        state.availableStocks,
      );

      for (var product in products) {
        updatedQuantities.putIfAbsent(product.id, () => 0);

        final stockResult = await repository.fetchAvailableStock(
          productId: product.id,
        );
        if (stockResult is Success<int>) {
          updatedAvailableStocks[product.id] = stockResult.value;
        } else {
          updatedAvailableStocks[product.id] = 0;
        }
      }

      emit(
        state.copyWith(
          products: newProductList,
          quantities:
              event.quantities != null && event.quantities!.isNotEmpty
                  ? event.quantities
                  : updatedQuantities,
          availableStocks: updatedAvailableStocks,
          loading: false,
          hasMore: products.isNotEmpty,
          allProductsById: updatedProductsById,
          currentPage: event.page,
        ),
      );
    } else if (result is Error<List<KavachProduct>>) {
      emit(state.copyWith(error: result.type, loading: false));
    }
  }

  /// Fetches masters data for vehicle preferences
  Future<void> _onFetchMastersData(
    FetchMastersData event,
    Emitter<KavachProductsListState> emit,
  ) async {
    emit(state.copyWith(mastersLoading: true, mastersError: null));

    final result = await repository.getMasters();

    if (result is Success<KavachMastersModel>) {
      emit(state.copyWith(mastersData: result.value, mastersLoading: false));
    } else if (result is Error<KavachMastersModel>) {
      emit(state.copyWith(mastersError: result.type, mastersLoading: false));
    }
  }

  /// Updates user preferences and optionally refetches products with filters
  void _onUpdateUserPreferences(
    UpdateUserPreferences event,
    Emitter<KavachProductsListState> emit,
  ) {
    emit(state.copyWith(userPreferences: event.preferences));
  }

  /// Handles incrementing product quantity
  void _onIncrement(
    IncrementQuantity event,
    Emitter<KavachProductsListState> emit,
  ) {
    final updated = Map<String, int>.from(state.quantities);
    updated[event.productId] = (updated[event.productId] ?? 0) + 1;

    emit(state.copyWith(quantities: updated));
  }

  /// Handles decrementing product quantity
  void _onDecrement(
    DecrementQuantity event,
    Emitter<KavachProductsListState> emit,
  ) {
    final updated = Map<String, int>.from(state.quantities);
    final currentQty = updated[event.productId] ?? 0;

    if (currentQty > 0) {
      updated[event.productId] = currentQty - 1;
      emit(state.copyWith(quantities: updated));
    }
  }

  /// Handles trying to increment quantity with stock validation
  Future<void> _onTryIncrementQuantity(
    TryIncrementQuantity event,
    Emitter<KavachProductsListState> emit,
  ) async {
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
  }

  /// Updates Kavach quantities with new values
  void _onUpdateKavachQuantities(
    UpdateKavachQuantities event,
    Emitter<KavachProductsListState> emit,
  ) {
    // Emit updated quantities including zeros to reset them properly
    emit(state.copyWith(quantities: Map.from(event.updatedQuantities)));
  }

  /// Clears Kavach quantities
  void _onClearKavachQuantities(
    ClearKavachQuantities event,
    Emitter<KavachProductsListState> emit,
  ) {
    emit(state.copyWith(quantities: {}));
  }
}
