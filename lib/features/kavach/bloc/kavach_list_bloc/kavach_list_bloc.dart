import 'package:bloc/bloc.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_list_event.dart';
import 'kavach_list_state.dart';

class KavachBloc extends Bloc<KavachEvent, KavachState> {
  final KavachRepository repository;

  KavachBloc(this.repository) : super(KavachState.initial()) {
    on<FetchKavachProducts>(_onFetch);
    on<IncrementQuantity>(_onIncrement);
    on<DecrementQuantity>(_onDecrement);
  }

  Future<void> _onFetch(FetchKavachProducts event, Emitter<KavachState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final products = await repository.fetchProducts(search: event.search);
      final quantities = {
        for (var product in products) product.id: state.quantities[product.id] ?? 0,
      };
      emit(state.copyWith(products: products, quantities: quantities, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  void _onIncrement(IncrementQuantity event, Emitter<KavachState> emit) {
    final updated = Map<String, int>.from(state.quantities);
    updated[event.productId] = (updated[event.productId] ?? 1) + 1;
    emit(state.copyWith(quantities: updated));
  }

  void _onDecrement(DecrementQuantity event, Emitter<KavachState> emit) {
    final updated = Map<String, int>.from(state.quantities);
    if ((updated[event.productId] ?? 1) > 0) {
      updated[event.productId] = updated[event.productId]! - 1;
      emit(state.copyWith(quantities: updated));
    }
  }
}
