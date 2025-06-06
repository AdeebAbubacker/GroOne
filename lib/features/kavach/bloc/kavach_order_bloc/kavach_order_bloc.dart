import 'package:bloc/bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_event.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_state.dart';
import 'package:gro_one_app/features/kavach/repository/kavach_repository.dart';
import '../../../../data/model/result.dart';
import '../../../login/repository/user_information_repository.dart';


class KavachOrderBloc extends Bloc<KavachOrderEvent, KavachOrderState> {
  final KavachRepository repository;
  final UserInformationRepository _userInformationRepository;

  KavachOrderBloc(this.repository, this._userInformationRepository) : super(KavachOrderInitial()) {
    on<KavachSubmitOrder>(_onSubmitOrder);
  }

  Future<void> _onSubmitOrder(
      KavachSubmitOrder event,
      Emitter<KavachOrderState> emit,
      ) async {
    emit(KavachOrderSubmitting());

    final result = await repository.createOrder(event.request);

    if (result is Success) {
      emit(KavachOrderSuccess());
    } else if (result is Error) {
      emit(KavachOrderFailure(result.type.toString()));
    }
  }


  String? _userId;
  String? get userId => _userId;
  Future<String?> getUserId() async {
    _userId = await _userInformationRepository.getUserID();
    return _userId;
  }
}
