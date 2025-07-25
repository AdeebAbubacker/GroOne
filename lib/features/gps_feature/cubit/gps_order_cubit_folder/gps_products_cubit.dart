import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';

part 'gps_products_state.dart';

class GpsProductsCubit extends Cubit<GpsProductsState> {
  final GpsOrderApiRepository _repository;
  bool _isClosed = false;

  GpsProductsCubit(this._repository) : super(GpsProductsState.initial());

  @override
  Future<void> close() {
    print('🔒 GpsProductsCubit.close() called');
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    print('🔄 Resetting GpsProductsCubit state');
    _isClosed = false;
    emit(GpsProductsState.initial());
  }

  /// Fetch GPS Products
  Future<void> fetchGpsProducts({
    int fleetProductId = 1,
    int page = 1,
    int limit = 10,
  }) async {
    print('🔍 GpsProductsCubit.fetchGpsProducts called');
    if (_isClosed) {
      print('🔍 Cubit is closed, returning early');
      return;
    }

    _setProductsUIState(UIState.loading());

    try {
      final request = GpsProductListRequest(
        fleetProductId: fleetProductId,
        page: page,
        limit: limit,
      );

      final result = await _repository.fetchGpsProducts(request);

      if (_isClosed) {
        print('🔍 Cubit is closed after API call, returning early');
        return;
      }

      if (result is Success<GpsProductListResponse>) {
        final response = result.value;
        print('🔍 GPS Products fetched successfully: ${response.data?.rows.length} products');
        
        final updatedQuantities = Map<String, int>.from(state.quantities);
        final updatedAvailableStocks = Map<String, int>.from(state.availableStocks);

        // Fetch available stock for each product
        for (var product in response.data?.rows ?? []) {
          updatedQuantities.putIfAbsent(product.id, () => 0);
          
          // Fetch stock for each product upon initial load
          final stockResult = await _repository.fetchAvailableStock(productId: product.id);
          if (stockResult is Success<int>) {
            updatedAvailableStocks[product.id] = stockResult.value;
          } else {
            updatedAvailableStocks[product.id] = 0;
          }
        }
        
        emit(state.copyWith(
          products: response.data?.rows ?? [],
          meta: response.data?.meta,
          hasMorePages: (response.data?.meta.totalPages ?? 0) > page,
          quantities: updatedQuantities,
          availableStocks: updatedAvailableStocks,
        ));
        _setProductsUIState(UIState.success(response));
      } else if (result is Error) {
        print('❌ GPS Products fetch failed: ${(result as Error).type}');
        _setProductsUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      print('💥 GPS Products fetch exception: $e');
      if (!_isClosed) {
        _setProductsUIState(UIState.error(GenericError()));
      }
    }
  }

  /// Load more products (pagination)
  Future<void> loadMoreProducts() async {
    if (_isClosed || !state.hasMorePages || state.productsState?.status == Status.LOADING) {
      return;
    }

    final nextPage = (state.meta?.page ?? 0) + 1;
    await fetchGpsProducts(page: nextPage);
  }

  /// Refresh products
  Future<void> refreshProducts() async {
    if (_isClosed) return;
    
    emit(state.copyWith(
      products: [],
      meta: null,
      hasMorePages: false,
      quantities: {},
      availableStocks: {},
    ));
    
    await fetchGpsProducts();
  }

  void _setProductsUIState(UIState<GpsProductListResponse> uiState) {
    if (!_isClosed) {
      emit(state.copyWith(productsState: uiState));
    }
  }

  /// Search products locally
  void searchProducts(String query) {
    if (_isClosed) return;
    
    emit(state.copyWith(searchQuery: query));
  }

  /// Get filtered products based on search query
  List<GpsProduct> get filteredProducts {
    if (state.searchQuery.isEmpty) {
      return state.products;
    }
    
    return state.products.where((product) {
      return product.name.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
             (product.part?.toLowerCase().contains(state.searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  /// Increment product quantity
  void incrementQuantity(String productId) {
    if (_isClosed) return;
    
    final updated = Map<String, int>.from(state.quantities);
    updated[productId] = (updated[productId] ?? 0) + 1;

    emit(state.copyWith(quantities: updated));
  }

  /// Decrement product quantity
  void decrementQuantity(String productId) {
    if (_isClosed) return;
    
    final updated = Map<String, int>.from(state.quantities);
    final currentQty = updated[productId] ?? 0;

    if (currentQty > 0) {
      updated[productId] = currentQty - 1;
      emit(state.copyWith(quantities: updated));
    }
  }

  /// Try to increment quantity with stock validation
  Future<void> tryIncrementQuantity(String productId) async {
    if (_isClosed) return;
    
    final stockResult = await _repository.fetchAvailableStock(productId: productId);

    if (stockResult is Success<int>) {
      final availableStock = stockResult.value;
      final currentQty = state.quantities[productId] ?? 0;

      if (currentQty < availableStock) {
        final updatedQuantities = Map<String, int>.from(state.quantities);
        updatedQuantities[productId] = currentQty + 1;
        emit(state.copyWith(quantities: updatedQuantities));
      } else {
        // Stock limit reached - could emit an event or use a callback
        print('⚠️ Cannot increment quantity - stock limit reached for product $productId');
      }
    } else {
      print('❌ Failed to check stock availability for product $productId');
    }
  }

  /// Update quantities with new values
  void updateQuantities(Map<String, int> updatedQuantities) {
    if (_isClosed) return;
    
    emit(state.copyWith(quantities: Map.from(updatedQuantities)));
  }

  /// Clear quantities
  void clearQuantities() {
    if (_isClosed) return;
    
    emit(state.copyWith(quantities: {}));
  }
} 