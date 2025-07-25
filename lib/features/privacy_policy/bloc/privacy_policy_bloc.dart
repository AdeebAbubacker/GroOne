import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/privacy_policy/model/privacy_policy_model.dart';
import 'package:gro_one_app/features/privacy_policy/repository/privacy_repository.dart';

part 'privacy_policy_event.dart';
part 'privacy_policy_state.dart';


class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  final PrivacyRepository _privacyRepository;
  PrivacyPolicyBloc(this._privacyRepository) : super(PrivacyPolicyInitial()) {

        on<PrivacyPolicyRequested>((event, emit) async {
      emit(PrivacyPolicyLoading());
      Result result = await _privacyRepository.getPrivacyPolicyData();

      if (result is Success<PrivacyDetailsModel>) {
        emit(PrivacyPolicySuccess(result.value));
      } else if (result is Error) {
        emit(PrivacyPolicyError(result.type));
      } else {
        emit(PrivacyPolicyError(GenericError()));
      }
    });
  }
}
