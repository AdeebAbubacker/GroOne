import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'hide_success_kyc_status_state.dart';

class HideSuccessKycStatusCubit extends Cubit<bool> {
  HideSuccessKycStatusCubit() : super(false){
    _startTimer();
  }

  void _startTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    emit(true);
  }

}
