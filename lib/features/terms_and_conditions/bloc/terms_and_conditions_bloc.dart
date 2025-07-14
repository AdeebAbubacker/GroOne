import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/terms_and_conditions/model/terms_and_conditions_model.dart';
import 'package:gro_one_app/features/terms_and_conditions/repository/t_and_c_repository.dart';

part 'terms_and_conditions_event.dart';
part 'terms_and_conditions_state.dart';

class TermsAndConditionsBloc extends Bloc<TermsAndConditionsEvent, TermsAndConditionsState> {
  final TAndCRepository _tAndCRepository;
  TermsAndConditionsBloc(this._tAndCRepository) : super(TermsAndConditionsInitial()) {

        on<TermsAndConditionsRequested>((event, emit) async {
      emit(TermsAndCondtionsLoading());
      Result result = await _tAndCRepository.getTermsAndConditionsData();

      if (result is Success<TermsAndconditionsModel>) {
        emit(TermsAndCondtionsSuccess(result.value));
      } else if (result is Error) {
        emit(TermsAndCondtionsError(result.type));
      } else {
        emit(TermsAndCondtionsError(GenericError()));
      }
    });
  }
}
