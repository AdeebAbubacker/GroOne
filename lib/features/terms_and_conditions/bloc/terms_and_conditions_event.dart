part of 'terms_and_conditions_bloc.dart';

sealed class TermsAndConditionsEvent extends Equatable {
  const TermsAndConditionsEvent();

  @override
  List<Object> get props => [];
}



class TermsAndConditionsRequested extends TermsAndConditionsEvent {
  TermsAndConditionsRequested();
}


