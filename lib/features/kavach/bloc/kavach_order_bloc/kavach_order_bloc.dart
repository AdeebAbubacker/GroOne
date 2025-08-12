import 'package:bloc/bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_event.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_state.dart';
import 'package:gro_one_app/features/kavach/repository/kavach_repository.dart';
import '../../../../data/model/result.dart';
import '../../../login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_order_added_success_response.dart';


class KavachOrderBloc extends Bloc<KavachOrderEvent, KavachOrderState> {
  final KavachRepository repository;
  final UserInformationRepository _userInformationRepository;
  String? paymentRequestId;

  KavachOrderBloc(this.repository, this._userInformationRepository) : super(KavachOrderInitial()) {
    on<KavachSubmitOrder>(_onSubmitOrder);
    on<KavachInitiatePayment>(_onInitiatePayment);
  }

  Future<void> _onSubmitOrder(
      KavachSubmitOrder event,
      Emitter<KavachOrderState> emit,
      ) async {
    emit(KavachOrderSubmitting());

    final result = await repository.createOrder(event.request);

    if (result is Success) {
      // Extract order ID from response if available
      String? orderId;
      try {
        // You might need to modify the createOrder response to include orderId
        // For now, we'll use a placeholder
        orderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";
      } catch (e) {
        // If orderId extraction fails, continue without it
      }
      emit(KavachOrderSuccess(orderId: orderId));
    } else if (result is Error) {
      emit(KavachOrderFailure(result.type.toString()));
    }
  }

  Future<void> _onInitiatePayment(
      KavachInitiatePayment event,
      Emitter<KavachOrderState> emit,
      ) async {
    emit(KavachPaymentInitiating());

    final result = await repository.initiatePayment(event.request);

    if (result is Success<OrderAddedSuccess>) {
      paymentRequestId = result.value.data?.data?.paymentRequestId;
      emit(KavachPaymentSuccess(result.value));
    } else if (result is Error) {
      final error = result as Error;
      emit(KavachPaymentFailure(error.type.toString()));
    }
  }


  String? _userId;
  String? get userId => _userId;
  Future<String?> getUserId() async {
    _userId = await _userInformationRepository.getUserID();
    return _userId;
  }
}
