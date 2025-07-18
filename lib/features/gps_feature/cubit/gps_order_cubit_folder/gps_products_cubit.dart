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
        
        emit(state.copyWith(
          products: response.data?.rows ?? [],
          meta: response.data?.meta,
          hasMorePages: (response.data?.meta.totalPages ?? 0) > page,
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
} 