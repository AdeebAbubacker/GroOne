import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'product_counter_state.dart';

class ProductCounterCubit extends Cubit<ProductCounterState> {
  ProductCounterCubit() : super(ProductCounterInitial());
}
